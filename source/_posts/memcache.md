---
title: 读memcache源码笔记
date: 2016-05-04 00:00:00
categories:
- code
tags: 
- cache
- memcache
mathjax: true
description: 
---

# 背景

memcache应用很广泛，听说内存管理做的很好，以及通过事件驱动的方式效率很高，于是找来看看。

<!--more-->

# 内存
举例子，疯狂动物城里有各种体型的动物，分别安置在不同的城区的街道上的房子里。例如小老鼠在微型动物区，朱迪在小动物区，牛局长在大动物区，大象在大型动物区。
- 先划分城区
- 再修路
- 再盖房子
- 分配房间
- 盖好的房子不拆，如果拆了再盖，会浪费资源。内存释放分配的开销很大

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/memcache/mem.jpg)



# 流程
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/memcache/flow.jpg)

# 总结



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

