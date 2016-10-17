---
title: 通过libcap抓包
date: 2016-10-16 00:00:00
categories:
- code
tags: 
- tcpdump
mathjax: true
description: 
---

![image](https://cloud.githubusercontent.com/assets/5423628/19422110/910d9144-9441-11e6-87e8-a5919a41d8b1.png)

原理

<!--more-->


![image](https://cloud.githubusercontent.com/assets/5423628/19422117/a283aa58-9441-11e6-9276-16e9ba0ded25.png)

用的是libcap抓的ip及len都不对，于是不用普罗米修斯模式，len对了，但是ip还是不对。继续分析。

把抓到的首部都打出来，和用tcpdump抓到的进行比较，内容一致，那么说明抓包正确，只是我的解析代码不对

由于inet_ntoa是静态buffer，所以第二次和第一次一样，改成inet_ntop就好了，因为不是静态buffer

收获挺大，把ip和tcp首部的每个字节都搞明白了


# 参考
[http://www.cnblogs.com/Seiyagoo/archive/2012/04/28/2475618.html](http://www.cnblogs.com/Seiyagoo/archive/2012/04/28/2475618.html)
[http://www.tcpdump.org/](http://www.tcpdump.org/)
[http://recursos.aldabaknocking.com/libpcapHakin9LuisMartinGarcia.pdf](http://recursos.aldabaknocking.com/libpcapHakin9LuisMartinGarcia.pdf)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


