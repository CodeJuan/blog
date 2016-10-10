---
title: VxLan原理
date: 2016-10-09 00:00:00
categories:
- code
tags: 
- VxLan
mathjax: true
description: 
---

VxLan，网络虚拟化，应用很广泛

简单记录一下原理

<!--more-->

![Frame Format](http://www.aboutyun.com/data/attachment/forum/201501/12/200932g95t3x5zlllv0cn3.jpg)

![](http://www.aboutyun.com/data/attachment/forum/201501/12/201142n2mmll72er7pldlp.jpg)

1. VM1发送IP数据包到VM2，即192.168.0.100 到 192.168.0.101；
1. VTEP1查找自己的VXLAN表知道要发给VTEP2，然后依次封装以下数据包头；
  - VXLAN包头
  - 标准UDP包头，校验和checksum为0x0000；
  - 标准IP包头，目标地址为VTEP2的IP地址，协议号设为0x11表面为UDP包。
  - 标准MAC数据包，目标地址为下一跳设备的MAC地址00:10:11:FE:D8:D2，可路由到目标隧道端VTEP2。
1. VTEP2接收数据包，根据UDP的destination端口找到VXLAN数据包。接着查找所有所在VXLAN的VNI为864的端口组，找到VM2的
1. VM2接收并处理数据包，拿到Payload数据。

# 参考
[http://www.aboutyun.com/thread-11189-1-1.html](http://www.aboutyun.com/thread-11189-1-1.html)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


