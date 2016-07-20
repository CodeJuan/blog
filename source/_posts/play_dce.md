---
title: 比较WinPE文件(忽略时间戳)
date: 2014-11-19 00:00:00
categories:
- code
tags: 
- WinPE
mathjax: true
description: 
---
## 背景
DaoCloud是国内领先的容器云，我的山寨容器云需要多向他学习。

<!--more-->

## 创建机器
在DigitalOcean创建两台最低配.

## 开始安装

一条命令搞定
```
bash -c "$(docker run -i --rm daocloud.io/daocloud/dce install)"
```

竟然内存太小，好吧，要resize到1G了
```
Verifying System compatibility...
Requirement              Value                          Note
-----------------------  -----------------------------  -------------------------------------------------------
CPU                      1                              Recommended more than 4 CPU Core.
Memory                   489.9921875 MiB                WARN: Should be installed where more than 1G memory.
Storage For Docker       16.7933425903 GiB              Recommended more than 30GB.
Network to Controller    OK                             OK
Network from Controller  OK                             OK
Operating System         Ubuntu 14.04.4 LTS             WARN: Recommended Ubuntu 16.04.
Linux Kernel             3.13.0-85-generic              Recommended the latest maintained version Linux kernel.
Docker Version           1.11.2                         OK
Docker Storage Driver    aufs                           OK
Docker Feature           All Supported                  OK
Docker ID                MIM2:DL6F:WVJN:UDDF:...        OK
Firewalld                UnKnown                        Make sure the firewalld has been closed.
Host Name                docker-512mb-sfo2-01           OK
Port                     80,443,2375,12376,12380,12379  OK
Time                     0ms                            OK
SELinux                  permissive                     SELinux has been disabled.

```




-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
