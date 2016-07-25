---
title: 在家玩DaoCloud企业版--原理
date: 2016-07-25 00:00:00
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
DaoCloud是国内领先的容器云，我的山寨容器云需要多向他学习。
前几天把环境弄好了，也简单试用了，大概知道DCE技术栈。
果然是把docker原生技术发挥到了很棒的境界，很值得学习。

<!--more-->

# 系统应用
![](https://cloud.githubusercontent.com/assets/5423628/17101264/3635ecee-52a6-11e6-82c7-308f7384b628.png)
有controller，agent，manager，etcd，4个容器
从名字上来看
- controller应该是nginx+UI+reigstry的组合
- agent，应该是swarm agent
- manager，不用说，是swarm manager吧
- etcd，做分布式存储

接下来我一个个exec进去看看

# controller容器
本来想用ps aux看下进程，竟然提示cmd不存在，看来DaoCloud对为了减少镜像体积，做了很深入的优化。


## 初步分析

当然，这个难不倒我，在/proc/里找到进程ID，然后cat每个进程的cmd，方法
`find /proc -mindepth 2 -maxdepth 2 -name exe -exec ls -lh {} \; 2>/dev/null`
结果

```
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/1/exe -> /usr/bin/python2.7
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/6/exe -> /usr/local/bin/dce-nginx
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/7/exe -> /usr/local/bin/dce-stream
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/11/exe -> /usr/sbin/nginx
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/12/exe -> /usr/local/bin/redis-server
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/15/exe -> /usr/local/bin/dce-controller
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/27/exe -> /usr/local/bin/dce-stream
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/30/exe -> /usr/local/bin/dce-controller
lrwxrwxrwx 1 root root 0 Jul 25 12:53 /proc/5289/exe -> /usr/local/bin/dce-controller
lrwxrwxrwx 1 root root 0 Jul 25 12:52 /proc/5297/exe -> /usr/local/bin/dce-registry
lrwxrwxrwx 1 root root 0 Jul 25 12:52 /proc/5302/exe -> /usr/local/bin/registry
lrwxrwxrwx 1 root root 0 Jul 25 12:52 /proc/5309/exe -> /usr/sbin/nginx
lrwxrwxrwx 1 root root 0 Jul 25 12:52 /proc/5657/exe -> /bin/bash
lrwxrwxrwx 1 root root 0 Jul 25 12:59 /proc/5707/exe -> /usr/bin/find
```

- 进程1是python，可能是监控进程
- 进程6、11、5309，nginx，目测是worker
- 进程7和27，stream是什么么？记得首页上有个资源使用情况预测吗？
- 进程12，redis，看来是用来做持久化了哦
- 进程15、30、5289， dce-controller，不清楚，还需要分析，难道也是UI？
- 5279，5302，为啥有两个registry
- 后面两个都是我产生的进程，可以忽略。

## 进一步分析
把所有PID的cmdline都cat出来看看
```
files=$(find /proc -type f -name 'cmdline' | grep -v 'task' | grep -v "/proc/cmdline")
for file in $files; do
    cat $file >> aaa
    echo "" >> aaa
done
```
结果
```
/usr/bin/python/usr/bin/supervisord
/usr/local/bin/dce-nginx
/usr/local/bin/dce-stream
nginx: master process nginx -g daemon off;
/usr/local/bin/redis-server *:6379
/usr/local/bin/dce-controller
/usr/local/bin/dce-stream
/usr/local/bin/dce-controller
/usr/local/bin/dce-controller
/usr/local/bin/dce-registry
/usr/local/bin/registryserve/etc/docker/registry/conf.yml
nginx: worker process
bash
```
通过命令行，每个进程的作用就更清晰了
再来分析一遍
- 进程1是python，supervisord，果然是监控进程
- 进程6、11、5309，nginx，果然是master+worker
- 进程7和27，stream是什么么？记得首页上有个资源使用情况预测吗？
- 进程12，redis，看来是用来做持久化了哦
- 进程15、30、5289， dce-controller，应该就是UI？还可能会接受各个节点上报的资源使用情况
- 5279，5302，为啥有两个registry
    - dce-registry 可能是index，用来做权限控制的？
    - registry就仓库了

## 推测代码
nginx 配置
```
  upstream registry {
    server registry:5000;
  }

  upstream ui {
    server ui:80;
  }

  server {
    listen 80;

    location /v2/ {
      proxy_pass http://registry/v2/;
    }

    location / {
      proxy_pass http://ui/;
  }
```

{% plantuml %}
title supervisord监控全部进程

interface "client" as C

database "redis" {
}

folder "仓库" as hub{
    [registry]
    [dce_registry]
    [registry]<-->[dce_registry]

  }

[nginx]

[nginx] -up->[dce_controller]: `/`
[nginx] -up->[dce_registry]: `/v2/`
[dce_controller] -left->redis
[stream] -left->redis
{% endplantuml %}

# etcd
etcd没有刻意分析的必要，看下启动命令
`/etcd --name dce-etcd-138.68.2.15 --data-dir /data`

# manager
![启动命令](https://cloud.githubusercontent.com/assets/5423628/17104503/ce03684e-52b5-11e6-965a-21697a61fede.png)
```
/swarm manage --replication --engine-refresh-min-interval 5s --engine-refresh-max-interval 10s --tls --tlscacert /etc/ssl/private/engine/ca.pem --tlscert /etc/ssl/private/engine/engine-cert.pem --tlskey /etc/ssl/private/engine/engine-key.pem etcd://dce_etcd_1:2379
```
比我之前用的swarm多了证书，etcd的地址应该是通过compose的service创建的网络来互联的

# agent
启动命令
```
bash /usr/local/bin/supervisord.sh
```
结合部署节点的命令
```
bash -c "$(docker run -i --rm daocloud.io/daocloud/dce join {你的控制器IP})"
```
应该是百控制节点的IP写入到supervisord.sh，然后调用swarm join



-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
