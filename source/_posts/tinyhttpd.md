---
title: 读tinyhttpd源码笔记
date: 2016-05-09 00:00:00
categories:
- code
tags: 
- tinyhttpd
- httpserver
mathjax: true
description: 
---

# 背景

C语言实现的http server，代码简短，看完可以明了原理。

<!--more-->

# 流程
![](https://raw.githubusercontent.com/CodeJuan/codejuan.github.io/master/images/blog/tinyhttpd/flow.jpg)

- startup，创建socket，bind，listen
- accept request
- 获取请求，读header
- 是否GET 或 POST
- 读content length
- 写header 200
- GET就serve file，cat index.html 到 send
- POST就创建pipe执行脚本，结果send




----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

