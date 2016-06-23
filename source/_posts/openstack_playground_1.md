---
title: 玩openstack:1
date: 2016-06-21 19:00:00
categories:
- code
tags: 
- openstack
- devstack
mathjax: true
description: 
---

# 背景

要基于公司已有的openstack结合docker搞一个好玩的东西，所以又开始撸openstack了，这就需要对虚拟化有个更深入的理解。
昨天搞整了一下KVM和vlan，[http://blog.decbug.com/2016/06/20/kvm/](http://blog.decbug.com/2016/06/20/kvm/)
今天就要在家搞一套openstack开发环境
<!--more-->

# devstack
devstack是一个一键式搭建open stack环境的脚本，如官网所说`DevStack is a series of extensible scripts used to quickly bring up a complete OpenStack environment.`
```
git clone https://github.com/openstack-dev/devstack.git
cd devstack/

# 切换到m版本分支
git co stable/mitaka

cd tools

# 创建stack用户
sudo bash create-stack-user.sh

# cd ../../
sudo mv devstack /opt/stack
sudo chown -R stack:stack /opt/stack/devstack

# switch to stack
sudo -i
su stack

```

参照[官网](http://docs.openstack.org/developer/devstack/guides/neutron.html#id3)在`/opt/stack/devstack`创建local.conf，内容是
记得改host_ip,service_host,PUBLIC_INTERFACE
## controller
```
[[local|localrc]]
HOST_IP=192.168.1.245
SERVICE_HOST=192.168.1.245
MYSQL_HOST=192.168.1.245
RABBIT_HOST=192.168.1.245
GLANCE_HOSTPORT=192.168.1.245:9292
PUBLIC_INTERFACE=p1p1

ADMIN_PASSWORD=secret
MYSQL_PASSWORD=secret
RABBIT_PASSWORD=secret
SERVICE_PASSWORD=secret

## Neutron options
Q_USE_SECGROUP=True
ENABLE_PROJECT_VLANS=True
PROJECT_VLAN_RANGE=3001:4000
PHYSICAL_NETWORK=default
OVS_PHYSICAL_BRIDGE=br-ex

Q_USE_PROVIDER_NETWORKING=True

# Do not use Nova-Network
disable_service n-net

# Neutron
ENABLED_SERVICES+=,q-svc,q-dhcp,q-meta,q-agt

## Neutron Networking options used to create Neutron Subnets

FIXED_RANGE="203.0.113.0/24"
NETWORK_GATEWAY=203.0.113.1
PROVIDER_SUBNET_NAME="provider_net"
PROVIDER_NETWORK_TYPE="vlan"
SEGMENTATION_ID=2010


# use TryStack git mirror
GIT_BASE=http://git.trystack.cn
NOVNC_REPO=http://git.trystack.cn/kanaka/noVNC.git
SPICE_REPO=http://git.trystack.cn/git/spice/spice-html5.git
```

## compute node
```
[[local|localrc]]
HOST_IP=192.168.1.148
SERVICE_HOST=192.168.1.245
MYSQL_HOST=192.168.1.245
RABBIT_HOST=192.168.1.245
GLANCE_HOSTPORT=192.168.1.245:9292
ADMIN_PASSWORD=secret
MYSQL_PASSWORD=secret
RABBIT_PASSWORD=secret
SERVICE_PASSWORD=secret

# Services that a compute node runs
ENABLED_SERVICES=n-cpu,rabbit,q-agt

## Open vSwitch provider networking options
PHYSICAL_NETWORK=default
OVS_PHYSICAL_BRIDGE=br-ex
PUBLIC_INTERFACE=p2p1
Q_USE_PROVIDER_NETWORKING=True

# use TryStack git mirror
GIT_BASE=http://git.trystack.cn
NOVNC_REPO=http://git.trystack.cn/kanaka/noVNC.git
SPICE_REPO=http://git.trystack.cn/git/spice/spice-html5.git
```


然后运行
```
bash /stack.sh
```

参考[http://blog.csdn.net/u011521019/article/details/51114681](http://blog.csdn.net/u011521019/article/details/51114681)
改成我的实际IP
提示
```
2016-06-21 14:07:28.255 | ovs-ofctl: br-int is not a bridge or a socket
2016-06-21 14:07:28.262 | ovs-ofctl: br-tun is not a bridge or a socket
2016-06-21 14:07:28.269 | ovs-ofctl: br-ex is not a bridge or a socket
2016-06-21 14:07:28.277 | ovs-ofctl: br-int is not a bridge or a socket
2016-06-21 14:07:28.284 | ovs-ofctl: br-tun is not a bridge or a socket
2016-06-21 14:07:28.292 | ovs-ofctl: br-ex is not a bridge or a socket
2016-06-21 14:07:28.446 | +^[[3242mstack.sh:exit_trap:498                   ^[(B^[[m exit 1

```
说要unstack.sh，然后reboot，再stack.sh，然而还是一样的错


```
# minimal config
# devstack generate-subunit fail
sudo apt-get install python-pip
sudo pip install --upgrade pip
```
----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

