---
title: 多线程同步镜像
date: 2015-09-07 00:00:00
categories:
- code
tags: 
- mirror
- rsync
- wget
- python
mathjax: true
description: 
---

## 背景
以前的同步是单线程的，感觉没有完全发挥带宽的优势，所以想尝试一下多线程同步。

大概的思路:
- 爬index，如hust的镜像[http://mirrors.hust.edu.cn/ubuntu-releases/](http://mirrors.hust.edu.cn/ubuntu-releases/)，找出所有`href`。以前用过`beautifulsoup`，感觉还可以，打算试试。
- 每个href就启动一个rsync，同步到对应的文件夹
- 记录每个rsync的同步状态
- 汇总全部状态，看所有href是否都同步成功
<!--more-->

## 步骤

### 装beautifulsoup
```sh
#下载并安装pip
wget https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz
tar zxvf pip-7.1.2.tar.gz
cd pip-7.1.2
sudo python setup.py install

#装beautifulsoup4
sudo pip install beautifulsoup4
```

其实还有一种方法，直接wget镜像的index.html，然后正则匹配

### 开始爬
由于index的页面都很简洁，爬起来还是相对比较容易。

