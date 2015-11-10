---
title: openstack性能测试器(4):rabbitmq-server、kombu、tcpdump
date: 2015-11-10 00:00:00
categories:
- code
tags: 
- openstack
- tcpdump
- rabbitmq
mathjax: true
description: 
---

# rabbitmq server

[http://www.rabbitmq.com/download.html](http://www.rabbitmq.com/download.html)

```sh
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server-3.5.6-1.noarch.rpm
sudo rpm -ivh rabbitmq-server-3.5.6-1.noarch.rpm 
```
提示缺少erlang

[http://www.erlang.org/download.html](http://www.erlang.org/download.html)


```sh
http://www.erlang.org/download/otp_src_18.1.tar.gz
tar -xvf otp_src_18.1.tar.gz
cd otp_src_18.1
./configure
sudo make
sudo make install

# 提示缺少fop和wxWidgets
sudo yum install fop
sudo yum install wxWidgets
```


```sh
sudo rpm -ivh --nodeps rabbitmq-server-3.5.6-1.noarch.rpm 
```

<!--more-->





----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

