---
title: plantuml
date: 2016-06-27 00:00:00
categories:
- code
tags: 
- diagram
mathjax: true
description: 
---

# 概念

PlantUML is a open-source tool that allows to quickly write :
- Sequence diagram,
- Usecase diagram,
- Class diagram,
- Activity diagram, (here is the new syntax),
- Component diagram,
- State diagram,
- Deployment diagram,
- Object diagram.
- wireframe graphical interface

<!--more-->

# 在hexo博客加上plantuml插件

## install
```
npm install hexo-tag-plantuml --save
```

## add to _config.yml
And add this plugin in _config.yml.
```
plugins:
 - hexo-tag-plantuml
```

## test

### add text to markdown file
```
{% plantuml %}
    Bob->Alice : hello
{% endplantuml %}
```

### test
```
hexo clean && hexo generate && hexo server
```

### 效果
{% plantuml %}
    Bob->Alice : hello
{% endplantuml %}

# 公司内网搭建plantuml服务
虽然[http://plantuml.com/](http://plantuml.com/)提供了online server，但是由于信息安全问题，不能直接把代码贴到那生成图片，所以需要自己在内网建一个


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

