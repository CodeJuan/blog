---
title: 不完整的简历
date: 2014-01-01 00:00:00
categories:
- mumble
tags: 
- resume
mathjax: true
description: 
---

# 个人资料
<!--more-->
标题|内容
----|------
mail|[xh@decbug.com](mailto:xh@decbug.com)
github|[codejuan](http://github.com/codejuan)
stackoverflow|[codejuan](http://stackoverflow.com/users/2763396/codejuan)
blog|[blog.decbug.com](http://blog.decbug.com)
毕业学校|南昌大学 20xx年～20xx年 本科
手机号|xxxxxxxxxxxx**个人隐私不公开可以发邮件索取**

# 技能

- 全栈，需求、设计、编码、持续集成、测试、部署、运维
- 人员培养、性能优化、敏捷、效率提升。

## 技术
项目|评分|短评
----|------|-----
C/C++|熟悉|虽用的比较多，但实在不敢说精通
JAVA/Python/Go/PowerShell/C#|一般|
lua/Shell|了解|
英语|熟悉|读：谷歌，看英文资料；听：不错；写说：一般
windows|熟悉|对windows的消息，线程，进程，异常，windbg都比较熟悉
linux|熟悉|看过内核的书，知道MMU，进程，锁，调度，中断，文件系统，IO等等

# 工作经历

## 华为 2014年～至今
1. 云计算
    - Docker，企业私有镜像仓库及加速器，nginx+registry v2+自研DFS，目标是做一个DaoCloud
    - OpenStack性能模拟器，测试各组件的性能。基于开源RabbitMQ客户端的C语言版本和lua实现，采用异步+状态机+责任链，仿真效果达到百万台虚拟机的水平
2. 在一个数据挖掘的150人团队担任技术`砖家`
    - 业务代码C++，UI用C#，分析基站的通信log
    - 持续集成，将整个系统的构建时间由2小时缩短到0.5小时；搭建单元测试(关键代码全覆盖)，自动化测试框架，内存泄漏检测
    - 负责性能优化，总结出常见低性能C++代码案例，以及google perf tool+vs performance analyse使用方法
    - 采用STXXL+BOOST序列化，将非热点数据缓存至硬盘，在基本不需要改动代码的前提下，使得工具的数据处理能力由GB级别跃升至TB级别。没有用redis的原因是，对已有代码冲击太大。
    - 指导组内同事开发，解决各种疑难杂症，如CoreD，性能慢等
    - 招聘，负责技术面试；培训，STL用法，单元测试gtest用法等等

## Samsung 2013年～2014年
- 接触前端/数据库等等，丰富技能树
- 软件生命周期管理系统，C#+SilverLight，Redmine/Jira做二次开发
- JAVA + SSH做了个xxx管理系统


## 中兴 2011年～2013年
- 开发手机检测系统。Windows应用程序，C/S架构，C++，用到socket、USB等等
- 有点手机/无线路由的硬件经验，了解高通调测指令及方法，了解Atheros,Broadcom的路由方案。

## Giesecke&Devrient 20xx年～20xx年
- 由维修工转职为程序员，用过VB，C++，C#，奠定了啥都会一点的基础
- 基于VB实现一套标签打印系统，并针对业务需求优化，效果胜于某商用标签打印软件
- 基于VC，通过串口及并口操作设备，将生产过程自动化
- 兼职过IT，会组装电脑，维修电脑，搭建局域网

