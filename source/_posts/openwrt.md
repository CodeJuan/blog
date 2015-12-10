---
title: openwrt内啥内啥
date: 2015-12-03 00:00:00
categories:
- code
tags: 
- openwrt
mathjax: true
description: 
---


# 起因
最近撸golang，下三方包太痛苦，挂代理太郁闷，所以。。。。。搞个openwrt全局内啥。
把家里的老路由FWR171翻出来刷openwrt，但是还没搞定（具体折腾经历在本文第二段）。只好在淘宝买了个华为HG225D，59+12的邮费，半个小时就搞定啦，太方便了，所以简单记录一下。

<!--more-->

# HG225D
购于淘宝，最好是买升级到64M内存的版本，速度会快一些。

## 步骤

### 刷机
- 固件`openwrt-ramips-rt305x-hg255d-aria2-shadowsocks`，[http://pan.baidu.com/s/1kTst0gv#path=%252Fhg255d](http://pan.baidu.com/s/1kTst0gv#path=%252Fhg255d)
- 按住reset不放，再给路由通电，直到power灯开始一闪一闪
- 进入[192.168.1.1](192.168.1.1)，此时看到的是刷机界面，选择刚才的固件`openwrt-ramips-rt305x-hg255d-aria2-shadowsocks`，耐心等待即可

### 内啥内啥的配置

需要配置ss、Redsocks和chinadns，其中chinadns的作用就是，只有被墙了网站才会走ss。
- 进入服务-ss，填入你的服务器信息
- 进入服务-Redsocks，勾选启用Redsocks，在透明代理区域中，填写正确的代理服务器、代理服务器端口、代理服务器类型，加密方式以及密码。其中代理服务器类型选择`ss代理`
- 还是在Redsocks，UDP转发区域，也填入和透明代理一样的信息
- 进入网络-DHCP/DNS，在常规设置的DNS转发处填写`127.0.0.1#1153`
- 还是DHCP/DNS，点击HOSTS和解析文件，勾选`忽略解析文件`

再应用并保存所用配置，重启路由，就可以嘿嘿嘿了！


# FAST-FWR171失败的经历，可以不用看
### 原厂固件
FWR171到703N
[http://pan.baidu.com/wap/share/home?uk=3457154703&third=0](http://pan.baidu.com/wap/share/home?uk=3457154703&third=0)

### openwrt
http://downloads.openwrt.org/snapshots/trunk/ar71xx/generic/openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-sysupgrade.bin
http://downloads.openwrt.org/snapshots/trunk/ar71xx/generic/openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin

先刷factory

然后ssh root@192.168.1.1

passwd改密码

### 开启wifi

/etc/config/wireless  radio0的disable一行需要删掉或注释掉
顺便加个密
```
config wifi-iface
        option device   radio0
        option network  lan
        option mode     ap
        option ssid     OpenWrt
        option encryption 'psk2'
        option key 'psk2'  

config wifi-iface
        option device   radio0
        option network  lan
        option mode     ap
        option ssid     OpenWrt
        option encryption 'psk2'
        option key 'openwrt1234'

```

### 改 /etc/config/network
```
config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fdaa:5a73:9c8e::/48'

config interface 'lan'
        option ifname 'eth0'
        option force_link '1'
        option type 'bridge'
        option proto 'static'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'
        option ip6assign '60'

```

### 搞挂了
电脑的IP  192.168.1.2  gateway192.168.1.1 255.255.255.0
first_boot
reboot -f

ssh 192.168.1.1

### network
加上
```
config interface 'lan'
        option ifname 'eth0'
        option force_link '1'
        option type 'bridge'
#       option proto 'static'
        option proto 'dhcp'
#       option ipaddr '192.168.1.1'
#       option netmask '255.255.255.0'
        option ip6assign '60'
```

连接已有的路由上网

装东西

软件安装

```
opkg update
opkg install kmod-macvlan ip
```

编辑开机启动文件，在开机时虚拟出另外一张有线网卡，以区别WAN和LAN。

vi /etc/rc.local
 

在文件的exit 0之前加入以下内容。这里的MAC地址可以改成别的。
```
ip link add link eth0 eth2 type macvlan
ifconfig eth2 hw ether 00:11:22:33:44:5b
ifconfig eth2 up
 
exit 0
```


把虚拟出的网卡分配给LAN使用。
```
uci set network.lan.ifname=eth2
```

创建WAN接口。这里的协议设为DHCP，可以直接将703N插入已经存在的有线网络中，即可上网。

```
uci set network.wan=interface
uci set network.wan.proto=dhcp
uci set network.wan.hostname=openwrt-wan
uci set network.wan.ifname=eth0
uci commit network
```


### install ss
```
opkg install http://ncu.dl.sourceforge.net/project/openwrt-dist/shadowsocks-libev/2.4.1-6f44d53/ar71xx/shadowsocks-libev-spec-polarssl_2.4.1-1_ar71xx.ipk
```
提示空间不够。。。。


### 参考
http://www.cnblogs.com/Lifehacker/archive/2013/04/13/failure_on_fwr171-3g_with_openwrt.html
http://www.isucc.me/555.html
http://shuyz.com/install-shadowsocks-on-hg255d-openwrt-and-config-nat.html
http://www.tuicool.com/articles/3Q7V7z3

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

