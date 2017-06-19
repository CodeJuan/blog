---
title: 用openstack管容器
date: 2017-05-27 01:00:00
categories:
- code
tags:
- container
- docker
- LXC
- openstack
mathjax: true
description: 
---

# 与nova的结合
做了个具有lxc特性的docker的结合，称之为系统容器，对外接口则是完全用docker daemon，更因为系统容器的对外呈现形式与虚拟机极为相似，所以选用nova-docker来管理容器生命周期。

参考之前写的[nova-lxd分析](http://blog.decbug.com/nova-lxd-lxc/)，就不多涉及nova-docker的源码分析，大同小异。

主要记录下ceilometer与docker

<!--more-->

# ceilometer的架构
ceilometer架构
![](https://cloud.githubusercontent.com/assets/5423628/26526506/4bd6cf18-43b0-11e7-8139-692ae54db511.png)

## 控制节点
- agent-central, 采集openstack其他组件的信息
- alarm，报警
- notification，通知
- collector，从MQ上取指标，然后持久化

## 计算节点
- agent-compute，采集实例的指标，比如kvm虚拟机，xen虚拟机，lxc容器
- agent-hardware，采集物理机指标

## inspector
- 对于不同的虚拟化形态，需要用不同的inspector
- 流程： compute->pollster->get_samples->inspector->inspect_memory,inspect_cpu,inspect_nics,inspect_disk

### kvm
- virsh dumpxml
- virsh domvifstat
- virsh dommemstat

### xen
有自己的API

# 自己写的ceilometer-lxd
之前做用docker之前，弄的是lxd，也写了一个ceilometer-lxd

用于监控容器
- entry_points, lxd=xx.xx.
- 修改ceilometer-agent-compute.conf，inspector改为lxd
- 看pollster里的get_samples，会调用inspector里的get_cpu, get_memory等等
- 通过lxd daemon的restful api获取信息。config api可以得到cpu.limit，state api可以得到usage


以inspect_cpu为例
- cgroup/cpuset/cpuset/usage
- lxd restful api: container/<name>/state，获取当前CPU时间
- container/<name>, config里有limit.cpu

# 自己写的ceilometer-docker
## cpu
通过docker daemon的[stat API](https://docs.docker.com/engine/api/v1.28/#operation/ContainerStats)获取cpu_stats和precpu_stats，然后参考docker client源码中计算cpu百分比

## 内存
内存限额
```
/sys/fs/cgroup/memory/docker/<contaier ID>/memory.limit_in_bytes
```

内存用量
```
/sys/fs/cgroup/memory/docker/<contaier ID>/memory.usage_in_bytes
```

## 网卡
1. inspect获取到容器的Pid
2. /proc/<pid>/net/dev
```
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo: 6515790   19839    0    0    0     0          0         0  6515790   19839    0    0    0     0       0          0
 wlan1: 535376943  386866    0 39847    0     0          0         0 30927899  288216    0 1996    0     0       0          0
virbr0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
docker0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
  eth0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
```
3. 解析出每个网卡收发字节数，包数

## 磁盘
1. inspect得到pid
2. /sys/fs/cgroup/blkio/docker/<pid>/blkio.io_service_bytes_recursive，得到IO字节数
3. /sys/fs/cgroup/blkio/user/blkio.io_serviced_recursive，得到IO次数

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


