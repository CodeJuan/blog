---
title: 用jenkins监控程序内存CPU
date: 2015-01-12 23:30:09
categories:
- code
tags: 
- jenkins
- memory
- CPU
mathjax: true
description:
---


## 背景 

组里有许多初学C++的小朋友，对于STL及算法的时间/空间复杂度的敏感性不强，写出来的代码虽然完成了功能，但是运行时间过长，占用内存都过大。

老夫虽给小朋友们科普过几次，但效果还不是特别理想，有道是不掉坑，不长记性，古人诚不欺我。可势必不能把性能问题流到后端，老夫不得不在持续集成上增加一道小菜——检测运行时间、内存峰值及均值。

大概原理：写个脚本

1. 取得构建包列表。下载没有测试过的最新的包。
2. 读配置文件，获取测试用例，期望运行时间，期望内存峰值及均值。
3. 自动运行程序，每1s采样一次进程内存大小，记录在日志里。
4. 当程序结束时，计算运行时间间隔，与期望值比较，如果超出，则红。
5. 分析之前记录的内存日志，求出峰值和均值，如果超出期望，也红。

<!--more-->

## 安装

### windows

此项目是开发windows应用程序，正好在[华军](http://www.onlinedown.net/soft/172085.htm)有1.575的安装版，安装后就能用，省去不少事，访问[http://你的IP:8080/](http://localhost:8080/)就能看到jenkins的dashboard。


### ubuntu
家里木有windows，只能在ubuntu上安装一份，用于截图了。

- JAVA，TOMCAT自然是少不了的。
- 在[官网](http://jenkins-ci.org/)下载Jenkins.war，然后拷贝到你的tomcat的webapps下。
- 启动tomcat，运行tomcat/bin下destartup，命令： sudo sh startup.sh。
- 进入[http://localhost:8080/jenkins/](http://localhost:8080/jenkins/)，熟悉的dashboard又出现了。

![](https://raw.githubusercontent.com/CodeJuan/codejuan.github.io/master/images/blog/jenkins/jenkins_welcome.png)

## 开工

### 下载插件
由于公司坑爹的网络设置，无法直接在线更新，只能采用手动下载。以Build Pipeline Plugin为例示范一下
- 进入 plugin manager，找到并点击[Build Pipeline Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Build+Pipeline+Plugin)
- 在表格左上角找到Lastest Release，点击[archives](http://updates.jenkins-ci.org/download/plugins/build-pipeline-plugin/)，下载你喜欢的版本即可。


未完待续


-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

