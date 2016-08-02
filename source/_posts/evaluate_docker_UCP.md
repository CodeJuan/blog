---
title: 体验docker UCP
date: 2016-08-02 00:00:00
categories:
- code
tags: 
- docker
- UCP
mathjax: true
description: 
---
# 背景
docker官方也有私有云版本
<!--more-->

# install

## docker engine
感谢Daoloud提供的一键式安装
```
curl -sSL https://get.daocloud.io/docker | sh
```

## ucp
```
export DOCKER_TLS_VERIFY="0"
export DOCKER_HOST="tcp://104.236.158.191:2376"
export DOCKER_CERT_PATH=""
export DOCKER_MACHINE_NAME="node1"

docker run --rm -it \
> -v /var/run/docker.sock:/var/run/docker.sock \
> --name ucp docker/ucp install -i \
> --swarm-port 3376 --host-address 104.236.158.191
```

提示
```
Could not read CA certificate "/root/.docker/ca.pem": open /root/.docker/ca.pem: no such file or directory
```
看来需要生成一个
```
openssl req -out ca.pem -new -x509
# aaaa
# 104.236.158.191
```

再次运行run
```

Unable to find image 'docker/ucp:latest' locally
latest: Pulling from docker/ucp
e110a4a17941: Pull complete
a1c3e1c9e147: Pull complete
bca4748868da: Pull complete
Digest: sha256:46154615e2429a9a8f3d019c414f69cd47f9f7dd5d5c35f54016c01fad1d99ef
Status: Downloaded newer image for docker/ucp:latest
INFO[0000] Verifying your system is compatible with UCP
INFO[0000] Your engine version 1.12.0, build 8eab29e (4.4.0-31-generic) is compatible
WARN[0000] Your system does not have enough memory.  UCP suggests a minimum of 2.00 GB, but you only have 0.97 GB.  You may have unexpected errors.
Please choose your initial UCP admin password:
Confirm your initial password:
INFO[0024] Pulling required images... (this may take a while)
WARN[0080] None of the hostnames we'll be using in the UCP certificates [ubuntu-1gb-sfo1-01 127.0.0.1 172.17.0.1 104.236.158.191] contain a domain component.  Your generated certs may fail TLS validation unless you only use one of these shortnames or IPs to connect.  You can use the --san flag to add more aliases

You may enter additional aliases (SANs) now or press enter to proceed with the above list.
Additional aliases: abc
INFO[0192] Installing UCP with host address 104.236.158.191 - If this is incorrect, please specify an alternative address with the '--host-address' flag
INFO[0000] Checking that required ports are available and accessible
INFO[0005] Generating UCP Cluster Root CA
INFO[0047] Generating UCP Client Root CA
INFO[0060] Deploying UCP Containers
INFO[0113] New configuration established.  Signalling the daemon to load it...
INFO[0114] Successfully delivered signal to daemon
INFO[0114] UCP instance ID: DKVU:ULUA:C3SO:O36W:4WUE:OM4Z:5V4X:IA46:ZLS5:L2KE:KE5J:O56D
INFO[0114] UCP Server SSL: SHA-256 Fingerprint=71:C8:1D:AB:CA:EE:E7:91:07:D6:23:83:F2:A7:67:2A:F8:DE:88:43:5C:D4:2E:76:9D:BA:B9:39:B4:11:64:86
INFO[0114] Login as "admin"/(your admin password) to UCP at https://104.236.158.191:443
```

-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
