---
title: 一页简历
date: 2014-01-01 00:00:00
categories:
- mumble
tags: 
- resume
mathjax: true
description: 
---

项目|内容
----|------
mail|[xh@decbug.com](mailto:xh@decbug.com)
技术|[github](http://github.com/codejuan) 、 [blog](http://blog.decbug.com) 、 [stackoverflow](http://stackoverflow.com/users/2763396/codejuan)
毕业学校|南昌大学 自动化 20xx年～20xx年 本科
手机号|**个人隐私**

<!--more-->

### 技能

全栈(全不能-_-!)，设计、编码、持续集成、测试、部署、运维；性能优化、敏捷、研发效率提升、人员培养
技术控，对代码略有洁癖，爱好折腾，善于解决各种疑难问题，尝试新技术

项目|评分|短评
----|------|-----
C/C++|熟悉|虽用的比较多，但实在不敢说精通
JAVA/Python/Go/PowerShell/C#|一般|
lua/Shell/Node|了解|
英语|熟悉|读：只谷歌，看英文资料毫无压力；听：不错；写说：一般
windows|熟悉|对windows的消息，线程，进程，异常，windbg都比较熟悉
linux|熟悉|看过内核的书，MMU，进程，锁，调度，中断，文件系统，IO等

### 工作经历

#### 华为 2014年～至今
1. 云计算
    - Docker，企业私有镜像仓库及加速器，nginx+registry+自研DFS
    - Docker镜像构建服务：基于Go [gorilla/mux](https://github.com/gorilla/mux)、MySQL、微服务、Restful，从开发测试部署都是Docker化模式
    - OpenStack性能模拟器，测试各组件的性能。基于[RabbitMQ-C语言](https://github.com/alanxz/rabbitmq-c)实现AMQP协议，lua实现业务
2. 数据挖掘
    - 业务代码C++，UI用C#，分析基站产生的海量通信log
    - 作为技术专家，负责整体技术架构，性能优化、难点攻关、技术指导、CodeReviewa、重构、开发效率提升
    - 持续集成，将整个系统的构建时间由2小时缩短到0.5小时；搭建单元测试、自动化测试，覆盖到关键业务代码
    - 总结出常见低性能C++代码案例，以及google perf tool+vs performance analyse使用方法
    - 采用STXXL+BOOST序列化，将非热点数据存硬盘，仅需改动一点代码，使数据处理能力GB提升TB
    - 指导组内同事开发，解决各种疑难杂症，如CoreDump，性能慢等；招聘，负责技术面试；培训，STL用法，单元测试gtest用法等等

#### Samsung 2013年～2014年
- 接触前端/数据库等等，丰富技能树
- 开发软件生命周期管理系统，C#+SilverLight，Redmine/Jira做二次开发；JAVA + SSH做了个xxx管理系统


#### 中兴 2011年～2013年
- 开发手机检测系统。Windows应用程序，C/S架构，C++，用到socket、USB等等
- 有手机/无线路由的硬件经验，了解高通调测指令及方法，了解Atheros,Broadcom的路由方案。

#### Giesecke&Devrient 20xx年～2011年
- 由维修工转职为程序员，兼职过IT，组装电脑，维修电脑，用过VB，C++，C#，奠定了啥都会一点的基础
- 基于VB实现一套标签打印系统，并针对业务需求优化，效果胜于某商用标签打印软件；基于VC，通过串口及并口操作设备，将生产过程自动化