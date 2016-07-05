---
title: kubernetes:pod内IPC
date: 2016-07-03 00:00:00
categories:
- code
tags: 
- docker
- kubernetes
mathjax: true
description: 
---



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

# 由于被墙，修改ubuntu/download-release.sh和ubuntu/util.sh，注释掉curl。因为提前下载了
```

<!--more-->

修改ubuntu/config-default
```
export nodes=${nodes:-"i3@192.168.1.245 530@192.168.1.173 g640@192.168.1.241 g540@192.168.1.148"}

roles=${roles:-"ai i i i"}

export NUM_NODES=${NUM_NODES:-4}
```

清理环境，在master和node上都执行
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

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

