---
title: 初学golang
date: 2015-11-28 00:00:00
categories:
- code
tags: 
- golang
mathjax: true
description: 
---

# 背景

最近经常听到有同事在安利golang，颇为心动。恰巧又看到这篇文章[How We Moved Our API From Ruby to Go and Saved Our Sanity](http://blog.parse.com/learn/how-we-moved-our-api-from-ruby-to-go-and-saved-our-sanity/)，于是便忍不住了，打算试试。
毕竟是谷歌亲儿子，想必会有一番不错的表现。

<!--more-->

----------------------------

# 安装go
原本以为需要用源码来安装，上网查了一下，得知centos7可以直接`yum`安装，so easy。

## 还是通过二进制安装一下吧
yum安装的版本太低了，还是得自己安装1.5
```
wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.5.1.linux-amd64.tar.gz
echo 'export GOROOT="/usr/local/go"' >> ~/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.bashrc
echo 'export GOPATH="$HOME/code/go_code"' >> ~/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.bashrc
. ~/.bashrc
```

----------------------------

# golang plugin for idea
作为idea的用户，自然首选的IDE还是idea，所以得装一个golang的插件[https://github.com/go-lang-plugin-org/go-lang-idea-plugin](https://github.com/go-lang-plugin-org/go-lang-idea-plugin)
然后参考[https://www.jetbrains.com/idea/help/managing-enterprise-plugin-repositories.html](https://www.jetbrains.com/idea/help/managing-enterprise-plugin-repositories.html)进行安装即可
1. file-settings-plugins
2. Browse repo
3. Manage repo
4. Custom plugin
5. add url `https://plugins.jetbrains.com/plugins/nightly/5047`，这个nightly不错，我先试试
6. 一路ok/close
7. 然后在file-settings-plugins输入go,选择安装。

接下来就创建一个新的go工程，SDK就选择之前解压出来的`/usr/local/go`


----------------------------

# hello world

创建一个hello.go，内容如下
```go
package main
import "fmt"
func main() {
     fmt.Println("Hello, World!")
}
```

然后go run hello.go
也可以打包成一个可执行文件，go build hello.go

# simple http server

```go
package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}

```

----------------------------

# 传说中的routine
大概说一下我的理解，由于线程的切换成本较高，上下文，栈恢复之类的，所以需要考虑其他办法。
多个routine，可以粗略的理解为共用一个线程，其CPU的抢占都是由routine自身来决定。由于只有一个线程，所以免去了切换的开销。
感觉还是怪怪的，就先简单理解为routine的开销较小，可以有更高的并发数吧。

----------------------------

# web frame
打算试试revel
```sh
go get -u github.com/revel/cmd/revel
```
提示`package golang.org/x/net/websocket: unrecognized import path "golang.org/x/net/websocket"`

我只在我的办公机上装了SS，其他的几台挖掘机都没装，所以下不了。。
看来我真的得把我的openwrt的路由弄好，用来全局Fxxk了。
心情不好，今天就玩到这吧，擦擦擦！

> 把内啥路由搞好了，HOHO，链接[http://blog.decbug.com/2015/12/03/openwrt/](http://blog.decbug.com/2015/12/03/openwrt/)。搞好了三台，网件WNDR4300、华为HG225D和DB120，搞挂了一个迅捷171。继续开搞吧

```sh
# get revel framework
go get github.com/revel/revel

# get 'revel' command
go get github.com/revel/cmd/revel

# get samples and run chat app
go get github.com/revel/samples
vi src/github.com/codejuan/my-app/conf/app.conf #8080
sudo /sbin/iptables -I INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
revel run github.com/revel/samples/chat
```




----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

