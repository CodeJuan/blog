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

docker偏向于应用，LXC偏向于资源，其产品形态更像是一台虚拟机，所以其有个名字叫系统容器/机器容器。
然而，在当前docker大势已成，虚拟机经久不衰的形势下，lxc的优势和劣势都有哪些？

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

# 总结
- 轻应用，新应用都是微服务化，做docker化改造不算难
- 传统重应用，已然在虚机/物理机上跑得好好的，如果没有足够的收益，不足以说服去迁移到lxc
- 现实的问题，由于docker太火，很多应用都已经docker化了
- lxc主要的场景，就在于虚拟机和docker的夹缝之中
  1. 需要用到物理机设备的重型应用，比如GPU？虚拟机的虚拟化层需要做适配，docker则对此类重型应用水土不服。
  1. 经过测试LXC的IO，网络性能与物理机基本一致，性能比虚拟机要好。
  1. 比docker更像虚拟机，比虚拟机更轻量性能更好？


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


