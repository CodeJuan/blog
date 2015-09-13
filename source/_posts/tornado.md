---
title: tornado 
date: 2015-09-13 00:00:00
categories:
- code
tags: 
- python
- tornado
mathjax: true
description: 
---

## 背景
实现白名单，只允许可信用户访问我的服务
考虑采用iptables或者nginx

如果用nginx，那么可以建立一个`allow_ip.conf`，然后把这个配置文件include到nginx的配置中
用户可以主动添加他们的IP到我这，打算玩玩tornado，用户输入他的IP，然后存入到我的文件中，最后定时合并到`allow_ip.conf`

<!--more-->

## 分析一下需求
- 一个input，一个button，点button就把input的内容追加到某个文件中，暂时不考虑input是否合法
- tornado 写一个handler
- 定时把最新的IP合并到allow_ip.con

## 安装
```sh
wget https://pypi.python.org/packages/source/t/tornado/tornado-4.2.1.tar.gz
tar zxvf tornado-4.2.1.tar.gz
cd tornado-4.2.1
python setup.py build
sudo python setup.py install
```

## 开搞



----------------------------

`本博客欢迎转发,但请保留原作者信息`                                                                                                                                                                          
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

