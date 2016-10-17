---
title: 调用链技术分析
date: 2016-10-14 00:00:00
categories:
- code
tags: 
- APM
mathjax: true
description: 
---

![分布式调用](https://cloud.githubusercontent.com/assets/5423628/19371598/083f6f56-91e7-11e6-8964-63f4780885f1.png)

都源于google的dapper，常见的有三种方式

名称|概要|优点|缺点
---|---|---|---
自己打日志|请求进入时生成ID，每次跨节点调用都带上ID，日志也打上ID|自己实现（这个算不算优点）|麻烦
用开源库，如zipkin|原理都差不多，都是ID spanID parentID|简单，client和server都有例子|需要集成
改分布式框架，如鹰眼，京东改dubbo|不用侵入业务代码，在框架里做好埋点和日志|自己实现|稍微麻烦，需要自己改框架
运行环境注入|例如[newrelic](https://newrelic.com/)，[pinpoint](https://github.com/naver/pinpoint)，改JVM运行时bytecode|非侵入|性能损耗比较大

<!--more-->

# dapper论文
![image](https://cloud.githubusercontent.com/assets/5423628/19371479/05ebe2b2-91e6-11e6-9a89-9827415d9464.png)

![image](https://cloud.githubusercontent.com/assets/5423628/19371503/288995bc-91e6-11e6-9e68-8b198725a8a8.png)

![image](https://cloud.githubusercontent.com/assets/5423628/19371519/3f05e1e2-91e6-11e6-84cf-77c2f095ff74.png)

# zipkin
在公司体验了一下，流程和[https://yq.aliyun.com/articles/60165?spm=5176.100244.teamconlist.33.wxgYuD](https://yq.aliyun.com/articles/60165?spm=5176.100244.teamconlist.33.wxgYuD)
差不多

# 改造分布式框架
在发远程调用，收到远程调用的时候，框架自身记录下来
实现起来想必不容易，但收益很大

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


