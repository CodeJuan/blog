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

安装DNS和UI
```
cd cluster/ubuntu
$ KUBERNETES_PROVIDER=ubuntu ./deployAddons.sh
```

创建两个容器的pod
```yml
apiVersion: v1
kind: Pod
metadata:
  name: ipc2
  labels:
    app: web
spec:
  containers:
    - name: registry
      image: registry
      ports:
        - containerPort: 5000
    - name: nginx
      image: nginx:1.9
      ports:
        - containerPort: 80
```

查看
```
./kubectl exec -it ipc2 bash

# 看进程
ps aux
# 结果，只能看到registry的进程
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.4  53228 15992 ?        Ss   14:56   0:00 /usr/bin/python
root        13  1.0  1.0 110492 39600 ?        S    14:56   0:03 /usr/bin/python
root        14  1.0  0.9 110256 38804 ?        S    14:56   0:03 /usr/bin/python
root        17  0.9  0.9 110272 38820 ?        S    14:56   0:03 /usr/bin/python
root        18  1.0  0.9 110276 38816 ?        S    14:56   0:03 /usr/bin/python
root        44  0.0  0.0  18148  3364 ?        Ss+  15:00   0:00 bash
root        60  2.0  0.0  18152  3192 ?        Ss   15:01   0:00 bash
root        74  0.0  0.0  15572  2164 ?        R+   15:01   0:00 ps aux

# 看端口
root@ipc2:/# netstat -anplt
# 结果，网络共享了
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:5000            0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -
```

```
# 进入nginx容器看看进程
docker exec -it k8s_nginx.fb0f31c6_ipc2_default_82fd2fb7-42c0-11e6-a4f1-d43d7e2c2527_c689aa68 bash
root@ipc2:/# ps axu

# 只能看到nginx的进程
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  31684  5100 ?        Ss   14:57   0:00 nginx: master process nginx -g daemon off;
nginx        5  0.0  0.0  32068  2904 ?        S    14:57   0:00 nginx: worker process
root         6  0.0  0.0  20224  3272 ?        Ss   15:00   0:00 bash
root        19  0.0  0.0  17500  2096 ?        R+   15:09   0:00 ps axu
```

同一POD内网络是通的，但是进程不通？
可是文档说
> Containers within a pod share an IP address and port space, and can find each other via localhost. They can also communicate with each other using standard inter-process communications like SystemV semaphores or POSIX shared memory. Containers in different pods have distinct IP addresses and can not communicate by IPC

奇怪

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

