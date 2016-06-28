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
架构图即代码
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

# 效果

{% plantuml %}
    :Main Admin: as Admin
    (Use the application) as (Use)

    User -> (Start)
    User --> (Use)

    Admin ---> (Use)

    note right of Admin : This is an example.

    note right of (Use)
      A note can also
      be on several lines
    end note

    note "This note is connected\nto several objects." as N2
    (Start) .. N2
    N2 .. (Use)
{% endplantuml %}

{% plantuml %}
    package "Some Group" {
      HTTP - [First Component]
      [Another Component]
    }

    node "Other Groups" {
      FTP - [Second Component]
      [First Component] --> FTP
    }

    cloud {
      [Example 1]
    }


    database "MySql" {
      folder "This is my folder" {
        [Folder 3]
      }
      frame "Foo" {
        [Frame 4]
      }
    }


    [Another Component] --> [Example 1]
    [Example 1] --> [Folder 3]
    [Folder 3] --> [Frame 4]
{% endplantuml %}

{% plantuml %}
    (*) --> "Initialization"

    if "Some Test" then
      -->[true] "Some Activity"
      --> "Another activity"
      -right-> (*)
    else
      ->[false] "Something else"
      -->[Ending process] (*)
    endif
{% endplantuml %}

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
虽然[http://plantuml.com/](http://plantuml.com/)提供了online server，但是由于信息安全问题，不能直接把代码贴到那生成图片，所以需要自己在内网建一个.

## 选型
其实也没啥选的，由于linux机器都被回收，只有自己用的windows办公机，所以只能用windows了。
前端用bootstrap+angularjs，好吧，我承认我是前端小白，其实我就只会这哥俩
后端就用go的gin框架，原因就是之前用gin写了个玩具，基本可以复用

## 准备工作
- plantuml需要jdk
- 下载plantuml.jar，进入[http://plantuml.com/download.html](http://plantuml.com/download.html)，下载last version，[http://sourceforge.net/projects/plantuml/files/plantuml.jar/download](http://sourceforge.net/projects/plantuml/files/plantuml.jar/download)
- 由于plantuml在生成图片时会用到graphviz，也需要一并下载并安装[http://www.graphviz.org/Download_windows.php](http://www.graphviz.org/Download_windows.php)
- plantuml会调用graphviz的dot.exe，所以需要增加环境变量**GRAPHVIZ_DOT**，值就是dot.exe的全路径
- `java -jar plantuml.jar -testdot`，如果返回OK，那么说明安装成功

## 实现过程
### 启动plantuml
```
java -jar plantuml.jar
```
会监控当前目录，如果有`.txt等文件`的变更，就会生成同名的png

### 时序图

{% plantuml %}
    前端->后端 : 发送plantuml的代码
    后端->监控目录 : 生成以uuid命名的txt文件，保存前端传来的代码到此文件
    监控目录->plantuml : plantuml检测到新增文件，自动生成同名png
    plantuml --> 后端 : 后端检测到png的存在，获取png的文件名
    后端 --> 前端 : 返回生成png的url，显示到页面上
{% endplantuml %}

期间有个比较蛋疼的事，由于golang的string是UTF8，保存到文件也是UTF8，plantuml不识别，总提示语法错误。解决方法:
- 参考[http://mengqi.info/html/2015/201507071345-using-golang-to-convert-text-between-gbk-and-utf-8.html](http://mengqi.info/html/2015/201507071345-using-golang-to-convert-text-between-gbk-and-utf-8.html)
- 将string转换成gbk的bytes，然后写入到文件

## 炫耀
花了3个小时搞定，就推荐给周围同事，得到一致好评，大家都可以抛弃visio等图形化工具了。
通过markdown实现了**设计文档即代码**
那么通过plantuml实现了**架构图即代码**
文本化，可以版本管理


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

