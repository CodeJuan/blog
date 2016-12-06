---
title: sudoers分析
date: 2016-12-05 00:00:00
categories:
- code
tags: 
- sudoers
mathjax: true
description: 
---

对于敏感命令，需要限制其使用范围，防止被攻击提权。至于如何提权，一搜就一大片例子，故不赘述。
为了解决此问题，需要找出系统用到了sudo的地方，然后把命令的具体参数都记录下来，写入到sudoers，避免使用其他参数。

<!--more-->

# /etc/sudoers
- 需要用visudo打开，如果有语法错误，那么在保存时会有warning
- 行首是"%"的，表示是group，这一个group的全部用户都适用于这个sudo的定义；行首是用户名的，表示是用户。
- 注意特殊字符需要转义`The following characters must be escaped with a backslash (‘\’) when used as part of a word (e.g. a user name or host name): ‘!’, ‘=’, ‘:’, ‘,’, ‘(’, ‘)’, ‘\’.`

# 自动化
以前的做法，看代码，找出全部用到sudo的脚本，代码等等。汇总之后写入到sudoers，耗时费力，大家苦不堪言，却没有想过改变。这次轮到我来干这类事，我觉得是在浪费生命，于是相处了偷懒的办法
1. 打开sudo的log，方法：在sudoers加上一行`Defaults          logfile=/var/log/sudo.log`
2. 之后运行我们的系统，一段时间后，基本上全部命令都执行到了，log里保存了全部的sudo记录
3. 分析过滤提取`/var/log/sudo.log`，就能找出我们系统用到的sudo相关命令
4. 自动汇总，写入到/etc/sudoers

以前需要N人天才能做完的是，我花了1天写代码，之后5分钟就搞定。节省了N多人力物力，可以把时间投入到更有技术含量的工作中去。

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


