---
title: docker(3)-distribution
date: 2016-01-12 00:00:00
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
要搞自己的容器云了，那么就得有自己的docker hub，于是采用[docker/registry V1](https://github.com/docker/docker-registry)。
但由于registry V1荒废许久，所以最后决定采用[docker/distribution](https://github.com/docker/distribution)
鉴于很多地方称呼distribution为registry V2，我这里就不区分版本了，都叫做registry好了。
<!--more-->

# 通过docker运行
先尝试一个简单的用法，即直接pull一个registry好了
```sh
# 从DaoCloud pull一个registry镜像
docker pull daocloud.io/library/registry:2.2.1
docker run -p 5000:5000 --name registry daocloud.io/library/registry:2.2.1
docker pull golang:1.5.2
docker tag golang:1.5.2 localhost:5000/golang
docker push localhost:5000/golang
```
通过查看源码中的Dockerfile，有一句`VOLUME ["/var/lib/registry"]`，那么这个路径就是docker里存放push上来的镜像的路径
```
# 获取registry的ID
docker ps

# 进入docker中调试,31f029b39e3c就是上一条命令获取到的ID
docker exec -it 31f029b39e3c bash

# 这个路径下就有一个golang的文件夹
cd /var/lib/registry/docker/registry/v2/repositories

# 退出docker
exit

# 在宿主机中查看路径
docker inspect 31f029b39e3c

# 查看Mounts字段
# /var/lib/docker/volumes/3bd3f857da3e887fd5d890066b1065450751aa3daf0d405e472e2d31abf44a61/_data
cd /var/lib/docker/volumes/3bd3f857da3e887fd5d890066b1065450751aa3daf0d405e472e2d31abf44a61/_data

# 果然也有docker/registry/v2/repositories/golang
```

# 源码
## 下载并安装源码
```sh
git clone git@github.com:docker/distribution.git
cd distribution

# 通过查看distribution的Dockerfile，发现需要把$PWD/Godeps/_workspace添加到GOPATH
# 不然就会编译不过，会报缺少一堆库。当然，如果不嫌麻烦的话，也可以把缺失的库都go get下来
export GOPATH=$GOPATH:$PWD/Godeps/_workspace

# make
make clean binaries

# 运行
bin/registry --version

# 启动，也是查看Dockerfile
# ENTRYPOINT ["registry"] CMD ["/etc/docker/registry/config.yml"]
# 而这个config.yml又是从cmd/registry/config-dev.yml拷贝过去的
# 所以，我们这里直接用cmd/registry/config-dev.yml
bin/registry cmd/registry/config-dev.yml
```



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

