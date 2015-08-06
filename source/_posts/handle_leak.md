---
title: 抄代码引发的句柄泄漏
date: 2015-08-06 00:00:00
categories:
- code
tags: 
- leak
- windows
- C++
mathjax: true
description: 
---


# 背景

## 现象
主进程不断调用7z.exe进行解压，当文件数量较小时，顺利运行。当文件数量达到几十万的时候，运行过程中7z报错，fatal error 2。
网上很多同僚说这是由于系统资源不足造成的。观察此时的内存及磁盘使用情况，都很充裕，但为何还说资源不足呢？于是开启了蛋疼的定位之旅，至于为什么说很蛋疼呢，这是因为是一个低级错误导致的问题。

心急的朋友可以直接看原理:[https://github.com/CodeJuan/HandleLeak](https://github.com/CodeJuan/HandleLeak)

不着急的朋友可以慢慢看定位过程

<!--more-->

# 句柄






# 结论
1. 抄代码一定要小心谨慎，需要仔细阅读官方说明，把参数的意义都理解清楚
2. 仅仅跑起来，凑合着用是不够的，需要做一做压力测试
3. 这次看句柄的方式比较落伍，需要整理一下如何用windbg查句柄泄漏的方法，下一篇就写这个吧。

-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

