---
title: 京东面试经历
date: 2016-04-10 00:00:00
categories:
- code
tags:
- career
- interview
mathjax: true
description: 
---

# 京东云面试记录
从通信行业转型到互联网，对云，分布式，高并发感兴趣，想搞底层。
于是在拉勾投了京东云。
面试分4轮，四位面试官分别是架构师、部门老大、大boss 、hr。
<!--more-->

总体感觉，面试官都很友善，我平时比较不善言语，这次在面试官的引导之下，交流比较顺畅。

# 架构师
先开始闲聊，平时看哪些技术网站啊，我说我是面向GitHub so 谷歌编程，然后聊了聊番茄手段，我说自己弄vps ，家里的路由。之后进入正题，问的问题比较偏原理。比如
1. linux的文件权限是如何实现的，
2. 一个hello world程序是如何运行起来的（我回答先把可执行文件加载到进程的代码段，之后执行，然后我讲了讲进程地址空间的一些事，感觉面试官对我的回答不太满意。经提醒，我才明白是要讲fork，我大概说了下，可惜忘了说写时复制。
3. 磁盘空间有空余，然而创建文件失败，是什么原因。我开始没答上来，然后就提示我是否知道，我说可以理解为索引。但还没答上来，后来架构师告诉我是inode space 不足。
4. 设计一个系统，restful 接口，｛num ，返回对应的斐波纳契数组。我说先实现功能，不能用递归，栈溢出就惨了。日志的话，我说可以玩elk（因为我刚在家玩了下），但面试官想听到日志轮转，我回答一般日志库都可以设置单个文件上限，达到这个值就会创建新文件。还有选型，我说最近用了gorilla mux 。经提醒，我还忘了异常保护。还忘了，可以把每次结果缓存到redis中，如果下次有同样的请求，就可以从redis中直接取值并返回，这样性能会高。

总体来说，我没答好。但好在我在提醒之下都能跟上思路，所以勉强过关了吧。

# 部门老大
先是简单聊了聊之前的项目经验，这个就不赘述了。之后是两个系统设计问题
1. 设计一个用户登录注册系统。我说先来一个最简单的，单表单应用。当用户多了，就水平扩展服务，把服务发现做好，因为服务是无状态的。如果数据库有压力，就分表。由于用户系统可能是读取多于写入，所以可以搞写库，多个读库。写库可以加主备。最好再加个用户登录行为分析，如果突然变了地理位置，可以警告。这个是我看到的常用套路，也不知道面试官是否满意。
2. 设计一个电梯系统。我说我做开发的一般喜欢先用一个简单粗暴的方法完成功能。我说记录每个电梯的运行状态，以及个楼层有坐电梯的请求，是到哪一层，可以放到请求列表。遍历列表，找到最近的电梯，然后调度过来。之后再统计电梯的运行数据，找出规律，比如上班高峰期，下班高峰期该如何调度。后来面试官问到如何让电梯的运行负载都均衡，我说暂时没有好的办法，我会给每个电梯设置一个角色，然后每天定时给电梯的角色互换。虽然某一天某个电梯会特别忙，但总体来看，负载会是均衡的。
偏理论的东西居多，我看过的书也发挥作用了。对了，最后还问我最近看了啥书，我说正在读第二遍性能之巅。

# 大boss
问的问题是偏团队管理，人员培养，以及产品落地的问题。
我说我觉得招聘很难，招到合适的人不容易，招人的标准已经降低了，只要脑子灵活，工作认真，就可以。因为一个人工作不负责，就需要周围的人给他填坑，严重影响团队。关于人员培养，我说我喜欢主动学习，独立解决问题的人，并且会分享的同学，这样团队的技术氛围好了，大家水平提高很快，刻意的培训其实价值不大。产品落地，需要抓住用户的痛点，我们的产品能给用户带来收益，大家双赢。后来问我最近工作中的困惑，我说最近对于项目进度的把控做的不好，组里小伙子干活比较慢，我前端不熟，对于这个进度不知是否合理，我不喜欢逼着小伙子们加班，说白了还是我的技术水平不够，还需要积累。如果我确定这个速度不合理，就可以硬下心肠给小伙子们压力了。

# hr
问工作经历，教育背景，离职原因，当前薪资，期望薪资等等

# offer
拿下。
然后之前一直都是通信行业，写C写C++，虽然号称全栈，会很多语言，做过很多领域。但和互联网产品的差异还是很大的，没有相关工作背景，被压价是不可避免的。还得继续努力啊。






----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

