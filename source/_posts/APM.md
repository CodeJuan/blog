---
title: APM厂商分析
date: 2016-10-10 00:00:00
categories:
- code
tags: 
- APM
mathjax: true
description: 
---

在微服务大行其道的今天，系统的实例越来越多，出现性能问题时要调试就很困难。于是乎，就出现了许多APM厂商，只需要装一个agent，就能通过监控系统调用，网络传输，性能指标，辅助调试定位性能问题。

在公司分析了很多，也抓包了，详细内容带不出来。就简单记个笔记，供以后回忆

<!--more-->

# sysdig
分为[开源版sysdig.org](https://github.com/draios/sysdig)和[商业版sysdig cloud](https://sysdig.com/)

## 开源
原理：抓内核级别的调用，比如read，write，网络也是read，write，只不过描述符不一样，然后形成事件，记录下来
还有个强大的功能Chisel，很好玩，可以自己扩展功能，用lua写
[Writing a Sysdig Chisel, a Tutorial](https://github.com/draios/sysdig/wiki/Writing-a-Sysdig-Chisel,-a-Tutorial)

## sysdig cloud
装一个agent，用的是开源的sysdig采集数据，然后上报到sysdig cloud的服务器。
- 可以展示topo，调用耗时等等
- 分析http，可以精确到url
- 通过分析开源代码，分析出具体的调用，原理应该和chisel中的memcache差不多

# 其他
dynatrace & apptrace



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


