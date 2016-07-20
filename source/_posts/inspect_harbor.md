---
title: 看harbor源码
date: 2016-07-20 20:00:00
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
不建议用，最好还是番茄自己build
因为Daoloud和CaiCloud的版本都太老，很多新特性都没有。


## 离线模式
由于公司坑爹的模式，很多镜像下载不了，只好在家pull下来，然后save成tar，再到公司load
具体看这[链接](https://github.com/vmware/harbor/releases/download/0.3.0/harbor-0.3.0.tgz)



# 架构图

![来自[dockone的架构图](http://dockone.io/article/1179)](http://dockerone.com/uploads/article/20160331/d9f81c0cdcc4f7b7af42d27d030cf381.png)


{% plantuml %}
interface "client" as C

database "MySql" {
}

folder "UI" {
    [main]
    [auth]
    [notification]
  }

C - [nginx]
[nginx] ..> [registry] : url是`/v2`
[nginx] ..> [main] : url是`/`
[registry] ..> [auth] : token
[registry] ..> [notification] : notification
UI ..> MySql:db

note top of [registry]
  通知就发到notification
  当需要鉴权时就调用auth
end note
{% endplantuml %}
我画的架构图

# 代码结构
通过`tree -d ./`生成，略去部分不重要代码
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
├── static前端
├── tests
├── ui
├── utils共用组件
├── vendor三方库
└── views
```

对应架构图来看
- proxy就是nginx，`Deploy/config/nginx/nginx.conf`
- UI就是`ui/main.go`
- token就是`service/token/token.go`
- registry的webhook就是`Deploy/templates/registry/config.yml`的notifications和auth
  - auth指向`beego.Router("/service/token", &token.Handler{})`，`service/token/token.go`
  - notification指向`beego.Router("/service/notifications", &service.NotificationHandler{})`，用来同步备份到远端仓库。`service/notification.go`
- `auth/authenticator.go`接口，有本地db和LDAP两种实现，在init时会registrer，根据配置选择用哪个实现。



# 备份策略
![](https://cloud.githubusercontent.com/assets/5423628/16990645/4d744da8-4ecb-11e6-9f34-b052a0ba5cc6.png)
这个特性很不错啊，registry有了新的更新，就notify到ui的notification，根据配置的策略，是否要备份到远端registry

# LDAP
用的是open LDAP
LDAP_BASE_DN 这个还不会配置

# RBAC
Role Based Access Control
`service/token/authutils.go的FilterAccess`，通过token里的scope获取action，再到数据库里查询是否有权限

-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
