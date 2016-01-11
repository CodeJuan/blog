---
title: docker-compose
date: 2016-01-11 00:00:00
categories:
- code
tags: 
- docker
- compose
mathjax: true
description: 
---

# 背景
之前已经把docker的常用命令都试了一遍，也通过命令启动了一个django+mysql+redis的应用。需要敲很多行命令才能完成，感觉还是有些麻烦。
有鉴于此，正好可以尝试一下docker-compose，通过一个yml文件，就能启动一个服务。
<!--more-->

# docker-compose简介
> Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application’s services. Then, using a single command, you create and start all the services from your configuration. To learn more about all the features of Compose see the list of features.
有点类似AWS的栈的概念，通过compose把一堆docker启动并组合起来，就是一个完整的服务。
与dockerfile的区别：
- docerfile对应的是一个docker，compose定义的是一组docker。


# install
```sh
sudo -i

curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# 由于github经常连不上，那么也可以用DaoCloud的链接
# curl -L https://get.daocloud.io/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
exit
docker-compose --version
```

# 把当前用户加到docker组
由于docker的运行需要root权限，在非root用户时每次都要输入`sudo`，有点麻烦。
可以把当前用户加入到docker组，这样就不用每次都输入sudo了，方法
- sudo vi /etc/group
- 在docker组的最后加入当前用户名
```
docker:x:993:your_name
```

# 简单的docker-compose
代码在[https://github.com/CodeJuan/test_docker_compose](https://github.com/CodeJuan/test_docker_compose)

## 创建一个app.py
```python
from flask import Flask
from redis import Redis


app = Flask(__name__)
redis = Redis(host='redis', port=6379)


@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello World! I have been seen %s times.' % redis.get('hits')


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

## 创建requirements.txt
```
flask
redis
```
这里没有指定版本，那么pip install的就是最新的版本

## 创建Dockerfile
```
FROM daocloud.io/python:2-onbuild
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD python app.py
```

## docker-compose.yml
```
web:
  build: .
  ports:
   - "5000:5000"
  volumes:
   - .:/code
  links:
   - redis
redis:
  build: ./redis
```

## DaoCloud的redis默认有随机密码
所以需要给redis写一个dockerfile
```
FROM daocloud.io/daocloud/dao-redis:master-init

# 设置环境变量，表示不需要密码
ENV REDIS_PASS=**None**
```



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

