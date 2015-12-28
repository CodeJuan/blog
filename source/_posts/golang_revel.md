---
title: 学golang(2):web框架
date: 2015-12-15 00:00:00
categories:
- code
tags: 
- golang
mathjax: true
description: 
---

# 背景

上回已经把revel下载好了，顺利搞出个hello world，

[http://blog.decbug.com/2015/11/28/golang/](http://blog.decbug.com/2015/11/28/golang/)



<!--more-->

# beego

接下来就要深入学习一下了，用revel弄一个restful api玩玩。然而由于revel写restful api太难了，于是改为使用比较出名的`beego`，国人出品的框架，不知效果如何。

老规矩，从hello world开始

## 安装
```sh
# 安装框架
go get github.com/astaxie/beego
# 安装工具
go get github.com/beego/bee
```

## 建立工程

```sh
cd $GOPATH/src
bee new test_beego
```

## 运行

```sh
cd test_beego
bee run
```

![](http://beego.me/docs/images/beerun.png)

# Restful API

## 安装mysql
```sh
yum -y install mariadb-server mariadb
systemctl start mariadb.service
systemctl enable mariadb.service
mysql_secure_installation
```

## 生成代码
```sh
bee generate scaffold post -fields="title:string,body:text"
```

## 在server后台运行bee run
在todo工程里运行
```go
bee run
```

## 添加路由
在main.go添加路由
```go
beego.Router("/post/", &controllers.PostController{}, "get:GetAll;post:Post")
beego.Router("/post/:id:int", &controllers.PostController{}, "get:GetOne;put:Put;delete:Delete")
```

## 注册数据库
提示没有default数据库，所以需要注册一下
```go
import (
	"github.com/astaxie/beego"
	"github.com/beego/samples/todo/controllers"

// 导入orm和mysql驱动
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
)

// 在init时注册
func init() {
orm.RegisterDriver("mysql", orm.DR_MySQL)

// 注意第三个参数连接字符串
orm.RegisterDataBase("default", "mysql", "root:@/test?charset=utf8")
}

func main() {
	beego.Router("/", &controllers.MainController{})
	beego.Router("/task/", &controllers.TaskController{}, "get:ListTasks;post:NewTask")
	beego.Router("/task/:id:int", &controllers.TaskController{}, "get:GetTask;put:UpdateTask")

    //添加post路由
	beego.Router("/post/", &controllers.PostController{}, "get:GetAll;post:Post")
	beego.Run()
}
```

## 改index
```html
<div class='container' ng-controller='PostCtrl'>
    <h1 class='charcoal rounded-box'>Blog</h1>

    <h2>Posts</h2>

    <ul class='grey rounded-box'>
        <li ng-repeat='t in posts'>
            <span class='checkbox'></span>{{t.Id}},{{t.Title}},{{t.Body}}
        </li>
    </ul>

    <form>
        <input type='text' class='rounded-box' placeholder='add new post here' ng-model='postText'>
        <button class='grey rounded-box' ng-click='addPost()'>New Post</button>
        <button class='grey rounded-box' ng-click='delPost()'>Delete Post</button>
        <button class='grey rounded-box' ng-click='updatePost()'>Update Post</button>
    </form>
</div>
```

## 改angularjs，增加PostCtrl
```js
function PostCtrl($scope, $http) {
  $scope.posts = [];

  var logError = function(data, status) {
    console.log('code '+status+': '+data);
  };

  var refresh = function() {
    return $http.get('/post/').
      success(function(data) { $scope.posts = data; }).
      error(logError);
  };

  $scope.addPost = function() {
    $http.post('/post/', {Title: $scope.postText}).
      error(logError).
      success(function() {
      });
  };

  $scope.delPost = function() {
      $http.delete('/post/'+$scope.postText).
        error(logError).
        success(function() {
        });
    };

    $scope.updatePost = function() {
        $http.put('/post/'+$scope.postText, {Body: "hahaha"}).
          error(logError).
          success(function() {
          });
      };

  refresh().then(function() { });
}
```

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

