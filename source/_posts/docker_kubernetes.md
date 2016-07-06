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


# 安装

## 下载包
由于被墙，所以先把这几个包下载下来
```
wget https://github.com/coreos/etcd/releases/download/v3.0.1/etcd-v3.0.1-linux-amd64.tar.gz
wget https://github.com/coreos/flannel/releases/download/v0.5.5/flannel-0.5.5-linux-amd64.tar.gz
wget https://github.com/kubernetes/kubernetes/releases/download/v1.3.0/kubernetes.tar.gz
wget https://storage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz

cp etcd-v3.0.1-linux-amd64.tar.gz ~/code/kubernetes/cluster/ubuntu/etcd.tar.gz
cp flannel-0.5.5-linux-amd64.tar.gz ~/code/kubernetes/cluster/ubuntu/flannel.tar.gz
cp kubernetes.tar.gz ~/code/kubernetes/cluster/ubuntu/kubernetes.tar.gz
cp easy-rsa.tar.gz ~/code/kubernetes/cluster/ubuntu/easy-rsa.tar.gz

export KUBE_VERSION=1.3.0 && export FLANNEL_VERSION=0.5.5 && export ETCD_VERSION=3.0.1


```



## 修改ubuntu/config-default
```
# 由于被墙，修改ubuntu/download-release.sh和ubuntu/util.sh，注释掉curl。因为提前下载了

# 用户名@ip
export nodes=${nodes:-"i3@192.168.1.245 530@192.168.1.173 g640@192.168.1.241 g540@192.168.1.148"}

# a表示master，i表示node，ai表示master+node
roles=${roles:-"ai i i i"}

# 4个node
export NUM_NODES=${NUM_NODES:-4}
```

## 清理环境
由于我之前安装过，所以还是清理一下，在master和node上都执行
```
sudo rm -rf /opt/bin/etcd* /opt/bin/flanneld*
sudo rm -rf /opt/bin/kube*
sudo service etcd stop
sudo service flanneld stop
sudo service kube-apiserver stop
sudo service --status-all
sudo service kube-apiserver status
sudo service kube-controller-manager stop
sudo service kube-proxy stop
sudo service kube-scheduler stop
sudo service kubelet stop
```

## 开始部署
在master上的kubernetes/cluster/路径执行

```
KUBERNETES_PROVIDER=ubuntu ./kube-up.sh
```

输入密码，最后完成
```
./kubectl get nodes
返回结果
#NAME            STATUS    AGE
#192.168.1.148   Ready     123d
#192.168.1.173   Ready     123d
#192.168.1.241   Ready     123d
#192.168.1.245   Ready     123d
```

## 安装DNS和UI
```
cd cluster/ubuntu
$ KUBERNETES_PROVIDER=ubuntu ./deployAddons.sh
```

## 然后查看ui
打开master上的ui，[http://<masterip>:8080/ui](http://<masterip>:8080/ui)

![](https://github.com/CodeJuan/blog/raw/master/source/image/k8s/kube_ui.png)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

