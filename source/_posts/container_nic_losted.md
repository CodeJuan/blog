---
title: 容器内reboot导致网卡丢失
date: 2017-05-28 01:00:00
categories:
- code
tags:
- container
- network
mathjax: true
description: 
---

# 问题描述
在搞docker和lxc的结合体，也叫system container或machine container[http://blog.decbug.com/lxc_docker/](http://blog.decbug.com/lxc_docker/)

其实阿里在16年就已经做了类似的工作，结合lxc和docker完成了alidocker，有时候真心觉得互联网公司好厉害啊，技术领先了我等很多年。

闲话休提，言归正传。话说在改造之后，可以在容器内执行reboot。但是，在reboot之后，发现网卡丢了。

<!--more-->

# 先讲一下挂网卡的方案
我是基于openstack来发放容器，网络方案自然是用neutron了
```
+----------------------------------+
|         container                |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|       +---------------+          |
|       |  veth pair    |          |
|       |  ns-xxxxxxx   |          |
+-------+------+--------+----------+
               |
               |
               |
               |
        +------+--------+
        | veth pair     |
        | tap-xxxxx     |
     +--+---------------+---+
     |                      |
     |      qbr-xxxxx       |
     +----------+-----------+
                |
                |
     +----------+----------+
     |  qvo,qvb,ply,plm    |
     |  与本文无关不细说      |
     +----------+----------+
                |
                |
                |
      +---------+----------+
      |                    |
      |    br-tun          |
      +--------------------+
```

# 分析
用十万个为什么来探究答案
- 为何ns-xxxxx网卡会丢？那么对应的tap-xxxx是不是也丢了？
- 通过ip a查看宿主机上的设备，tap不见了。原因在于veth pair是成对出现的，丢一个就等于丢一对。那么qbr还在不在呢？
- brctl show，qbr还在
- 在容器内执行reboot引起网卡丢失，reboot会停止init进程，使得容器的网络命名空间消失
- When a IPC namespace is destroyed(i.e., When the last process that is a member of the namespace terminates), all IPC objects In the namespace are automatical destroyed.
- When a network namespace is freed, its physical network devices are moved back to the initial network namespace. But how about the virtual network device?经过试验，虚拟设备会消失
- 这样就可以解释为何veth pair丢失的原因了

# 解决办法
## 失败的尝试
有同事提到，可以参考虚拟机的做法，只创一个tap在qbr上，然后把tap挂到容器的namespace。据我看来，这个是不可行的，当tap设备从宿主机namespace挂到容器namespace，此tap与qbr的连接就会断开，网络就中断了。
虽然我有理论依据，但还是需要实际验证一下，方法如下：
- 创一个tap,挂到docker0，ip addr add设置IP并up
- 在docker0上的另一个容器里ping这个tap，可以通
- ip link set dev tap netns xxx，挂到netns xxx
- ip netns exec xxx ip addr add 设置同样的IP
- ip netns exec xxx ip route add default via <docker0 IP>
- 在docker0上的另一个容器里ping这个tap，不通

 ## 参考lxc的做法
 > lxc在lxc.conf，保存了veth的Mac，IP，名字以及接到哪个qbr上

 我们在挂网卡的时候，也保存类似的配置，在容器start的时候，会检测是否有网卡，如果没有则挂上。



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


