---
title: kubernetes尝试有状态服务
date: 2016-08-03 00:00:00
categories:
- code
tags: 
- docker
- kubernetes
- stateful
mathjax: true
description: 
---

# 有状态服务的概念
既然名叫有状态，那么就与之相对，会有我们很熟悉的无状态。无状态的概念，就是只负责运算，不负责任何数据的存储，这样就能很轻松地做到水平扩展。
> 之前写的关于无状态的例子


那么，有状态的概念又是什么呢，简单来说，就是会有数据的存储，需要持久化。

<!--more-->
# k8s的petset
简单来说，pod是用来跑无状态服务，petset就是跑有状态服务。
1.3之前k8s大多是用于无状态的web应用，但是我们实际业务却有很多有状态的服务，对于谷歌来说，绝对不会放弃这一块的机会，所以petset就应运而生。

那么，作为有状态服务的基石，petset需要具备哪些特征呢：
1. 有唯一的编号
1. 在网络上有个不会改变的标识，k8s是通过DNS实现的。pod，则是名字后面还有随机数，所以需要有service来做转发
1. 每个有状态服务，都需要有自己的卷，这样就能保证数据可靠存储

# petset的典型场景
MySQL
Zookeeper
Cassandra

# 小试验
```
# A headless service to create DNS records
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  # *.nginx.default.svc.cluster.local
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1alpha1
kind: PetSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
      annotations:
        pod.alpha.kubernetes.io/initialized: "true"
    spec:
      terminationGracePeriodSeconds: 0
      containers:
      - name: nginx
        image: gcr.io/google_containers/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
      annotations:
        volume.alpha.kubernetes.io/storage-class: anything
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```
提示
```
$ ./kubectl describe pvc www-web-0
Name:		www-web-0
Namespace:	default
Status:		Pending
Volume:
Labels:		app=nginx
Capacity:
Access Modes:
Events:
  FirstSeen	LastSeen	Count	From				SubobjectPath	Type		Reason			Message
  ---------	--------	-----	----				-------------	--------	------			-------
  5m		10s		22	{persistentvolume-controller }			Warning		ProvisioningFailed	No provisioner plugin found for the claim!

```

看了下[http://kubernetes.io/docs/user-guide/persistent-volumes/#provisioning](http://kubernetes.io/docs/user-guide/persistent-volumes/#provisioning)
原来是只有all in one才能用hostpath，所以，得搭建一个NFS，毕竟NFS最简单


```
# A headless service to create DNS records
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  # *.nginx.default.svc.cluster.local
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1alpha1
kind: PetSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
      annotations:
        pod.alpha.kubernetes.io/initialized: "true"
    spec:
      terminationGracePeriodSeconds: 0
      containers:
      - name: nginx
        image: gcr.io/google_containers/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
      annotations:
        volume.alpha.kubernetes.io/storage-class: anything
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi

```

# 参考
- [构建可伸缩的有状态服务](http://www.infoq.com/cn/news/2015/12/scaling-stateful-services)
- [无状态服务 vs 有状态服务](http://docs.alauda.cn/feature/service/stateless-service-and-stateful-service.html)
- [Pet Sets](http://kubernetes.io/docs/user-guide/petset/)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/



