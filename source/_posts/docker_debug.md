---
title: docker daemon调试套路
date: 2017-05-23 00:00:00
categories:
- code
tags: 
- debug
- docker
mathjax: true
description: 
---

容器突然退出？shim进程却还在？runc也在？daemon有句柄没释放？mount还在？这个该如何定位？
简单记录下常用方法
<!--more-->

# daemon的调用过程
```
docker daemon -> containerd -> shim -> runc
```

# 套路
## 看docker daemon log

- centos系是systemd启动的，location is ``/var/log/message`
- ubuntu是upstart， 在 `/var/log/upstart/docker`

如果需要更详细的log，在启动daemon的时候加上-D，即调试模式

## containerd event

- /var/run/docker/libcontainerd/containerd/event

## 看shim进程

- ps，注意container ID

## 看句柄

- 打开的句柄，lsof -p $(cat /var/run/docker.pid)
- 泄漏, ls /proc/<pid>/fd -l

## 看runc
- docker-ruc list

## 看stack
cat /proc/<pid>/stack

## 看容器的mount点
- mount
- /proc/pid/mount

## pprof
- daemon提供了pprof接口

## 实在不行，就只能fmt.print调试了
还可以strace


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


