---
title: 讲讲缓存
date: 2015-12-14 00:00:00
categories:
- code
tags: 
- cache
- storage
mathjax: true
description: 
---

# 背景

缓存，可以说在计算机体系到处被用到。
- CPU有指令缓存，还有L1L2L3缓存；
- 磁盘为了提高性能也有缓存；
- 就拿web开发来说，也会将经常访问的内容放到离用户更近的服务器上。

为何缓存的使用如此普遍？这个问题的确值得深入探讨一下。

<!--more-->

# 存储金字塔

首先要说的算存储金字塔，如下图所示

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cache/hierarchy.jpg)

可以看到，从上往下，速度越慢，容量越大，相应的成本就越低。

如果成本允许的情况下，我们自然尽量采购金字塔顶端的设备，然而现实却是残酷的，我们没有那么多资源可以挥霍。

# 缓存的概念

在计算机体系中，缓存的概念其实是相对的。
- 寄存器是L1的缓存
- L1是L2的缓存
- CPU缓存是内存的缓存
- 内存是硬盘的缓存

# CPU Cache hit & miss

我不说话，我只上图，能用图说清楚的，我就不说话。

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cache/the-memory-system-15-638.jpg)

## 这里顺便提以下CPU的提前预取？

> 为了利用空间局部性，同时也为了覆盖传输延迟，可以随机性地在数据被用到之前就将其取入缓存。这一技术称为预取（Prefetch）。本质上讲，加载整个缓存块其实即是一种预取。

大概就是，CPU会提前给你把数据取过来，如果取到的数据正好是你要用的数据，那么恭喜你，速度会很快。

## 阶梯延时

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cache/cpu_cache.jpg)

# 内存数据库

也是将热点数据放在内存中，相当于是把内存当作硬盘的缓存

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cache/redis-memcached-pdf-12-728.jpg)

# 硬盘自身的缓存

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cache/disk.jpg)

# CDN

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cache/cache-hit-ratio-latency-graph.png)

# 总结
- 可以看到，缓存命中的性能会比缓存miss高很多
- 合理利用缓存，将热点数据放在缓存中
- 缓存的概念很广泛，不仅仅是CPU缓存




----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

