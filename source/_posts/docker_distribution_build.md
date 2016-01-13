---
title: docker(3)-搭建registry
date: 2016-01-12 00:00:00
categories:
- code
tags: 
- docker
- docker-registry
- docker-distribution
mathjax: true
description: 
---

# 背景
关于registry的基本知识已经了解差不多了，现在开始搭建一个可用的私有registry
<!--more-->

# 架构

![](http://dockerone.com/uploads/article/20150512/1e111941614512fcc0bdeb2e80ee9384.png)

就采用[钟成](http://dockone.io/people/%E9%9A%BE%E6%98%93)提到的架构

# 进展1
搭建了registry+front，配置了https
折腾一天，累成狗了，不详细写拉。直接看代码吧，都写成脚本和compose了
[https://github.com/CodeJuan/private_registry](https://github.com/CodeJuan/private_registry)

# 进展2
还要实现后端镜像存储和前端负载均衡，明天继续吧

# 参考
[关于私有安全docker registry的实验](http://www.mworks92.com/2016/01/13/secure-registry-test/)
[搭建Docker私有仓库Registry-v2](http://blog.gesha.net/archives/613/)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

