---
title: LXC,docker
date: 2017-02-11 00:00:00
categories:
- code
tags: 
- docker
- LXC
mathjax: true
description: 
---

docker偏向于应用，LXC偏向于资源，其产品形态更像是一台虚拟机
<!--more-->

# LXC vs. VM
对比|LXC|VM
---|---|---
hyper层|用namespace,cgroup,无|有，KVM/XEN
内核|共用host|有guest
启动|秒|分

可以说，docker的优点，LXC都有，然而其形态却更像虚拟机

# LXC vs. docker

对比|LXC|docker
---|---|---
init进程|有systemd作为init进程|entrypoint或cmd里的进程，其实就是业务进程，如果业务进程挂了，容器也跟着消失
行为|可以shutdown，reboot等等|业务进程的生命周期
网络|也是veth peer接到网络命名空间|同
存储|多种，默认dir后端则是直接用host上的文件夹,/var/lib/lxd/containers/xxxx/rootfs|aufs,devicemapper
生态|与openstack比较紧密，nova-lxd,nova-libvirtdriver-libvirtlxc|k8s,


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


