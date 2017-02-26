---
title:  Run a full OpenStack in a LXD container
date: 2017-02-26 00:00:00
categories:
- code
tags: 
- APM
mathjax: true
description: 
---

鉴于lxc容器特别像虚拟机的特点，rackspace，都有把openstack部署到lxc容器里的实践，恰好lxc也有类似教程，打算自己跑一遍，看看是怎样一种体验

how to run a full OpenStack, using LXD containers instead of VMs and running all of this inside a LXD container (nesting!).

<!--more-->

# 安装lxd
还是ubuntu好，直接apt就行了，不像在centos上，需要从头开始编译liblxc,lxd[试验记录](https://github.com/CodeJuan/lxc_lxd)。更可怕的是，AppArmor/SeLinux/Seccomp/user namespace/都需要另外安装，如果不安装，就需要在编译liblxc时disable掉

```sh
sudo apt-get update
sudo apt -t trusty-backports install lxd
```

安装完成后，查看版本
```
i3@i3:~$ lxc --version
2.0.8
i3@i3:~$ lxd --version
2.0.8
```

# 参考
[https://stgraber.org/2016/10/26/lxd-2-0-lxd-and-openstack-1112/](https://stgraber.org/2016/10/26/lxd-2-0-lxd-and-openstack-1112/)
[https://stgraber.org/2016/03/15/lxd-2-0-installing-and-configuring-lxd-212/](https://stgraber.org/2016/03/15/lxd-2-0-installing-and-configuring-lxd-212/)



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


