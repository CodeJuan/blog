---
title: hexo通过travis CI自动发布
date: 2016-05-31 00:00:00
categories:
- code
tags: 
- blog
- travis
mathjax: true
description: 
---

# 背景

github pages支持jekyll自动发布，只要修改了post的md，就会自动生成gh-pages。但不支持hexo，所以需要通过第三方的系统来执行hexo generate并把生成的静态页面push到gh-pages。
之前用过Travis ci，感觉不错，打算继续用它。

<!--more-->

1. 通过github帐号登录travis ci，把博客的repo加入到左边的My Repositories
2. 在博客repo编写.travis.yml，用于编排
3. 在github-setting-personal token-生成一个只能访问public repo的token
4. 在travis ci的Repositories添加环境变量DEPLOY_REPO， https://{token}@github.com/{你的用户名}/{你的repo名}.git
5. `git clone --depth 1 --branch gh-pages --single-branch $DEPLOY_REPO . || (git init && git remote add -t gh-pages origin $DEPLOY_REPO)`


PS: travis ci的日志放在aws s3上，所以要先番茄才能看到日志哦

# 参考
[http://www.jianshu.com/p/e22c13d85659](http://www.jianshu.com/p/e22c13d85659)


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

