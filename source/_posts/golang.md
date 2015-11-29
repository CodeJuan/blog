---
title: 初学golang
date: 2015-11-28 00:00:00
categories:
- code
tags: 
- golang
mathjax: true
description: 
---

# 背景

最近经常听到有同事在安利golang，颇为心动。恰巧又看到这篇文章[How We Moved Our API From Ruby to Go and Saved Our Sanity](http://blog.parse.com/learn/how-we-moved-our-api-from-ruby-to-go-and-saved-our-sanity/)，于是便忍不住了，打算试试。
毕竟是谷歌亲儿子，想必会有一番不错的表现。

<!--more-->

# 安装go

## yum安装
原本以为需要用源码来安装，上网查了一下，得知centos7可以直接`yum`安装，so easy。

# hello world

创建一个hello.go，内容如下
```go
package main
import "fmt"
func main() {
     fmt.Println("Hello, World!")
}
```

然后go run hello.go

--------------------------------------------------------------



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

