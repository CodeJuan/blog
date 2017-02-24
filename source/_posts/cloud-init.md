---
title: cloud-init
date: 2017-02-24 00:00:00
categories:
- code
tags: 
- openstack
mathjax: true
description: 
---

刚创出来的虚拟机，要如何设置初始密码？如何添加环境变量？如何进行一系列的预置操作？
答案就是cloud-init

<!--more-->

对于open stack来说，cloud-init可以通过两种方式获取数据
1. config drive
2. 通过meta-data服务获取

# config drive
大概原理及流程
1. 生成相关的meta-data.json, user-data
1. 制作iso9xxx格式的iso
1. 挂载到/dev/vdb
1. cloud-init配置datasource为config drive
1. cloud-init读取，进行配置


# meta-data
1. nova有个meta-data服务
2. 创虚拟机的时候，配置一条路由169.254.169.254
3. cloud-init配置datasource为openstack
4. 从http://169.254.169.254/openstack获取meta-data.json
5. 进行配置

# user-data
nova boot --user-data config.txt

```
#cloud-config
chpasswd:
  list: |
    root:root
    abc:password1
pwauth: True
sshpasswd: yes

writefiles:
  PermitRoot: yes
```

# 参考
[https://help.ubuntu.com/community/CloudInit](https://help.ubuntu.com/community/CloudInit)
[http://www.ibm.com/developerworks/cn/cloud/library/1509_liukg_openstackmeta/index.html](http://www.ibm.com/developerworks/cn/cloud/library/1509_liukg_openstackmeta/index.html)
[http://www.chenshake.com/openstack-mirror-and-password/](http://www.chenshake.com/openstack-mirror-and-password/)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


