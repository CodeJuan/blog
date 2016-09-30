---
title: 分布式系统调度算法的公平
date: 2016-09-30 00:00:00
categories:
- code
tags: 
- scheduler
- fair
mathjax: true
description: 
---

调度，在计算机世界里随处可见，只要有资源抢占，就需要调度。

![无调度](http://a3.att.hudong.com/78/47/01300000763638128366476399672.jpg)

![有调度](http://img.www.zyue.com/news/2011/04/06/201104060829106892011040202.jpg)

<!--more-->
# CFS
操作系统要调度一堆进程，也是离不开调度算法的，linux喜欢用CFS，这里可以稍微扩展记录一下，加深印象

# 分布式系统的调度
公平与不公平
所谓公平，就是人人有饭吃，不能有人饿死

## 不公平
- job1先来，job1有很多个task，就开始执行job1的task
- 之后job2过来，但是job1的task还没执行完，那么job2就要一直等待，这就叫饥饿

## 公平
公平就是，大家都有饭吃
- job1先来，job1有很多个task，开始执行job1的task
- 然后job2过来，这时候job1的task还有一些没有执行完
- 调度器就会block job1，也就是说，会把job1剩余的task挂起
- 开始执行job2的task
- 一段时间后，由于job1饥饿了，所以又把job2 block，执行job1的task




----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


