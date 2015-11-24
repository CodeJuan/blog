---
title: virtualbox共享文件夹
date: 2015-11-24 00:00:00
categories:
- code
tags: 
- virtualbox
- share
mathjax: true
description: 
---

# 背景

我的日常系统是ubuntu，但由于特殊国情，很多事情在只能在windows上面才能做。
所以呢，只好用virtualbox弄了xp，专门用来做见不得人之事，比如用迅雷下载某些资源。
下载完成之后，得把东西拷回到ubuntu吧，这个时候就可以通过共享文件夹的方式来做。

<!--more-->

--------------------------------------------------------------

# 步骤

## 设置共享文件夹
点击virtualbox的菜单，选择devices-shared folders settings
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/virtualbox/1.png)

## 选中host上的一个文件夹
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/virtualbox/2.png)

## 安装virtualbox插件
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/virtualbox/3.png)
会提示没有插件什么什么的，一路点next就行
装完之后需要重启

## 映射host共享文件夹
```sh
net use x: \\vboxsvr\share
```
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/virtualbox/4.png)

然后在网络驱动器就会出现一个X盘，之后就能通过它来传文件了。


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

