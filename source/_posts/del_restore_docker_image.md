---
title: 删除恢复docker registry中的镜像
date: 2016-07-21 00:00:00
categories:
- code
tags: 
- docker
- registry
- image
mathjax: true
description: 
---
# 背景
看到有容云的AppHouse有删除、恢复镜像的功能，觉得很厉害，打算在我的山寨容器云的仓库上也加上这个功能

<!--more-->


# 官方不建议删除镜像
因为[https://github.com/docker/distribution/blob/master/ROADMAP.md#deletes](https://github.com/docker/distribution/blob/master/ROADMAP.md#deletes)

> NOTE: Deletes are a much asked for feature. Before requesting this feature or participating in discussion, we ask that you read this section in full and understand the problems behind deletes.

删除固然简单，删除manifest和blob就行。但是，blob是分层的，可能是多个镜像共用的，如果在删除某个blob的时候，其他人正在使用这个blob，那么就麻烦了。


# 其实是有删除接口的

```
DELETE /v2/<name>/manifests/<reference>
Host: <registry host>
Authorization: <scheme> <token>
```

# 配置文件

```
version: 0.1
log:
  fields:
    service: registry
storage:
    cache:
        blobdescriptor: inmemory
    filesystem:
        rootdirectory: /var/lib/registry
# 这里需要把delelte设置为true
    delete:
        enabled: true
http:
    addr: :5000
    headers:
        X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
```

# 用python写的测试代码
```py
# -*- coding: utf-8 -*
import requests
import simplejson as json


registry = "http://192.168.1.245:25678/v2/"
image = "test/consul"
tag = "latest"


r = requests.get(registry + "_catalog/", verify=False)
print r.text


headers = {'Accept': 'application/vnd.docker.distribution.manifest.v2+json'}
r = requests.get(registry + image + "/manifests/" + tag, headers=headers, verify=False)

# 获取manifest
manifest = r.headers['Docker-Content-Digest']

print "manifest: " + manifest

data = r.text
print data
# for blob in data['fsLayers']:
#     blob_digest = blob['blobSum']
#     print blob_digest
#     r = requests.delete(registry + "v2/xx/hello/blobs/" + blob_digest, verify=False)
#     print r

# 删除
print "delete"
r = requests.delete(registry + image + "/manifests/" + manifest, verify=False)
print r.status_code


# 恢复
print "restore"
r = requests.put(registry + image + "/manifests/" + tag, data=data, verify=False)
print r.status_code
```

-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
