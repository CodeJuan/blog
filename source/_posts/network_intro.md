---
title: 网络笔记--docker,neutron
date: 2017-02-10 00:00:00
categories:
- code
tags: 
- neutron
- ovs
- docker
mathjax: true
description: 
---

简单记录之前搞容器网络用的基础知识
<!--more-->

# ip命令
- ip addr
- ip route
- ip a
- ip veth peer
- ip link set xxx up

# brctl
linux bridge
- brctl add
- brctl addif
- brctl show

# ovs
open flow
- ovs-vsctl
- dump file
- ovs-ofctl

# neutron
- neutron net-CRUD
- neutron subnet-CRUD
- neutron port-CRUD
tap-qbr(linux桥)-brint(ovs桥)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


