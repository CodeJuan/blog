---
title: 在家玩DaoCloud企业版--部署/网络/存储
date: 2016-07-25 01:00:00
categories:
- code
tags: 
- docker
- swarm
- DaoCloud
mathjax: true
description: 
---
# 背景
前面分析了系统容器，
[http://blog.decbug.com/2016/07/25/play_dce2/](http://blog.decbug.com/2016/07/25/play_dce2/)
接下来看看到底是如何部署的，以及网络存储是如何创建的。
<!--more-->

# 安装
去掉--rm ，看看install到底做了什么
```
docker run -i  daocloud.io/daocloud/dce install
```
不加--rm竟然无法运行，DaoCloud还挺厉害，暂且不管，先弄清楚网络再来搞定他

# 网络

## 准备证书
docker -H :2375 network ls 查看network

但是提示 没有证书

```
docker cp c165f85044a9:/etc/ssl/private/engine/engine-cert.pem /etc/ssl/private/engine/engine-cert.pem
docker cp c165f85044a9:/etc/ssl/private/engine/engine-key.pem /etc/ssl/private/engine/engine-key.pem
docker cp c165f85044a9:/etc/ssl/private/engine/ca.pem /etc/ssl/private/engine/ca.pem
```
把证书从manager容器里拷贝出来

## 然后network ls
```
docker -H :2375 --tls --tlscacert /etc/ssl/private/engine/ca.pem --tlscert /etc/ssl/private/engine/engine-cert.pem --tlskey /etc/ssl/private/engine/engine-key.pem network ls
```
结果是
```
NETWORK ID          NAME                                   DRIVER
bd796525b91c        docker-512mb-sfo2-01/bridge            bridge
26e3c48a34b9        docker-512mb-sfo2-01/dce_default       bridge
b6928df6352f        docker-512mb-sfo2-01/host              host
242e13239dcb        docker-512mb-sfo2-01/none              null
0ea714042165        docker-512mb-sfo2-02/bridge            bridge
ea7e447dbb71        docker-512mb-sfo2-02/dce_default       bridge
e61de07d7d1f        docker-512mb-sfo2-02/docker_gwbridge   bridge
38af5aff9349        docker-512mb-sfo2-02/host              host
c448a5c9ee19        docker-512mb-sfo2-02/none              null
48ac6678f478        tty_default                            overlay
bd2f14e19718        ubuntusshttyjs_default                 overlay
```
可以看到，自建容器都是用到了overlay，目测用的就是docker原生的overlay

![image](https://cloud.githubusercontent.com/assets/5423628/17141722/d736523a-537f-11e6-8516-1ae20ba49f26.png)

从上图可以看到，果然是原生overlay

# 存储
![存储](https://cloud.githubusercontent.com/assets/5423628/17107783/4bda1fee-52c3-11e6-9485-d77436874107.png)
貌似只能挂本地卷




-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
