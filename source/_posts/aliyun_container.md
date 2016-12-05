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

分析一下aliyun容器服务用到的技术

<!--more-->

# 计算调度
- swarm
- 在用户已有集群上安装swarm，利用阿里云已有的租户隔离
![](http://dockerone.com/uploads/article/20160420/979b0743ac5f99e1467721b4cf6a8393.png)

# 网络
- 阿里云vswitch, vrouter
- 利用阿里云已有IaaS的能力，避免overlay over overlay
- 性能好
![](http://dockerone.com/uploads/article/20160420/cd9e52ae1faba951eabe808d2a1ffbf3.png)


# 存储
扩展了plugin，可以接入OSS作为卷挂载到宿主机，之后mount到容器

# 其他
- 可以接入阿里云的各种服务，如LB，redis，mysql
- 阿里云全家桶，可以卖出更多产品


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


