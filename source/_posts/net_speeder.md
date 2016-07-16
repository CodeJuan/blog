---
title: net-speeder番茄加速
date: 2016-07-15 00:00:00
categories:
- code
tags: 
- 番茄
mathjax: true
description: 
---
# 背景
由于流量不够用，又买了个廉价vps，3年只要8刀，64M内存，1G硬盘，250M流量。
由于配置比较差，且机房离大陆远，ping有300多ms，看youtube略卡，只好使用net-speeder

<!--more-->

# 方法

## 安装依赖
```
#安装libnet-dev：
apt-get install libnet1-dev
#安装libpcap-dev：
apt-get install libpcap0.8-dev 
```


## 安装net-speeder
```
wget https://github.com/snooda/net-speeder/archive/master.zip
unzip master.zip
cd net-speeder-master
# openvz 用这个命令make
sh build.sh -DCOOKED
```

## 添加开机启动
打开/etc/local.rc，加上
```
[net_speeder安装目录]/net_speeder venet0:0 "ip"
```

# 结果
不知是不算心理作用，果然不那么卡了

-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
