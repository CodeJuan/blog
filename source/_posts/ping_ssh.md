---
title: TCPIP ping ssh
date: 2016-08-29 00:00:00
categories:
- code
tags: 
- TCPIP
- protocol
mathjax: true
description: 
---

数据库部署在k8s上，两个pod一主一备，却无法同步，一直同步失败，提示socket 什么什么什么。据同事说，还有一个现象是ping都会报错

<!--more-->
# ping
我看了下ping的报错,说permission啥啥啥的，于是谷歌一下，找到答案。是因为权限问题，用**chmod u+s /bin/ping**解决。

# 能ping通，为何还是传输有问题
因为ping是ICMP协议，基于IP层，能ping说，说明IP层是好的，无法确定TCP正常

# 尝试用SSH测试TCP是否正常
```
ssh -vvv [ip]

# 返回
debug1: Connection established.

debug1: Local version string SSH-2.0-OpenSSH_6.6.1p1 Ubuntu-2ubuntu2.8
debug1: Remote protocol version 2.0, remote software version OpenSSH_6.6.1p1 Ubuntu-2ubuntu2
debug1: match: OpenSSH_6.6.1p1 Ubuntu-2ubuntu2 pat OpenSSH_6.6.1* compat 0x04000000

debug1: SSH2_MSG_KEXINIT sent

```
1. 在`SSH2_MSG_KEXINIT`之后就没有了响应，
2. `debug1: Connection established.`说明tcp连接建立成功
3. 版本协商
    - `debug1: Local version string SSH-2.0-OpenSSH_6.6.1p1 Ubuntu-2ubuntu2.8`，本地ssh版本
    - `debug1: Remote protocol version 2.0, remote software version OpenSSH_6.6.1p1 Ubuntu-2ubuntu2`，远端版本
    - `debug1: match: OpenSSH_6.6.1p1 Ubuntu-2ubuntu2 pat OpenSSH_6.6.1* compat 0x04000000`
    - 说明成功通信一次
4. `debug1: SSH2_MSG_KEXINIT sent`，开始进行key的协商，然后就没有然后了

后面的定位过程，就涉及到容器组网方案，不适合公开。


# 顺便理解一下SSH协议
![capture](https://github.com/CodeJuan/blog/raw/master/source/image/ssh/capture.png)
1. 6,7,8握手
1. 9,11协议协商阶段
1. 16，17,20,23,24交换密钥阶段
1. 认证阶段
1. 会话




----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


