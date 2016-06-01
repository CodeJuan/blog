---
title: 用go写的镜像构建微服务
date: 2016-02-17 00:00:00
categories:
- code
tags: 
- golang
- microservice
- docker
mathjax: true
description: 
---

# 功能
前面已经把私有registry，镜像下载加速器([摸我](http://docs.alauda.cn/feature/accelerator.html)，其实就是基于registry官方镜像设置一个proxy，超级简单)完成了。
这个时候就可以提供类似Daoloud的代码构建功能啦
1. 用户点击构建按钮（或是其他触发方式）
2. 我的镜像构建微服务收到请求后，就从内网github Clone代码
3. 在刚Clone代码里找到Dockerfile
4. 执行docker build -t `私有registry域名/用户名/镜像名：tag` .
5. docker push 刚build出来的镜像
6. 构建日志，构建结果，入库
7. 返回 `私有registry域名/用户名/镜像名：tag`

用户就可以 pull `私有registry域名/用户名/镜像名：tag` 啦
<!--more-->

# 记录
终于用go写完了一个类似DaoCloud自动构建镜像的微服务，一边google一边写，全程都是用Docker来开发的，收获还是挺大的，简单记录下。
1. 基于golang1.5.3基础镜像，然后在代码里增加一个Godeps，把用到的库都放在Godeps，然后在Dockefile里r把Goeps加入到GOPATH环境变量
1. 参考了docker/distribution的Dockerfile，[https://github.com/CodeJuan/distribution/blob/master/Dockerfile](https://github.com/CodeJuan/distribution/blob/master/Dockerfile)
1. 由于只提供restful，就用的gorilla/mux框架
1. 数据库MySQL，orm用的是gorm
1. 用到了sync,crypt等库
1. 在docker内使用宿主机docker daemon的方法
   - RUN (wget "https://get.docker.com/builds/..." -O /usr/bin/docker &&\
   - chmod +x /usr/bin/docker)
   - 然后再启动的时候指定/var/run/docker.sock:/var/run/docker.sock
1. 开发测试部署都是用的Docker，数据库也是Docker。大概流程是
    - 修改代码，build我的微服务镜像，push到我的私有registry
    - docker-compose从私有registry获取刚build的镜像，由于link了MySQL，就会先启动MySQL。
    - 接下来自动跑测试，我用的是python给我的微服务发post get等等。
1. 后续计划
    - 自动测试的脚本要加上从数据库里获取结果，与我的期望值进行比对。目前还是人肉比对，有些慢
    - jenkins自动触发，有代码上了库就自动拉下来完成打镜像，推镜像，拉镜像，compse up，测试的一系列操作





----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

