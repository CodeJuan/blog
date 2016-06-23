---
title: flannel与overlay
date: 2016-06-23 00:00:00
categories:
- code
tags: 
- network
- virtualization
- overlay
mathjax: true
description: 
---

正在搞docker与neutron融合，所以需要储备一些网络虚拟化知识，了解下原理

<!--more-->

# overlay
我的理解
- 复用已有物理网络，很容易搭建
- 有很好的开源组件，比如flannel
- 需要转发
- 需要对原报文进行封装和解释，因为会加上overlay的src ip和des ip
- 性能会损耗

阿里云的大侠们曾做过试验[原文链接](http://dockone.io/article/1232)
> Overlay网络的最大问题是性能很不理想。我们做了Overlay网络和非Overlay网络在各种数据包大小情况下的性能对比，tcp payload 20 bytes，Overlay性能大约 75%，tcp payload 1kbytes，Overlay性能80%，对于大块数据传输，Overlay性能大约88%，这个数字可以认为是 Overlay性能的极限了。当然，不同的场景下具体测试数字不一定完全一致，但Overlay的开销还是很大的。

# flannel
coreos的又一力作，docker生态常用组网方式

![](https://raw.githubusercontent.com/coreos/flannel/master/packet-01.png)

对于原理，我的理解
- flannel0网桥，连接docker0和flanneld
- flanneld通过etcd感知到网络内所有docker IP的变化，知道如果投递到其他宿主机上的flanneld
- docker daemon启动参数可以限制IP范围，避免冲突
- 从容器A到另外一台宿主机上的容器B，大概流程
  1. 报文到容器A的veth0
  2. 再到docker0
  3. 转到容器A所在宿主机的flanneld，简称flanneldA
  4. flanneldA，所谓的封装，src ip，des ip
  5. 投递到容器B所在宿主机的flanneld，简称flanneldB
  6. flanneldB解释，获取到des ip，取出原始报文，投递到容器B






----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


