---
title: 阿里云容器服务分析
date: 2016-12-05 01:00:00
categories:
- code
tags:
- container
- docker
mathjax: true
description: 
---

分析一下阿里云容器服务

<!--more-->

# 计算调度
- swarm
- 用户先买几台虚拟机，之后在虚拟机上安装swarm
- 利用阿里云已有能力，在I层就实现了租户隔离
- 用户的集群规模不会很大，swarm的调度也能跟上
- 疑问：资源利用率？这不算是个PaaS吧
![](http://dockerone.com/uploads/article/20160420/979b0743ac5f99e1467721b4cf6a8393.png)

# 网络
- 阿里云vswitch, vrouter
- 利用阿里云已有IaaS的能力，不用overlay over overlay
- 性能好
- 其他容器厂商没有I层的能力，果然是大树底下好乘凉
![](http://dockerone.com/uploads/article/20160420/cd9e52ae1faba951eabe808d2a1ffbf3.png)


# 存储
- 扩展了plugin，可以接入OSS作为卷挂载到宿主机，之后mount到容器
- 依然是大树下好乘凉
- 卖容器的同时，还能卖OSS

# 其他
- 可以接入阿里云的各种服务，如LB，redis，mysql
- 看来是想构建阿里云全家桶，可以卖出更多产品，很好的思路


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


