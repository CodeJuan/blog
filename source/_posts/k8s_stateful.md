---
title: kubernetes尝试有状态服务
date: 2016-08-03 00:00:00
categories:
- code
tags: 
- docker
- kubernetes
- stateful
mathjax: true
description: 
---

# 有状态服务的概念
既然名叫有状态，那么就与之相对，会有我们很熟悉的无状态。无状态的概念，就是只负责运算，不负责任何数据的存储，这样就能很轻松地做到水平扩展。
> 之前写的关于无状态的例子


那么，有状态的概念又是什么呢，简单来说，就是会有数据的存储，需要持久化。

<!--more-->
# k8s的1.3
petset

# 参考
- [构建可伸缩的有状态服务](http://www.infoq.com/cn/news/2015/12/scaling-stateful-services)
- [无状态服务 vs 有状态服务](http://docs.alauda.cn/feature/service/stateless-service-and-stateful-service.html)
- [Pet Sets](http://kubernetes.io/docs/user-guide/petset/)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/



