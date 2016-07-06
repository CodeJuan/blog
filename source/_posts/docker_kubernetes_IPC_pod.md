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


要动态更新容器里某些进程的配置，例如nginx。所以需要实时获取配置更新，并同步到容器里的配置文件里，采用的方法是用confd从etcd采集数据，然后更新配置文件的方法。
现有的方案是把confd+nginx放在同一个容器里，虽然能解决问题，但是不够优雅，毕竟一个容器只跑一个进程好。
恰好业务是跑在k8s上，k8s关于pod的文档上说
> Containers within a pod share an IP address and port space, and can find each other via localhost. They can also communicate with each other using standard inter-process communications like SystemV semaphores or POSIX shared memory. Containers in different pods have distinct IP addresses and can not communicate by IPC

如果同一个pod里的进程，可以互相看到对方，那么就可以不用修改，直接把现有一个容器拆成两个容器了。

<!--more-->

提前剧透一下结论，是看不到的。因为

> The context of the pod can be defined as the conjunction of several Linux namespaces:
- PID namespace (applications within the pod can see each other's processes)
- network namespace (applications within the pod have access to the same IP and port space)
- IPC namespace (applications within the pod can use SystemV IPC or POSIX message queues to communicate)
- UTS namespace (applications within the pod share a hostname)

> In terms of Docker constructs, a pod consists of a colocated group of Docker containers with shared volumes. PID namespace sharing is not yet implemented with Docker.

# 创建pod
创建两个容器的pod
```
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

# 进入其中一个ps和netstat
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

# 进入另一个容器
进入nginx容器看看进程
```
docker exec -it k8s_nginx.fb0f31c6_ipc2_default_82fd2fb7-42c0-11e6-a4f1-d43d7e2c2527_c689aa68 bash
root@ipc2:/# ps axu

# 只能看到nginx的进程
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  31684  5100 ?        Ss   14:57   0:00 nginx: master process nginx -g daemon off;
nginx        5  0.0  0.0  32068  2904 ?        S    14:57   0:00 nginx: worker process
root         6  0.0  0.0  20224  3272 ?        Ss   15:00   0:00 bash
root        19  0.0  0.0  17500  2096 ?        R+   15:09   0:00 ps axu
```

# 结论
网络、UTC、IPC都共享，但是PID不能共享。

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

