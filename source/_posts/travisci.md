---
title: 尝试travis CI
date: 2015-12-23 00:00:00
categories:
- code
tags: 
- travisCI
mathjax: true
description: 
---

# 前言

看到别的开源软件的ReadMe上总一些build success的图标，感觉很帅，也想尝试一下。

# 步骤

- 首先，用github帐号登录[https://travis-ci.org/](https://travis-ci.org/)
- 把某个工程打开，我选的工程是[https://github.com/CodeJuan/python_convert_json2lua](https://github.com/CodeJuan/python_convert_json2lua)
- 创建'.travis.yml'，根据[https://docs.travis-ci.com/user/languages/python](https://docs.travis-ci.com/user/languages/python)填写一个python的yml
```
language: python
python:
  - "2.7"
# command to install dependencies
install: "pip install simplejson"
# command to run tests
script: python go.py
```
- 点击工程的status图标，拷贝链接
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/travisci/travis_status.png)

- 在readme加上
```
[![Build Status](https://travis-ci.org/CodeJuan/python_convert_json2lua.svg?branch=master)](https://travis-ci.org/CodeJuan/python_convert_json2lua)
```

- 效果如图

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/travisci/demo.png)

# 感想
- 有提交就触发，很方便
- log很完整
- 可以自由配置环境
- 省去自己搭建jenkins的步骤






----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

