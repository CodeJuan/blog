---
title: openstack性能测试器(4):rabbitmq-server、kombu、tcpdump
date: 2015-11-10 00:00:00
categories:
- code
tags: 
- openstack
- tcpdump
- rabbitmq
mathjax: true
description: 
---

# rabbitmq server

[http://www.rabbitmq.com/download.html](http://www.rabbitmq.com/download.html)

```sh
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server-3.5.6-1.noarch.rpm
sudo rpm -ivh rabbitmq-server-3.5.6-1.noarch.rpm 
```
提示缺少erlang

[http://www.erlang.org/download.html](http://www.erlang.org/download.html)


```sh
http://www.erlang.org/download/otp_src_18.1.tar.gz
tar -xvf otp_src_18.1.tar.gz
cd otp_src_18.1
./configure
sudo make
sudo make install

# 提示缺少fop和wxWidgets
sudo yum install fop
sudo yum install wxWidgets
```


```sh
sudo rpm -ivh --nodeps rabbitmq-server-3.5.6-1.noarch.rpm 
```

<!--more-->


说起来还是ubuntu安装简单，apt-get install rabbitmq-server就够了

# management plugin

```sh
# 启用management
rabbitmq-plugins enable rabbitmq_management
# 停止服务
sudo service rabbitmq-server stop
# 开启服务
sudo service rabbitmq-server start
```
然后访问`serverIP:15672`，就可以进入管理页面。此时只有guest帐号可用，然而rabbitmq-server的默认配置，guest帐号只能本机才能用，所以需要add_user

```sh
# 增加用户
sudo rabbitmqctl add_user test test

# 设置管理员权限
sudo rabbitmqctl set_user_tags test administrator
```

然后再访问`serverIP:15672`，用刚才创建的test账户登录，就能看到管理界面了。

![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/amqp/rabbitmq_management.png)

# kombu

> Kombu是一个为Python写的消息库，目标是为AMQ协议提供一个傻瓜式的高层接口，让Python中的消息传递变得尽可能简单，并且也提供一些常见消息传递问题的解决方案。

## kombu_cast
```python
import datetime
from kombu import Connection, Exchange, Queue

media_exchange = Exchange('media', 'direct', durable=True)
video_queue = Queue('video', exchange=media_exchange, routing_key='video')

def process_media(body, message):
    print body
    message.ack()

# connections
with Connection('amqp://test:test@192.168.161.56:5672//') as conn:

    # produce
    producer = conn.Producer(serializer='json')
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    producer.publish({'name': '/tmp/lolcat1.avi', 'size': now},
                      exchange=media_exchange, routing_key='video',
                      declare=[video_queue])

    # the declare above, makes sure the video queue is declared
    # so that the messages can be delivered.
    # It's a best practice in Kombu to have both publishers and
    # consumers declare the queue.  You can also declare the
    # queue manually using:
    #     video_queue(conn).declare()

    # consume
#    with conn.Consumer(video_queue, callbacks=[process_media]) as consumer:
#        # Process messages and handle events on all channels
#        while True:
#            conn.drain_events()
```

## kombu_consumer
```python
from kombu import Connection, Exchange, Queue


conn = Connection('amqp://test:test@192.168.161.56:5672//')
media_exchange = Exchange('media', 'direct', durable=True)

def process_media(body, message):
    print body
    message.ack()

# Consume from several queues on the same channel:
video_queue = Queue('video', exchange=media_exchange, key='video')
image_queue = Queue('image', exchange=media_exchange, key='image')

with conn.Consumer([video_queue, image_queue],
                         callbacks=[process_media]) as consumer:
    while True:
        conn.drain_events()
```

# tcpdump
抓包利器
```sh
sudo tcpdump tcp -i wlan1 -n dst port 5672  -w cast.cap
# tcp 表示抓tcp协议
# -i，表示抓哪个网卡。我这里算wlan1抓无线网卡1
# -w 表示写入到哪个文件
# dst port 5672表示只抓目的端口为5672的数据
```
然后用wireshark打开cast.cap
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/amqp/wireshark_cast.png)

顺便抓了下consumer的
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/amqp/wireshark_consume.png)

等有时间把每一包的意思都解释一下，今天就到这吧。
抓的包放在
[https://github.com/CodeJuan/test_rabbitmq](https://github.com/CodeJuan/test_rabbitmq)
可以对照代码看看

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

