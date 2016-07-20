---
title: harbor源码分析
date: 2016-07-20 00:00:00
categories:
- code
tags: 
- docker
- registry
- vmware
- harbor
mathjax: true
description: 
---
# 背景
之前自己搞了个玩具registry，没有权限控制，没有角色，没有统计。正好vwmare开源了harbor，号称是企业级仓库，我自然是不会放过，要研究一下。

<!--more-->

# 部署

## 官方方法
> Install Harbor with the following commands. Note that the docker-compose process can take a while.
```
cd Deploy

$ ./prepare
Generated configuration file: ./config/ui/env
Generated configuration file: ./config/ui/app.conf
Generated configuration file: ./config/registry/config.yml
Generated configuration file: ./config/db/env

docker-compose up -d
```

## 特殊国情下的模式

具体看[https://github.com/vmware/harbor/blob/master/docs/image_pulling_chinese_user.md](https://github.com/vmware/harbor/blob/master/docs/image_pulling_chinese_user.md)
需要注意的是，Daoloud上的registry:2.3已经失效，需要修改以下compose.yml，修改registry.image
```
  registry:
    # 注意改image
    image: registry:2.3.0
    volumes:
      - /data/registry:/storage
      - ./config/registry/:/etc/registry/
    ports:
      - 5001:5001
    command:
      /etc/registry/config.yml
    depends_on:
      - log
    logging:
      driver: "syslog"
      options:
        syslog-address: "tcp://127.0.0.1:1514"
        syslog-tag: "registry"
```

## 离线模式
由于公司坑爹的模式，很多镜像下载不了，只好在家pull下来，然后save成tar，再到公司load
具体看这[链接](https://github.com/vmware/harbor/releases/download/0.3.0/harbor-0.3.0.tgz)

# 源码

## 代码结构
通过`tree -d ./`生成
```
├── api
│   └── jobs
├── auth
│   ├── db
│   └── ldap
├── contrib
├── controllers
├── dao
├── Deploy
│   ├── config
│   │   ├── db
│   │   ├── jobservice
│   │   ├── nginx
│   │   │   └── cert
│   │   ├── registry
│   │   └── ui
│   ├── db
│   ├── kubernetes
│   │   └── dockerfiles
│   ├── log
│   └── templates
│       ├── db
│       ├── jobservice
│       ├── registry
│       └── ui
├── job
│   ├── config
│   ├── replication
│   └── utils
├── jobservice
├── models
├── service
│   ├── cache
│   ├── token
│   └── utils
├── static
│   ├── i18n
│   ├── resources
│   │   ├── css
│   │   ├── img
│   │   └── js
│   │       ├── components
│   │       ├── layout
│   │       ├── services
│   │       └── session
│   └── vendors
│       ├── angularjs
│       ├── eonasdan-bootstrap-datetimepicker
│       │   └── build
│       │       ├── css
│       │       └── js
│       └── moment
│           └── min
├── tests
│   └── apitests
│       └── apilib
├── ui
├── utils
│   ├── log
│   └── registry
│       ├── auth
│       └── error
├── vendor
│   ├── 三方库
└── views
    └── sections
```

-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
