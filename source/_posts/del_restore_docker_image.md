---
title: 高级docker镜像仓库之删除镜像与恢复镜像
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

# 抓包分析有容云
## 抓包
1. 因为容器间通信肯定会经过docker0，所以抓docker0就够了
```
tcpdump -i docker0 -w del_restore.cap
```
2. 查看AppHouse的registry容器的IP
```
docker ps | grep app
# 得到registry的container ID

docker inspect 3a9d50c216de
#找到IP "IPAddress": "172.16.52.3"
```
3. wireshark加上条件`(ip.src == 172.16.52.3) || (ip.dst == 172.16.52.3) && tcp.port ==5002 && http`

## 分析包

### 获取镜像信息

![get](https://github.com/CodeJuan/blog/raw/master/source/image/del_image/get.png)

![get response](https://github.com/CodeJuan/blog/raw/master/source/image/del_image/get_rsp.png)

获取镜像信息，应该是把返回的body都保存下来了

### 删除镜像

![delete](https://github.com/CodeJuan/blog/raw/master/source/image/del_image/del.png)

![delete response](https://github.com/CodeJuan/blog/raw/master/source/image/del_image/del_rsp.png)

这个没啥好说

### 恢复镜像


![put](https://github.com/CodeJuan/blog/raw/master/source/image/del_image/put.png)

![put response](https://github.com/CodeJuan/blog/raw/master/source/image/del_image/put_rsp.png)

应该是把之前保存的body又再put进去




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
# 时序图

{% plantuml %}
autonumber "<font color=blue><b> 0.  "

client->gateway
gateway->registry: get manifest
registry-->gateway: return manifest
gateway->trash: insert image name+tag to trash
gateway->registry: delete
registry-->gateway: return result
gateway->trash: save result
gateway-->client: result

database trash

box "DB" #LightGray
	participant trash
end box
{% endplantuml %}

-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
