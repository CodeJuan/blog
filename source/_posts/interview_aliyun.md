---
title: 阿里面试经历
date: 2016-04-11 00:00:00
categories:
- code
tags: 
- career
- interview
mathjax: true
description: 
---

# 背景
之前一直都在通信行业撸代码，做的都是C/C++，感觉提升不大，所以打算往互联网转型，看看百万千万用户的产品是如何做出来的。
于是在拉勾上投了阿里云。

<!--more-->

# 阿里云面试记录
三轮（也许可以算四轮）技术面，一轮boss面，一轮hr，据说还有一轮hr的大boss价值观面试

# 一轮
感觉是一位管理者，可能脱离技术一段时间，问的问题都是根据简历来的。
- 先是问项目经验，期间问到几次，为啥要重复造轮子。
- docker run的原理，流程
- dockerfile，docker build原理
- C++虚函数，引用指针，
- 手写HashMap
- AngularJS绑定的原理
- 并发，我说锁啊，然后忽悠一大堆。后问如何提高性能，我说如果业务允许，应该让每个执行实例独立，不要共享资源，减少竞争
- 弹性伸缩
- 一致性

# 二轮
好像是一位P8，曾在外面看过这个名字，title是高级专家
- 聊我之前的一个项目，关于我做的一个数据挖掘工具的消息推送模块的优化讨论，消息队列，锁
- STL remove和erase的区别
- vector构造析构
- HIVE HBASE
- 我说给测试团队写过自动化测试框架，质疑说为啥需要自己写。我说业务啊，windows的啊，环境啊等等
- 基于一个`随机读，追加写的文件系统`，做一个KV存储系统，有增删改查的功能。这个比较好玩。
1. 我说如果不考虑性能的话，我第一版会采用，每个K就对应一个文件，把V写到这个文件里，先实现功能，交付出去，接口调通，之后再进行优化。面试官说，快速完成的想法不错，那么后面该如何优化呢
2. 第二版，增加索引，保存K，V的长度，V到数据文件，保存K，该K对应V在数据文件中的偏移到索引文件，面试官说如果有改的请求，就需要重写整个索引文件，性能会差。我说，是的，接下来我会继续优化。
3. 第三版，如果内存够大，或者数据不会太多，那么把索引保存到内存中，省去重建索引文件的性能损耗。面试官说，内存不会太大。
4. 第四版，针对K进行hash，每个hash对应一个文件夹，文件夹里是索引文件和数据文件，通过hash可缩短搜索路径。
5. 第五版，可以把索引放到redis中，面试官说，不能用redis。我就说定时把索引文件快照到磁盘，面试官说不行，掉电就还是会丢数据。
6. 数据文件中保存K L V，只有数据文件写入成功，才更新内存中的索引。即使掉电了，也能从数据文件中重建索引。
7. 增加缓存，把热点索引保存在内存中，如内存未命中，则根据用户传入的K，从数据文件中恢复索引到内存中，冷索引则从内存中剔除。
- go中map中 map[a].b = 1能生效吗，我说我不记得了，但如果你这么问，那么肯定是不能，因为可能是值，不是引用，指向的不是内存。

面完之后，让我等消息

# 三轮
之前两轮面试说我技术不错，能力不错，经验不错，对技术也有热情，可惜工作经验不匹配，所以把我推荐到别的组，于是需要再做一轮技术面试。
- PHP，我说我用过wordpress和phpwind，且做一个小的图片生成系统
- python，django和flask
- 如何监控很多台机器，我说我看过小米open falcon的实现，在每台机器上装个agent
- 如何控制很多台机器，我说可以参考ansible，添加到ssh的可信里，然后通过ssh来控制
- spring的原理
- linux熟不熟，问了几个命令
- 问我会哪些脚本语言，都用来做过啥。我说shell powershell python
- 给出一个场景，分析并解决。场景好像很简单，我一下就解决了。我在此基础上发挥了一下，提出要总结，下次遇到类似问题的时候就可以很快查到。还可以给用户提供一键式解决办法，这样可以一劳永逸。
- 因为之前两轮技术面都太惨烈，所以这一轮似乎没问太多复杂的问题。这一轮基本上没啥问题了，后面就是BOSS和HR了
- 后来又面了一次，主要是谈了一些产品方面的问题，还有我的技术爱好

# 部门BOSS
- 主要是问当前工作，手下带了几个兄弟，我说之前是带100多，但我只需要管技术，不用管理。今年开始独立带人，组建团队。感觉很痛苦，要招聘，要带徒弟，要规划产品，还要写代码。
- 在产品开发运营过程中的难题，我说最难的就是如何抓住用户的痛点，用平滑的方式解决痛点，不能让用户抵触。
- 以及问了我对阿里云某些产品的看法，然后我就说了下对于学习aws的一些心得，顺便吐槽了阿里云。
- 再就是介绍他的团队以及产品，还有未来的规划。说了优点也说了缺点，而不像以前接触过的一些光吹牛的面试官。

# HR
问工作经历，之前每次跳槽的原因。为何想来阿里之类的。

# HR的BOSS
有点像背景调查，问是否统招啊之类的

# offer
拿下



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

