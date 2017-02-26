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

## 安装ZFS

Feature                                     | Directory | Btrfs | LVM   | ZFS
:---                                        | :---      | :---  | :---  | :---
Optimized image storage                     | no        | yes   | yes   | yes
Optimized container creation                | no        | yes   | yes   | yes
Optimized snapshot creation                 | no        | yes   | yes   | yes
Optimized image transfer                    | no        | yes   | no    | yes
Optimized container transfer                | no        | yes   | no    | yes
Copy on write                               | no        | yes   | yes   | yes
Block based                                 | no        | no    | yes   | no
Instant cloning                             | no        | yes   | yes   | yes
Nesting support                             | yes       | yes   | no    | no
Restore from older snapshots (not latest)   | yes       | yes   | yes   | no
Storage quotas                              | no        | yes   | no    | yes

lxc支持的存储后端，看来ZFS不错，打算用他

```
sudo apt-add-repository ppa:zfs-native/stable
sudo apt update
sudo apt install ubuntu-zfs
```

## init lxd
```
sudo lxd init
```
需要注意：如果是想在嵌套容器里跑openstack，那么网络只选择IPV4和存储后端用DIR

完成后
```
$brctl show
lxdbr0		8000.000000000000	no
```

多了一个linux桥

## 启动容器
```
sudo lxc launch ubuntu:16.04 first

# 进入到容器
sudo lxc exec first -- bash

root@first:~# curl aliyun.com
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<h1>301 Moved Permanently</h1>
<p>The requested resource has been assigned a new permanent URI.</p>
<hr/>Powered by Tengine/Aserver</body>
</html>

```

## resource control

[https://stgraber.org/2016/03/26/lxd-2-0-resource-control-412/](https://stgraber.org/2016/03/26/lxd-2-0-resource-control-412/)

### cpu
```
i3@i3:~$ sudo lxc config set first limits.cpu 1
i3@i3:~$ sudo lxc exec first -- bash
root@first:~# cat /proc/cpuinfo
processor	: 0

只能看到一个核

```

### 内存
```
root@first:~# cat /proc/meminfo
MemTotal:       16095260 kB

i3@i3:~$ sudo lxc config set first limits.memory 512MB
i3@i3:~$ sudo lxc exec first -- bash
root@first:~# cat /proc/meminfo
MemTotal:         524288 kB

```

# openstack

## 容器已经成功创建，开始尝试openstack
```
sudo lxc init ubuntu:16.04 openstack -c security.privileged=true -c security.nesting=true -c "linux.kernel_modules=iptable_nat, ip6table_nat, ebtables, openvswitch, nbd"
printf "lxc.cap.drop=\nlxc.aa_profile=unconfined\n" | sudo lxc config set openstack raw.lxc -
sudo lxc config device add openstack mem unix-char path=/dev/mem
sudo lxc start openstack
```

## 可以看到openstack容器已经运行
```
i3@i3:~$ sudo lxc list
+-----------+---------+----------------------+------+------------+-----------+
|   NAME    |  STATE  |         IPV4         | IPV6 |    TYPE    | SNAPSHOTS |
+-----------+---------+----------------------+------+------------+-----------+
| openstack | RUNNING | 10.84.103.125 (eth0) |      | PERSISTENT | 0         |
+-----------+---------+----------------------+------+------------+-----------+

```

## 安装juju
```
sudo lxc exec openstack -- apt update
sudo lxc exec openstack -- apt dist-upgrade -y
sudo lxc exec openstack -- apt install squashfuse -y
sudo lxc exec openstack -- ln -s /bin/true /usr/local/bin/udevadm
sudo lxc exec openstack -- snap install conjure-up --classic
```

初始化容器里的lxd
```
sudo lxc exec openstack -- lxd init
```

# 参考
[https://stgraber.org/2016/10/26/lxd-2-0-lxd-and-openstack-1112/](https://stgraber.org/2016/10/26/lxd-2-0-lxd-and-openstack-1112/)
[https://stgraber.org/2016/03/15/lxd-2-0-installing-and-configuring-lxd-212/](https://stgraber.org/2016/03/15/lxd-2-0-installing-and-configuring-lxd-212/)



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


