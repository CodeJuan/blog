---
title: docker(3)-搭建registry,nginx,mirror
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
关于registry的基本知识已经了解差不多了，现在开始搭建一个可用的私有registry
<!--more-->

# 架构

![](http://dockerone.com/uploads/article/20150512/1e111941614512fcc0bdeb2e80ee9384.png)

就采用[钟成](http://dockone.io/people/%E9%9A%BE%E6%98%93)提到的架构

# 进展1
搭建了registry+front，配置了https
折腾一天，累成狗了，不详细写拉。直接看代码吧，都写成脚本和compose了
[https://github.com/CodeJuan/private_registry](https://github.com/CodeJuan/private_registry)

# 进展2:registry集群
实现了负载均衡
用的是nginx1.9的镜像
[https://github.com/CodeJuan/private_registry/commit/7233fbf7def7b32daccc065f6ef546b234606e0d](https://github.com/CodeJuan/private_registry/commit/7233fbf7def7b32daccc065f6ef546b234606e0d)

# 进展3:后端存储
后端存储采用的是某共享存储技术，所有的registry都访问同一个存储集群，路径都一样

# 进展4：mirror
> If you have multiple instances of Docker running in your environment (e.g., multiple physical or virtual machines, all running the Docker daemon), each time one of them requires an image that it doesn’t have it will go out to the internet and fetch it from the public Docker registry. By running a local registry mirror, you can keep most of the redundant image fetch traffic on your local network.


```
mirror:
  restart: always
  image: registry:2.2.1
  volumes:
    - ./mirror:/var/lib/registry
  environment:
    STANDALONE: 'false'
    MIRROR_SOURCE: https://registry-1.docker.io
    MIRROR_SOURCE_INDEX: https://index.docker.io registry
  ports:
   - 5555:5000

```

## 第一次pull
```
docker pull django
0.19user 0.06system 9:16.60elapsed 0%CPU (0avgtext+0avgdata 26432maxresident)k
```


mirror log
```
time="2016-01-22T13:15:27Z" level=info msg="response completed" go.version=go1.5.2 http.request.host="docker-hub.mymirror.com:5555" http.request.id=884f518d-f69c-4d7d-8189-0afb70d1f351 http.request.method=GET http.request.remoteaddr="192.168.1.245:54369" http.request.uri="//v2/" http.request.useragent="docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64" http.response.duration="142.245µs" http.response.status=301 http.response.written=0 instance.id=3d1817be-d0b8-4c98-8560-fe88c5039957 version=v2.2.1
192.168.1.245 - - [22/Jan/2016:13:15:27 +0000] "GET //v2/ HTTP/1.1" 301 0 "" "docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64"
time="2016-01-22T13:15:27Z" level=info msg="response completed" go.version=go1.5.2 http.request.host="docker-hub.mymirror.com:5555" http.request.id=d38c459d-b0e8-4e40-9991-537999b206ca http.request.method=GET http.request.referer="http://docker-hub.mymirror.com:5555//v2/" http.request.remoteaddr="192.168.1.245:54370" http.request.uri="/v2/" http.request.useragent="docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64" http.response.contenttype="application/json; charset=utf-8" http.response.duration=4.311715ms http.response.status=200 http.response.written=2 instance.id=3d1817be-d0b8-4c98-8560-fe88c5039957 version=v2.2.1
192.168.1.245 - - [22/Jan/2016:13:15:27 +0000] "GET /v2/ HTTP/1.1" 200 2 "http://docker-hub.mymirror.com:5555//v2/" "docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64"
time="2016-01-22T13:15:27Z" level=error msg="response completed with error" err.code="MANIFEST_UNKNOWN" err.detail="unknown manifest name=library/django tag=latest" err.message="manifest unknown" go.version=go1.5.2 http.request.host="docker-hub.mymirror.com:5555" http.request.id=6c236f9c-53e9-4f4a-b61a-bf90e61c4c95 http.request.method=GET http.request.remoteaddr="192.168.1.245:54371" http.request.uri="/v2/library/django/manifests/latest" http.request.useragent="docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64" http.response.contenttype="application/json; charset=utf-8" http.response.duration=4.919044ms http.response.status=404 http.response.written=120 instance.id=3d1817be-d0b8-4c98-8560-fe88c5039957 vars.name="library/django" vars.reference=latest version=v2.2.1
192.168.1.245 - - [22/Jan/2016:13:15:27 +0000] "GET /v2/library/django/manifests/latest HTTP/1.1" 404 120 "" "docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64"
```

## rmi django再次pull
```
docker pull django
0.21user 0.05system 13:35.23elapsed 0%CPU (0avgtext+0avgdata 27152maxresident)k
```
时间还变长了

mirror log
```
time="2016-01-22T13:36:29Z" level=info msg="response completed" go.version=go1.5.2 http.request.host="docker-hub.mymirror.com:5555" http.request.id=5317fae0-9ead-4bc4-a016-3df313f7873a http.request.method=GET http.request.remoteaddr="192.168.1.245:54431" http.request.uri="//v2/" http.request.useragent="docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64" http.response.duration="126.687µs" http.response.status=301 http.response.written=0 instance.id=3d1817be-d0b8-4c98-8560-fe88c5039957 version=v2.2.1
192.168.1.245 - - [22/Jan/2016:13:36:29 +0000] "GET //v2/ HTTP/1.1" 301 0 "" "docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64"
time="2016-01-22T13:36:29Z" level=info msg="response completed" go.version=go1.5.2 http.request.host="docker-hub.mymirror.com:5555" http.request.id=86ed3aa8-a2ec-4b88-8a28-adcd4780ef78 http.request.method=GET http.request.referer="http://docker-hub.mymirror.com:5555//v2/" http.request.remoteaddr="192.168.1.245:54432" http.request.uri="/v2/" http.request.useragent="docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64" http.response.contenttype="application/json; charset=utf-8" http.response.duration=4.279031ms http.response.status=200 http.response.written=2 instance.id=3d1817be-d0b8-4c98-8560-fe88c5039957 version=v2.2.1
192.168.1.245 - - [22/Jan/2016:13:36:29 +0000] "GET /v2/ HTTP/1.1" 200 2 "http://docker-hub.mymirror.com:5555//v2/" "docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64"
time="2016-01-22T13:36:29Z" level=error msg="response completed with error" err.code="MANIFEST_UNKNOWN" err.detail="unknown manifest name=library/django tag=latest" err.message="manifest unknown" go.version=go1.5.2 http.request.host="docker-hub.mymirror.com:5555" http.request.id=2097bff1-98f8-443b-9e6d-9c4b93d0c87f http.request.method=GET http.request.remoteaddr="192.168.1.245:54433" http.request.uri="/v2/library/django/manifests/latest" http.request.useragent="docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64" http.response.contenttype="application/json; charset=utf-8" http.response.duration=4.300812ms http.response.status=404 http.response.written=120 instance.id=3d1817be-d0b8-4c98-8560-fe88c5039957 vars.name="library/django" vars.reference=latest version=v2.2.1
192.168.1.245 - - [22/Jan/2016:13:36:29 +0000] "GET /v2/library/django/manifests/latest HTTP/1.1" 404 120 "" "docker/1.9.1 go/go1.4.2 git-commit/a34a1d5 kernel/3.19.0-25-generic os/linux arch/amd64"

```
奇怪

# 进展5：调通删除镜像API
I sent the same request with @adolphlwq 's request, and got the same response
```
curl -v -X DELETE http://myregistry/v2/busybox/manifests/sha256:blablabla...

{"errors":[{"code":"UNSUPPORTED","message":"The operation is unsupported."}]}
```

## update
I got the solution to delete images

### enable delete
 set the environment variable `REGISTRY_STORAGE_DELETE_ENABLED = True`

### the API to delete image
1. get the manifest from registry
```
get v2/<repoName>/manifests/<tagName>
```
the `Docker-Content-Digest` is response.Header["Docker-Content-Digest"]
the `layerDigests` is response.body["fsLayers"]["blobSum"]

2. delete layerDigests
```
delete v2/<repoName>/blobs/<layerDigests>
```
3. delete Docker-Content-Digest
```
delete v2/<repoName>/manifests/<Docker-Content-Digest>
```
4. then pull the image from registry, the response is `invalid character '<' looking for beginning of value`

But when I get 'v2/repoName/tags/list', the tag which was been deleted is still exist.......

# 参考
[关于私有安全docker registry的实验](http://www.mworks92.com/2016/01/13/secure-registry-test/)
[搭建Docker私有仓库Registry-v2](http://blog.gesha.net/archives/613/)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

