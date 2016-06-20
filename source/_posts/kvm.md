---
title: 学习KVM
date: 2016-06-20 00:00:00
categories:
- code
tags: 
- cache
- storage
mathjax: true
description: 
---

# 背景

要基于公司已有的openstack结合docker搞一个好玩的东西，所以又开始撸openstack了，这就需要对虚拟化有个更深入的理解。
那么从KVM开始，是一个不错的选择。

<!--more-->

# KVM基础概念
- 虚拟化的三种类型，1型，2型，进程虚拟化
- KVM是2型，是运行在操作系统之上的
- docker就是进程虚拟化，直接用host的内核

# 安装KVM
```
sudo apt-get install qemu-kvm qemu-system libvirt-bin virt-manager bridge-utils vlan

# 查看是否支持虚拟化，要返回vmx
egrep -o '(vmx|svm)' /proc/cpuinfo

# 查看是否安装成功
sudo service libvirt-bin status
```

# 启动虚拟机

下载镜像[cirros-0.3.4-x86_64-disk.img](http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img)，拷贝到`cp cirros-0.3.4-x86_64-disk.img /var/lib/libvirt/images/`

```
sudo virt-manager

# 图形界面，创建虚拟机

```


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

