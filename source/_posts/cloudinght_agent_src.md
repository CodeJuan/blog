---
title: CloudInsightAgent源码分析
date: 2017-04-01 00:00:00
categories:
- code
tags: 
- APM
- monitoring
mathjax: true
description: 
---

之前模仿sysdig做了个容器性能监控平台，[链接在此](http://blog.decbug.com/2016/12/06/sysdig_knockoff/)，虽然有一些基础的功能，但是还不完善，

恰好看到cloud insight开源了他的agent，看过之后，和我的思路差不多，就简单记录一下，避免遗忘。

<!--more-->

# 代码
[https://github.com/cloudinsight/cloudinsight-agent](https://github.com/cloudinsight/cloudinsight-agent)

据说之前是python，后来切换到go

# 整体结构

```sh
├── agent
├── collector
│   ├── conf.d          # plugins的配置文件，比如MySQL的连接串
│   └── plugins         # plugin的代码，有docker，MySQL等
├── common              # 公共包
├── forwarder           # 发到cloud insight服务器
├── statsd
└── vendor              # 三方包
```

# 整体流程

init的时候会加载cloudinsight-agent/collector/plugins的插件

```
+------------------------------------------+
| main                                     |
|                                          |
|                                          |
|                                          |
|      +-------------------+               |
|      |config.NewConfig   |               |
|      |                   |               |
|      +-------------------+               |
|                                          |
|                                          |
|      +-------------------+               |
|      |startAgent         |               |
|      |                   |               |
|      +-------------------+               |
|                                          |
|                                          |
|      +-------------------+               |
|      |startForwarder     |               |
|      |                   |               |
|      +-------------------+               |
|                                          |
|                                          |
|      +-------------------+               |
|      |startStatsd        |               |
|      |                   |               |
|      +-------------------+               |
|                                          |
|                                          |
|                                          |
|                                          |
+------------------------------------------+

```

# agent

collector

## plugins


## config

## 以docker为例

Check接口，调用docker daemon的rest api采集



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


