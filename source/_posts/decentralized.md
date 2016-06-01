---
title: 一次去中心化的性能优化
date: 2015-12-15 00:00:00
categories:
- code
tags: 
- optimization
- decentralized
mathjax: true
description: 
---

# 前言
一个分布式计算系统，在数据量越来越大的情况下，处理时间太久，不符合用户需求，需要优化。

经过分析，发现有一个从存储节点把数据拷贝到计算节点的动作，这个过程比较耗时间。如果能把这个拷贝过程去掉，对于系统的整体性能将会有很大提升。

<!--more-->

# 过程

## 原来的流程

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/decentralized/data2compute.jpg)

如图，为简化流程，只画了一个存储节点和计算节点`典型的数据向计算迁移`，当数据特别大（数十G～百G）的时候，从存储节点拷贝到计算节点将特别耗时间。

而计算工具的身材特别苗条，几百M而已，拷贝过去也就是分分钟的事，如果能把计算工具放到存储节点，拷贝的时间就可以忽略不计，这个方法叫`计算向数据迁移`



## 优化后的流程

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/decentralized/compute2data.jpg)

只是把百兆的计算工具拷过去，省去以前拷贝几百G数据的步骤～



# 结论

虽然不是什么很新的技术，但是简单几步就解决了业务问题，还是比较值得高兴一下的。

后面如果能把计算工具封装成docker，放到docker registry上去，每次计算的时候，存储节点把镜像pull过来，应该会比较好玩吧～

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

