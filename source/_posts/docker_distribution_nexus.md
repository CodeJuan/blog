---
title: docker(4)-nexus3
date: 2016-01-13 00:00:00
categories:
- code
tags: 
- docker
- docker-registry
- docker-distribution
mathjax: true
description: 
---

# 背景
前面说到要搭建自己的私有docker云，尝试了registry，感觉还不错。
不过，今天有大神推荐nexus3，说很方便。所以呢，我就尝试一下。
<!--more-->

# 下载安装nexu3 repo manager oss
下载链接[https://support.sonatype.com/hc/en-us/articles/213466018-Nexus-Repository-Manager-3-0-Technology-Preview-Milestone-6-Release-](https://support.sonatype.com/hc/en-us/articles/213466018-Nexus-Repository-Manager-3-0-Technology-Preview-Milestone-6-Release-)
我选择了[Unix bundle](http://download.sonatype.com/nexus/oss/nexus-installer-3.0.0-m6-unix-archive.tar.gz)
```sh
wget http://download.sonatype.com/nexus/oss/nexus-installer-3.0.0-m6-unix-archive.tar.gz
tar -zxf nexus-installer-3.0.0-m6-unix-archive.tar.gz
cd nexus-installer-3.0.0-m6-unix-archive
cd bin
./nexus run
```
时间会比较久，直到出现**Started Nexus Repository Manager 3.0.0-xxxxxxx**
然后访问[http://192.168.1.173:8081/](http://192.168.1.173:8081/)，其中的IP换成安装nexus3机器的IP

# 配置https
registry V2需要https，参考这里进行配置[https://books.sonatype.com/nexus-book/3.0/reference/security.html#ssl-inbound](https://books.sonatype.com/nexus-book/3.0/reference/security.html#ssl-inbound)

还有这位印度GG的视频[http://www.sonatype.org/nexus/2015/09/22/docker-and-nexus-3-ready-set-action/](http://www.sonatype.org/nexus/2015/09/22/docker-and-nexus-3-ready-set-action/)

按照[http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html](http://www.eclipse.org/jetty/documentation/current/configuring-ssl.html)生成不了jdx，奇怪

个人感觉还是nexus比原生的registry好用，希望能搞定

累成狗了，明天继续






----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

