---
title: Neutron与容器网络
date: 2017-01-15 01:00:00
categories:
- code
tags:
- docker
- network
- neutron
- openstack
mathjax: true
description: 
---

容器用Neutron组网，比Flannel和VPC router强的地方在于
- 多租户，不同租户的容器可以运行在同一个宿主机上。
  1. Flannel没有租户隔离，
  2. 阿里云则是先用租户开虚拟机，利用I层的隔离，同一个虚拟机只能跑一个租户的容器
- 性能，如果是部署在openstack发放的虚拟机上，则不用在overlay一层


<!--more-->

# 大概原理
记录一下
1. neutron create port
1. docker network create bridge xxxx， docker run -net=xxxx
1. 管理xxxx的CIDR
1. bridge veth pair   <---> (port IP MAC) veth pair port的qbr上
1. dvr add : xxxx的CIDR nexthop 是一个neutron port

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


