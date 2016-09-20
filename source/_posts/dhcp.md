---
title: 随手记录DHCP
date: 2016-08-29 00:00:00
categories:
- code
tags: 
- DHCP
- wireshark
mathjax: true
description: 
---

同事用PXE装系统，在装完最小系统后，会再次获取IP，然而DHCP却给了一个不一样的IP

<!--more-->
# 网上别人抓的正常包
![get](https://github.com/CodeJuan/blog/raw/master/source/image/dhcp/pxe_dhcp_normal.jpg)
可以看到
1. 装miniOS之前Discover,offer,request,ack
2. 完成miniOS之后，request,ack

# 同事抓的包
没有办法带出公司，只能凭记忆
1. 装miniOS之前Discover,offer,request,ack
2. 完成miniOS之后，**Discover,offer**,request,ack
3. 由于Discover了两次，所以得到了两个IP


# 疑问
为什么会Discoverr两次？即使是Discover两次，那么对于同一个mac，DHCP也应该分配同样的IP吧？
DHCP的配置里有一个忽略clientID的参数

# 复习DHCP流程
![](http://s3.51cto.com/wyfs02/M02/7B/63/wKioL1bM12-TVB73AAKfYIzxVJg695.png)

> 参考[http://tasnrh.blog.51cto.com/4141731/1744495](http://tasnrh.blog.51cto.com/4141731/1744495)
**DHCP发现（DISCOVER）**
目标设备在物理子网上发送广播来寻找可用的服务器。网络管理员可以配置一个本地路由来转发DHCP包给另一个子网上的DHCP服务器。该目标设备实现生成一个目的地址为255.255.255.255或者一个子网广播地址的UDP包。
**DHCP提供（OFFER）**
当DHCP服务器收到一个来自目标设备的IP租约请求时，它会提供一个IP租约。DHCP为目标设备保留一个IP地址，然后通过网络单播一个DHCPOFFER消息给目标设备。该消息包含目标设备的MAC地址、服务器提供的IP地址、子网掩码、租期以及提供IP的DHCP服务器的IP。
服务器基于在CHADDR字段指定的目标设备硬件地址来检查配置。这里的服务器，10.1.1.1，将IP地址指定于YIADDR字段。
**DHCP请求（REQUEST）**
当目标设备PC收到一个IP租约提供时，它必须告诉所有其他的DHCP服务器它已经接受了一个租约提供。因此，该目标设备会发送一个DHCPREQUEST消息，其中包含提供租约的服务器的IP。当其他DHCP服务器收到了该消息后，它们会收回所有可能已提供给目标设备的租约。然后它们把曾经给目标设备保留的那个地址重新放回到可用地址池中，这样，它们就可以为其他计算机分配这个地址。任意数量的DHCP服务器都可以响应同一个IP租约请求，但是每一个目标设备网卡只能接受一个租约提供。
**DHCP确认（Acknowledge，ACK）**
当DHCP服务器收到来自目标设备的REQUEST消息后，它就开始了配置过程的最后阶段。这个响应阶段包括发送一个DHCPACK包给目标设备。这个包包含租期和目标设备可能请求的其他所有配置信息。这时候，TCP/IP配置过程就完成了。



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


