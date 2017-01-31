---
title: conver socks5 to http proxy
date: 2017-01-10 00:00:00
categories:
- code
tags: 
- proxy
mathjax: true
description: 
---

go get, but connect to golang.org timeout!!!



<!--more-->

# polipo

```
apt-get install polipo
```

## /etc/polipo/config
```
logSyslog = true
logFile = /var/log/polipo/polipo.log


proxyAddress = "10.164.28.139"
proxyPort = 8118
socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5
allowedClients = []

```

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


