---
title: 优化草稿
date: 2014-05-06 00:00:00
categories:
- code
tags: 
- optimize
mathjax: true
description: 
---


### 背景
用于大数据分析，追求速度，将所有数据都放于内存处理。分为：业务模块层，框架层，表现层。

### 流程

1. 用户点击运行。
2. 框架层从文件中读入数据，进行预处理，放入内存，传递给业务层。
3. 业务层从内存中获取数据，进行二次处理，生成结果。

循环2与3，直至处理完全部文件。

<!--more-->

随手画下流程图，家里电脑没有合适的工具，将就着画吧。

![](https://raw.githubusercontent.com/CodeJuan/codejuan.github.io/master/images/blog/draft_optimize/workflow1.png)

### 现状
如前文所示，业务模块是串行处理，CPU利用率25%，偶尔在会到80% 以上，利用不够充分。由于windows32位单个进程只能用4G内存，其中内核2G，用户只能使用2G。目前已出现内存不足的情况（new申请内存失败），当数据继续膨胀，2G内存必然远不够用。业务模块的代码不够规范，内存泄漏比较多，影响到整体运行。

### 想点办法
由单进程改为多进程

- 并发以压榨CPU，根本闲不下来。
- 每个业务件都是一个进程，都可用2G内存，可以容纳更大的数据，并且不会互相干扰。
- 增加一个数据层，将框架层与业务层隔离。

![](https://raw.githubusercontent.com/CodeJuan/codejuan.github.io/master/images/blog/draft_optimize/workflow2.png)


-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

