---
title: 学golang(2):web框架
date: 2015-12-15 00:00:00
categories:
- code
tags: 
- golang
mathjax: true
description: 
---

# 背景

上回已经把revel下载好了，顺利搞出个hello world，

[http://blog.decbug.com/2015/11/28/golang/](http://blog.decbug.com/2015/11/28/golang/)



<!--more-->

# beego

接下来就要深入学习一下了，用revel弄一个restful api玩玩。然而由于revel写restful api太难了，于是改为使用比较出名的`beego`，国人出品的框架，不知效果如何。

老规矩，从hello world开始

## 安装
```sh
# 安装框架
go get github.com/astaxie/beego
# 安装工具
go get github.com/beego/bee
```

## 建立工程

```sh
cd $GOPATH/src
bee new test_beego
```

## 运行

```sh
cd test_beego
bee run
```

![](http://beego.me/docs/images/beerun.png)

## 围观源码

放弃

# revel
回归revel



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

