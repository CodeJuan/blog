---
title: openstack性能测试器(1):AMQP
date: 2015-10-16 00:00:00
categories:
- code
tags: 
- openstack
- perfmance
- AMQP
mathjax: true
description: 
---

# 背景
我司的公有云产品是基于OpenStack，一直以来都有做性能测试，但以前的性能测试方法比较老土。

- 有一部分基于http的消息是通过自己写的测试器来测试，即模拟真实场景的消息收发，测试各组件在高并发下的性能。
- 另外一些基于AMQP的消息则还是通过一堆虚拟机来做测试，需要耗费大量资源。

有鉴于此，需要再把测试器完善一下，使其能模拟OpenStack的各种组件，用有限的几台虚拟机，就能完成所有组件的性能测试。
而作为什么都会一点的牛X人物，自然少不了被派来开荒。正好可以借此机会深入了解一下OpenStack，以前只是久闻其名，无缘深入探究，这次终于得偿所望。
嘎嘎嘎！！
<!--more-->

# AMQP
要想做好模拟器，就需要了解AMQP协议，以及此协议在OpenStack中的应用场景。






----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

