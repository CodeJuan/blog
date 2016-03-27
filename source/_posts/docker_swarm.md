---
title: docker(6)-swarm
date: 2016-03-27 00:00:00
categories:
- code
tags: 
- docker
- docker-swarm
mathjax: true
description: 
---

# 背景
正在撸自己的容器云，目前的业务不是复杂，所以做法比较土：自己管理集群，调用每个节点的docker daemon remote API来创建/启动/停止/删除镜像及容器，虽然简单，但是需要自己做集群管理（都还没上服务发现），比较麻烦。
此后打算用k8s，但由于其他原因，暂时搁置。后来咨询swarm的maintainer线超博，以及DaoCloud的高手们，决定采用swarm
<!--more-->

# 采用swarm的原因
1. 自带服务发现，不用我自己弄
2. 和docker daemon remote API的基本相同，仅有的差异请参照[官方文档](https://github.com/CodeJuan/swarm/blob/master/docs/swarm-api.md#endpoints-which-behave-differently)，基本可以复用原来的代码

虽然这次用了swarm，但有机会的话我还是想会继续安利k8s，毕竟k8s更好玩一些

# 安装
## 节点分配
主机名|IP|角色
----|------
i3|192.168.1.245|sonsul,manage0,node
g540|192.168.1.148|manage1,node
g640|192.168.1.241|node
g530|192.168.1.173|node

这里的主机名，都是我的机器的CPU型号，这几台机器都是我收购来的二手台式机，IP是openwrt自动分配的，貌似是hash算出来的，是个固定值。


## 暴露docker daemon的端口
swarm应该也是调用每个节点的remote API吧，所以需要暴露端口

打开`/etc/default/docker`，在`DOCKER_OPTS`加上
```
-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock
```

记住这个暴露的端口号，后面会用到，我这里是4243

## 启动consul
在i3上执行
```
docker run --restart always -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
```
启动consul，端口是8500

## 启动manager0
还是i3
```
docker run --restart always -d -p 4000:4000 swarm manage -H :4000 --replication --advertise 192.168.1.245:4000 consul://192.168.1.245:8500
```
advertise的IP就是i3自身的IP，相当于告诉consul，我是manage，这是我的IP和端口
consul就是之前在i3上创建的consul的IP和端口

## 启动manager1
官网把这个叫`secondary Swarm manager`，领会精神即可
这次是在g540上执行
```
docker run --restart always -d swarm manage -H :4000 --replication --advertise 192.168.1.148:4000 consul://192.168.1.245:8500
```
consul，还是i3上运行的consul
advertise 是manager1，也就是自己的IP和端口

## 启动node
在4个节点上分别运行
```
docker run --restart always -d swarm join --advertise=自己的IP:4243 consul://192.168.1.245:8500
```
这里的4243就是之前暴露的docker daemon的端口了

## 在i3上查看info
```
docker -H :4000 info
```
这里表示，docker会向本机的4000端口发请求，也就是我们最开始启动manager0的时候声明的端口。
可以看到
```
Containers: 19
 Running: 19
 Paused: 0
 Stopped: 0
Images: 26
Server Version: swarm/1.1.3
Role: primary
Strategy: spread
Filters: health, port, dependency, affinity, constraint
Nodes: 4
 g530: 192.168.1.173:4243
  └ Status: Healthy
  └ Containers: 8
  └ Reserved CPUs: 0 / 2
  └ Reserved Memory: 0 B / 3.969 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.19.0-25-generic, operatingsystem=Ubuntu 14.04.3 LTS, storagedriver=aufs
  └ Error: (none)
  └ UpdatedAt: 2016-03-27T09:46:45Z
 g540: 192.168.1.148:4243
  └ Status: Healthy
  └ Containers: 4
  └ Reserved CPUs: 0 / 2
  └ Reserved Memory: 0 B / 3.93 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.19.0-25-generic, operatingsystem=Ubuntu 14.04.4 LTS, storagedriver=aufs
  └ Error: (none)
  └ UpdatedAt: 2016-03-27T09:47:02Z
 g640: 192.168.1.241:4243
  └ Status: Healthy
  └ Containers: 4
  └ Reserved CPUs: 0 / 2
  └ Reserved Memory: 0 B / 3.739 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.19.0-25-generic, operatingsystem=Ubuntu 14.04.4 LTS, storagedriver=aufs
  └ Error: (none)
  └ UpdatedAt: 2016-03-27T09:46:56Z
 i3: 192.168.1.245:4243
  └ Status: Healthy
  └ Containers: 3
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 16.12 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.19.0-25-generic, operatingsystem=Ubuntu 14.04.3 LTS, storagedriver=aufs
  └ Error: (none)
  └ UpdatedAt: 2016-03-27T09:47:17Z
Plugins:
 Volume:
 Network:
Kernel Version: 3.19.0-25-generic
Operating System: linux
Architecture: amd64
CPUs: 10
Total Memory: 27.76 GiB
```
很帅吧

# 测试

## 获取当前正在运行的容器
```
curl -X GET http://192.168.1.245:4000/containers/json
```
返回
```
[
    {
        "Id":"b7919e7e49b1fc580f046734ab6eba53435200a9b07a1f75b176afe6663ee573",
        "Names":[
            "/i3/consul"
        ],
        "Image":"progrium/consul",
        "Command":"/bin/start -server -bootstrap",
        "Created":1459070754,
        "Status":"Up About an hour",
        "Ports":[
            {
                "IP":"",
                "PrivatePort":8301,
                "PublicPort":0,
                "Type":"udp"
            },
            {
                "IP":"192.168.1.245",
                "PrivatePort":8500,
                "PublicPort":8500,
                "Type":"tcp"
            },
            {
                "IP":"",
                "PrivatePort":8301,
                "PublicPort":0,
                "Type":"tcp"
            },
            {
                "IP":"",
                "PrivatePort":8302,
                "PublicPort":0,
                "Type":"udp"
            },
            {
                "IP":"",
                "PrivatePort":8300,
                "PublicPort":0,
                "Type":"tcp"
            },
            {
                "IP":"",
                "PrivatePort":53,
                "PublicPort":0,
                "Type":"tcp"
            },
            {
                "IP":"",
                "PrivatePort":53,
                "PublicPort":0,
                "Type":"udp"
            },
            {
                "IP":"",
                "PrivatePort":8400,
                "PublicPort":0,
                "Type":"tcp"
            },
            {
                "IP":"",
                "PrivatePort":8302,
                "PublicPort":0,
                "Type":"tcp"
            }
        ],
        "SizeRw":0,
        "SizeRootFs":0,
        "Labels":{

        },
        "NetworkSettings":{
            "Networks":{
                "bridge":{
                    "IPAMConfig":null,
                    "Links":null,
                    "Aliases":null,
                    "NetworkID":"",
                    "EndpointID":"3527825ec17c51e77cfe005a7bf364e2d2b8777dc500cd7554309e855fcc5395",
                    "Gateway":"172.17.0.1",
                    "IPAddress":"172.17.0.2",
                    "IPPrefixLen":16,
                    "IPv6Gateway":"",
                    "GlobalIPv6Address":"",
                    "GlobalIPv6PrefixLen":0,
                    "MacAddress":"02:42:ac:11:00:02"
                }
            }
        }
    }
]
```
可以看到，和以前的remote API获取到的基本相同，只是在IP那里，从`0.0.0.0`变成了实际的IP

## pull一个镜像
```
curl -X POST http://192.168.1.245:4000/images/create?fromImage=ubuntu
```


## 整一个容器试试
```
# 创建
curl -X POST -H "Content-Type: application/json" -d '{"Image":"registry:2.2.1"}' http://192.168.1.245:4000/containers/create

# 记录返回的id

# 启动
#curl -X POST http://192.168.1.245:4000/containers/(id)/start
curl -X POST http://192.168.1.245:4000/containers/69e61f836c2fad4cf29a0f37c2b4575e267b45c2931737152ef6f40a9d8a4279/start

# stop
curl -X POST http://192.168.1.245:4000/containers/69e61f836c2fad4cf29a0f37c2b4575e267b45c2931737152ef6f40a9d8a4279/stop

# remove
curl -X DELETE http://192.168.1.245:4000/containers/69e61f836c2fad4cf29a0f37c2b4575e267b45c2931737152ef6f40a9d8a4279?v=1

```


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

