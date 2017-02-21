---
title: lxd,lxc,nova-lxd
date: 2017-02-11 00:00:00
categories:
- code
tags: 
- container
- openstack
- lxc
mathjax: true
description: 
---

分析一下lxc, lxd, nova-lxd的关系以及源码

- [nova-lxd](https://github.com/openstack/nova-lxd),An OpenStack Compute driver for LXD
- [lxd](https://github.com/lxc/lxd)，lxd daemon和lxd client
- [lxc](https://github.com/lxc/lxc)，liblxc和lxc-tools

# 关系
``` sh
                              +---------------+
+----------+                  |               |
| lxc      |                  |   nova-lxd    |
| lxd-client+---+      +------+               |
+----------+    |      |      |               |
                |      |      +---------------+
                |      |
                |      |
             +--v------v---------+
             |     lxd           |
             |                   |
             |Daemon based on    |
             |liblxc offering    |
             |a REST API         |                  +-------------------------+
             |to manage containers                  |                         |
             +--------+----------+                  |   lxc/lxc               |
                      |                             |   tools to              |
                      |                             |   manage containers     |
                      |                             |                         |
             +--------v----------+                  |                         |
             |                   |                  |                         |
             |      go-lxc./v2   |                  +--------+----------------+
             |                   |                           |
             |                   |                           |
             |                   |                           |
             +----------+--------+                           |
                        |                                    |
                        |                                    |
                        |                                    |
                        |                                    |
              +---------v------------------------------------v---------+
              |                                                        |
              |                                                        |
              |                    liblxc.so                           |
              |                                                        |
              +-------------------------+------------------------------+
                                        |
                                        |
                                        |
              +-------------------------v------------------------------+
              |                                                        |
              |                                                        |
              |                kernel                                  |
              |                namespace, cgroups                      |
              |                                                        |
              |                                                        |
              |                                                        |
              +--------------------------------------------------------+

```


<!--more-->

# lxd分析
包含两部分
- lxd, 类似docker daemon，对外提供restful api
- lxc, lxd daemon的客户端

lxd daemon通过`go lxc v2`来调用`liblxc.so`，其中用到了cgo以及lxc的头文件，所以要先编译liblxc

# lxc-tools
[lxc-tools]((https://github.com/lxc/lxc/tree/master/src/lxc/tools))只是[lxc/lxc](https://github.com/lxc/lxc)的一部分，提供可执行文件用于管理lxc容器。
lxc/lxc最重要的部分还是liblxc.so

# nova-lxd
nova-compute的一个driver，类似以前看过的nova-docker
- 相比docker，lxc的行为上更像虚拟机，所以更适合用来和openstack一起玩[http://blog.decbug.com/2017/02/11/lxc_docker/](http://blog.decbug.com/2017/02/11/lxc_docker/)
- 北向: 提供spawn, plug-network等接口给nova-compute
- 南向: 调用lxd daemon管理容器

## 基本功能及流程
### 创容器
```py
# Check to see if LXD already has a copy of the image. If not,
# fetch it.
_sync_glance_image_to_lxd

# Plug in the network
plug_vifs(instance, network_info)

# Create the profile(including devices, flavor, )
container = self.client.containers.create(
                container_config, wait=True)

# start
container.start(wait=True)

```


### 镜像

```py
image = IMAGE_API.get(context, image_ref)
IMAGE_API.download(context, image_ref, dest_path=image_file)

# generate metadata.yaml
            metadata = {
                'architecture': image.get(
                    'hw_architecture', obj_fields.Architecture.from_host()),
                'creation_date': int(os.stat(image_file).st_ctime)}
            metadata_yaml = json.dumps(
                metadata, sort_keys=True, indent=4,
                separators=(',', ': '),

# add metadata.yaml to tar.gz
            tarball = tarfile.open(manifest_file, "w:gz")
            tarinfo = tarfile.TarInfo(name='metadata.yaml')
            tarinfo.size = len(metadata_yaml)
            tarball.addfile(tarinfo, io.BytesIO(metadata_yaml))
            tarball.close()

# upload tar.gz to local lxd image registry
image = client.images.create(
                        image.read(), metadata=manifest.read(),
                        wait=True)
            image.add_alias(image_ref, '')
```

### 网络
[https://github.com/openstack/nova-lxd/blob/master/nova/virt/lxd/vif.py](https://github.com/openstack/nova-lxd/blob/master/nova/virt/lxd/vif.py)
- plug
- unplug


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


