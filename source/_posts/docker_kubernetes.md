---
title: docker(5)-kubernetes
date: 2016-02-28 00:00:00
categories:
- code
tags: 
- docker
- kubernetes
mathjax: true
description: 
---

# 背景
需要做一个容器云，有同事在撸mesos+marathon+chronos，我就顺便折腾下kubernetes。
<!--more-->

# kubernetes简介
> Kubernetes是Google开源的容器集群管理系统。它构建Ddocker技术之上，为容器化的应用提供资源调度、部署运行、服务发现、扩容缩容等整一套功能

> Kubernetes 是来自 Google 云平台的开源容器集群管理系统。基于 Docker 构建一个容器的调度服务。该系统可以自动在一个容器集群中选择一个工作容器供使用。

感觉像是Docker版PaaS版的OpenStack。OpenStack对外提供VM，Kubernetes则对外提供基于docker的服务。


# 通过ansible装docker
机器多了，再手工装docker-engine就太麻烦了，所以写个playbook，给家里的机器统一安装。
代码放在[https://github.com/CodeJuan/kubernetes_practice](https://github.com/CodeJuan/kubernetes_practice)

## hosts
```
[master]
i3	ansible_user=i3	ansible_ssh_host=192.168.1.245


[million]
g530	ansible_user=g530	ansible_ssh_host=192.168.1.173
g540	ansible_user=g540	ansible_ssh_host=192.168.1.148
g640	ansible_user=g640	ansible_ssh_host=192.168.1.241
```
如果没有添加SSH key，那么可以设置ansible_ssh_pass=xxxxxx

这里说一个奇葩的事情，重装了系统之后，手动把maset的pubkey添加到agent的可信ssh里，然而在play的时候总提示`没有权限`，尝试了各种方法依旧无解。
最后死马当活马医，`pip uninstall ansible`再`pip install`，竟然就好了，实在是很无语。

## playbooks
```
---
- hosts: all #表示hosts里的所有agent都要装
  tasks:
  - name: ping # 先测试是否能ping通
    ping:
  - name: add_docker_key # 加入key
    sudo: yes
    command: apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  - name: update_apt_source # 增加源
    sudo: yes
    lineinfile:
      dest=/etc/apt/sources.list.d/docker.list
      create=yes
      line="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
  - name: install docker
    sudo: yes
    apt: name=docker-engine update_cache=yes
```
## 执行
```sh
ansible-playbook -i hosts playbook.yml -K
```
其中-K表示，交互式的输入sudo密码
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/docker/ansible_install_docker.png)

稍等片刻，每个agent的docker-engine就都安装好了。接下来就是安装kubernetes

# 安装kubernetes
[http://kubernetes.io/v1.1/docs/getting-started-guides/locally.html#linux](http://kubernetes.io/v1.1/docs/getting-started-guides/locally.html#linux)
参照谷歌的文档安装一下。

## 安装go

[http://blog.decbug.com/2015/11/28/golang/](http://blog.decbug.com/2015/11/28/golang/)
参考之前写的安装一下，要不要翻译成Ansible呢。。。。。。

## etcd
```sh
curl -L  https://github.com/coreos/etcd/releases/download/v2.2.4/etcd-v2.2.4-linux-amd64.tar.gz -o etcd-v2.2.4-linux-amd64.tar.gz
tar -C /usr/local/ -xzvf etcd-v2.2.4-linux-amd64.tar.gz
cd etcd-v2.2.4-linux-amd64
./etcd
```

## k8s
```sh
sudo tar -C /usr/local/ -xvzf kubernetes.tar.gz
```

[http://kubernetes.io/v1.0/docs/getting-started-guides/ubuntu.html](http://kubernetes.io/v1.0/docs/getting-started-guides/ubuntu.html)

## 部署

```
### 设置环境变量
export FLANNEL_VERSION=0.5.5 && export ETCD_VERSION=2.2.5 && export KUBE_VERSION=1.1.8
```

### build
执行`kubernetes/cluster/ubuntu/build.sh`，会自动下载二进制，然而。。。。
```
Prepare flannel 0.4.0 release ...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   608    0   608    0     0    542      0 --:--:--  0:00:01 --:--:--   543
  0     0    0     0    0     0      0      0 --:--:--  0:02:08 --:--:--     0curl: (7) Failed to connect to github-cloud.s3.amazonaws.com port 443: Connection timed out
```
----------------------------
又是S3，看来又要把路由的全局番茄打开。

### 修改配置文件
```
#  cluster/ubuntu/config-default.sh
export nodes="vcap@10.10.103.250 vcap@10.10.103.162 vcap@10.10.103.223" #user@IP
#export roles="ai i i" # 这里需要注意 role和上面的nodes一一对应，也就是说"第一个node对应第一个role，即ai，表示master+node"，后面的i就表示是node
#export NUM_MINIONS=${NUM_MINIONS:-3}
#export SERVICE_CLUSTER_IP_RANGE=192.168.1.0/16
#export FLANNEL_NET=172.16.0.0/16
```

### 开始部署
```
/usr/local/kubernetes/cluster$ KUBERNETES_PROVIDER=ubuntu ./kube-up.sh
```
由于安装过程中老出错，再次部署的时候总提示文件被占用，服务正在运行，所以我写了个kill脚本，每次部署之前都kill一次

### 部署完成
部署完成之后
```
kubectl get nodes
# 显示
NAME            LABELS                                 STATUS    AGE
192.168.1.148   kubernetes.io/hostname=192.168.1.148   Ready     6h
192.168.1.173   kubernetes.io/hostname=192.168.1.173   Ready     6h
192.168.1.241   kubernetes.io/hostname=192.168.1.241   Ready     6h
192.168.1.245   kubernetes.io/hostname=192.168.1.245   Ready     6h

```

# hello world



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

