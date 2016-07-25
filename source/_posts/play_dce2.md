---
title: 在家玩DaoCloud企业版--原理
date: 2016-07-20 00:00:00
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

# controller
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
- 进程15、30、5289， dce-controller，不清楚，还需要分析，难道也是UI？
- 5279，5302，为啥有两个registry
    - dce-registry 可能是index，用来做权限控制的？
    - registry就仓库了



-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
