---
title: tornado 
date: 2015-09-13 00:00:00
categories:
- code
tags: 
- python
- tornado
mathjax: true
description: 
---

## 背景
实现白名单，只允许可信用户访问我的服务
考虑采用iptables或者nginx

如果用nginx，那么可以建立一个`allow_ip.conf`，然后把这个配置文件include到nginx的配置中
用户可以主动添加他们的IP到我这，打算玩玩tornado，用户输入他的IP，然后存入到我的文件中，最后定时合并到`allow_ip.conf`

<!--more-->

## 分析一下需求
- 一个input，一个button，点button就把input的内容追加到某个文件中，暂时不考虑input是否合法
- tornado 写一个handler
- 定时把最新的IP合并到allow_ip.con

## 安装
```sh
wget https://pypi.python.org/packages/source/t/tornado/tornado-4.2.1.tar.gz
tar zxvf tornado-4.2.1.tar.gz
cd tornado-4.2.1
python setup.py build
sudo python setup.py install
```

## 开搞
### demos
先试用一下`tornado`源码里的demos，找到最简单的helloworld，运行
```sh
python helloworld.py
```
在另一台机器上访问，总是载入不了网页。于是开始排查
- 本机上查看端口`netstat -tulpn | grep :8888`
- 在本机上curl，可以打开
- 猜测可能是防火墙的问题，`iptables -I INPUT -p TCP --dport 8888 -j ACCEPT`
再次访问，就OK啦

### 一个输入页面

#### login.html
```html
<html>
   <head>
      <title>{{ title }}</title>
   </head>
   <body>
     <form action="{{ request.path }}" method="post">
       <div>{{ _("你的IP") }} <input type="text" name="username"/></div>
       <!--<div>{{ _("Password") }} <input type="password" name="password"/></div> -->
       <div><input type="submit" value="{{ _("输入") }}"/></div>
       {% module xsrf_form_html() %}
     </form>
   </body>
 </html>
```

#### test.py
```python
import tornado.ioloop
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        #self.write("Hello, world")
        items = ["Item 1", "Item 2", "Item 3"]
        self.render("temp.html", title="My title", items=items)

# LoginHandler
class LoginHandler(tornado.web.RequestHandler):
    def get(self):
        # template from login.html
        self.render("login.html", title="login")
    def post(self):
        usr=self.get_argument("username", "") 
        #pwd=self.get_argument("password", "") 
        self.write(usr)
        #self.write(pwd)

application = tornado.web.Application([
    (r"/", MainHandler),

    # login时通过LoginHandler处理
    (r"/login", LoginHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.current().start()
```
#### 运行效果
![输入](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/tornado/Screenshot%20from%202015-09-14%2021:59:01.png)


![结果](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/tornado/Screenshot%20from%202015-09-14%2022:04:20.png)

### 保存用户的IP到白名单
先写入到一个临时文件，然后定时同步到nginx的配置里include白名单文件allow_ips.conf

#### 写入文件


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

