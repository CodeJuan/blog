---
title: 云计算网络安全
date: 2017-03-03 00:00:00
categories:
- code
tags: 
- cloud
- security
mathjax: true
description: 
---

近日关于云计算安全的问题，闹的沸沸扬扬。某不才，也算是云计算入门人士，便结合自身经历分析一番。

<!--more-->

# 也曾被黑过
当时用的阿里云华北1，只有经典网络。那时候很天真，以为即使是经典网络，那么也是租户隔离的。为了便于几台机器互相调用，于是把安全组设置为内网入，所有协议，所有IP，所有端口都允许。

然而几天以后，某个机器无法SSH上去，通过vnc一看，不得了，竟然内核都被人改了。当时百思不得其解，我这个机器完全没有连外网啊，怎么会被黑呢？怎么会呢？

后来才知道经典网络是互通的，相互之间的隔离是通过安全组。默认的安全组是全部拒绝的，如果不是我手贱，就不会那么容易被黑。

# 也谈VPC
具体细节不谈了，之前也看过VxLan的原理。如果想深入，看看neurtron的组网就明白了，net，subnet，port

所谓VPC，就是隔离隔离隔离，简单来说，就是对于虚拟机所看到的网络，和别人的网络是不通的。如果当时用的VPC，就已经和其他租户隔离了，被黑的概率大为降低。

# 阿里云容器服务
分析清除了之前被黑的原因，便看了看我阿里云下的安全组，发现竟然有两条不是我自己创的。看了下名字以及创建时间，想起来是之前用容器服务的时候创建的。

再打开规则一看，一看吓一跳

授权策略|协议类型|端口范围|授权类型|授权对象|优先级|操作
---|---|---|---|---|---|---
允许|全部|-1/-1|地址段访问|0.0.0.0/0|1|克隆 删除

竟然是全部允许。后来联系阿里云容器服务的易立大侠，报告这个安全问题，得知这个问题早已修复。

# 小结
能用VPC就用VPC，虽然会稍微复杂一点，但安全性大为提高。

另外再问一句，为啥阿里云华北1只有经典网络？就因为比其他region便宜10%？

# 备份

[云舒：给小白的租户隔离科普文](https://www.v2ex.com/t/343762?from=groupmessage&isappinstalled=0)
[左耳朵耗子：科普一下公有云的网络](http://weibo.com/ttarticle/p/show?id=2309404079443999097225)


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


