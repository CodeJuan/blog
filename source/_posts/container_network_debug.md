---
title: 一次容器网络问题debug
date: 2017-01-03 01:00:00
categories:
- code
tags:
- docker
- network
mathjax: true
description: 
---

基于neutron做了一个容器网络方案，需要测试性能，用的iperf，但是在测试过程中，tcp/udp无法抵达跨节点的容器中

<!--more-->

# 问题描述
网络组好之后，跨宿主机的容器相互可以ping通，但是在用iperf测试的时候
1. tcp：client端一直显示带宽为0，server端显示建立连接，但是一直显示收到0字节
2. udp：client端显示12G的带宽，server端只显示建立连接，但没有其他响应。

顺便说一下一直以来对于VxLan的一个疑惑，VxLan是通过udp发送，那么如何保证数据可靠传输呢？是不是udp里封了tcp的包，如果udp丢失了数据

# 定位过程
1. 在容器A里起一个python SimpleHTTPServer，在容器B里curl这个server。A容器收到请求，并且响应，但是B容器没有收到响应
1. 猜测是不是安全组的问题？于是neutron secure-group-create 端口从1到65535，ingress egress，tcp udp都加上，再次curl，还是不通
1. 用tcpdump同时在server端和client端抓包，保存起来
1. 在两个宿主机起python server，也curl一次并抓包
1. 用wireshark对比两次的包，发现容器里curl多了一个1518 length的包，于是猜测是不是MTU的问题？因为之前在看flannel的时候，需要在docker启动参数上设置MTU为1450
1. 分别在两个容器都设置mtu：ip netns 容器网络命名空间 ifconfig eth0 mtu 1400
1. 再次curl，容器B收到响应
1. 继续iperf，tcp的可以测通，性能和用neutron的虚拟机相似
1. 但是udp还是不通
1. 继续抓两个容器的docker0，可以收到数据
1. 两个veth，也可以收到
1. 但是在容器的eth0却收不到。按理说是veth pair，一端收到，另一端就肯定能收到。

看来还有问题，需要继续定位

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


