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

cp etcd-v3.0.1-linux-amd64.tar.gz ~/code/kubernetes/cluster/etcd.tar.gz
cp flannel-0.5.5-linux-amd64.tar.gz ~/code/kubernetes/cluster/flannel.tar.gz
cp kubernetes.tar.gz ~/code/kubernetes/cluster/kubernetes.tar.gz
cp easy-rsa.tar.gz ~/code/kubernetes/cluster/easy-rsa.tar.gz
```



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

