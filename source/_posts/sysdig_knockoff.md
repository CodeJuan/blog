---
title: 山寨版sysdig cloud
date: 2016-12-6 00:00:00
categories:
- code
tags: 
- APM
- tracing
mathjax: true
description: 
---

调用链分析有三种模式：
1. 白盒，zipkin
2. 灰盒，pinpoint，往JVM里注入
3. 黑盒，优点是难度大，精度一般，优点是不用改代码

之前分析的sysdig就算是黑盒,[http://blog.decbug.com/2016/10/12/sysdig/](http://blog.decbug.com/2016/10/12/sysdig/)，恰好有需求说想不改代码，由容器云平台提供调用链分析。

参考了几篇论文及业内快讯之后，
- IBM的[Real-time Performance Profiling & Analytics for Microservices using Apache ](http://www.spark.tc/real-time-application-performance-profiling-using-spark/)
- MIT的[Performance Debugging for Distributed Systems of Black Boxes](https://pdos.csail.mit.edu/~athicha/papers/blackboxes:sosp03.pdf)

花了一周时间在k8s上做出来了，当然，由于缺乏算法支持，目前只做到了点对点的调用topo及http,memcached的时延，后面有空再补齐MySQL等等。

<!--more-->

# 方案
- 用开源sysdig做采集
- 参考http_log和memorycache，自己写了个Chisel做过滤分析
- 过滤后的日志print到std output，然后打到起了syslog的logstash容器
- logstack到elastic search
- 之后写个可视化的web服务，根据用户的查询条件，把对应的topo及时延画出来，就可以辅助诊断性能问题


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/



