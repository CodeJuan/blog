---
layout: post
title: cobbler自动部署系统
date: 2015-11-01 01:00:00
categories:
- code
tags: 
- deploy
- cobbler
- system
mathjax: true
description: 
---


# 背景

我司竟然还是人肉装系统，太TMD老土了。于是找到了`cobbler`，官网在[http://cobbler.github.io/](http://cobbler.github.io/)

先看一段简介

> Cobbler is a Linux installation server that allows for rapid setup of network installation environments.

很叼吧。

<!--more-->

# 开启PXE
由于cobbler是通过PXE给裸机装系统的，所以要先改裸机的BIOS设置，改为从网卡启动。

## 某品牌主板的设置方法
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cobbler/1.jpg)
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cobbler/2.jpg)
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cobbler/3.jpg)

## 另一品牌主板的设置方法
![](https://github.com/CodeJuan/codejuan.github.io/raw/master/images/blog/cobbler/MicroStar.jpg)

# 安装cobbler

参考官网的quick start [http://cobbler.github.io/manuals/quickstart/](http://cobbler.github.io/manuals/quickstart/)

## disable SELinux

由于我对SELinux不熟悉，根据官网的建议，还是把SELinux Disable吧

参考[https://www.centos.org/docs/5/html/5.1/Deployment_Guide/sec-sel-enable-disable.html](https://www.centos.org/docs/5/html/5.1/Deployment_Guide/sec-sel-enable-disable.html)

修改`/etc/sysconfig/selinux`，修改`SELINUX`的值为`disabled`，并增加一行`SETLOCALDEFS=0`

```sh
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing  # 改为 disabled
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted 

```

## Installing Cobbler

### 错误的方法

```sh
sudo yum install cobbler
```

提示没有package，说明要添加源。
按照[http://cobbler.github.io/manuals/2.4.0/3/2_-_Installing_From_Packages.html](http://cobbler.github.io/manuals/2.4.0/3/2_-_Installing_From_Packages.html)说

```bash
# sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-X-Y.noarch.rpm
  sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/epel-release-7-0.noarch.rpm
```

还是不行，因为我不知道具体的版本号。

只好找到最新release的页面[http://cobbler.github.io/posts/2015/09/30/cobbler_2.6.10_released.html](http://cobbler.github.io/posts/2015/09/30/cobbler_2.6.10_released.html)，根据`Packages will be provided as soon as possible, please check`的提示，找到[http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-7/noarch/](http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-7/noarch/)

添加源

```sh
sudo rpm -Uvh http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-7/noarch/cobbler-2.6.10-11.2.noarch.rpm
sudo rpm -Uvh http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-7/noarch/cobbler-web-2.6.10-11.2.noarch.rpm
sudo rpm -Uvh http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/CentOS_CentOS-7/noarch/koan-2.6.10-11.2.noarch.rpm
```

提示缺少python的一堆库，

```
python-simplejson is needed by cobbler-2.6.10-11.2.noarch
python-cheetah is needed by cobbler-2.6.10-11.2.noarch
```

使用pip安装simplejson和cheetah，还是报这个错，看来此路不通，需要另想它法。

### 正确的方法
找到了这个链接[http://cobbler.readthedocs.org/en/latest/installation-guide.html](http://cobbler.readthedocs.org/en/latest/installation-guide.html)

Make sure you have the EPEL repository enabled on your system:

```sh
yum -y install epel-release
yum repolist
# sudo curl -o cobbler30.repo http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler30/CentOS_CentOS-7/home:libertas-ict:cobbler30.repo
```

接下来

```sh
yum install cobbler cobbler-web
```

就安装成功了

## 启动cobbler

### 改配置

`/etc/cobbler/settings`

```
default_password_crypted: "$1$bfI7WLZz$PxXetL97LkScqJFxnW7KS1" # 123456
openssl passwd -1

next_server: 192.168.161.51
server: 192.168.161.51

manage_dhcp = 1

```


```sh
sudo service httpd start
sudo service xinetd start
sudo service cobblerd start

sudo chkconfig cobblerd on
sudo chkconfig xinetd on
sudo chkconfig httpd on
```


检查配置

```sh
sudo cobbler check
```

提示

```
1 : SELinux is enabled. Please review the following wiki page for details on ensuring cobbler works correctly in your SELinux environment:
    https://github.com/cobbler/cobbler/wiki/Selinux
2 : change 'disable' to 'no' in /etc/xinetd.d/tftp
3 : some network boot-loaders are missing from /var/lib/cobbler/loaders, you may run 'cobbler get-loaders' to download them, or, if you only want to handle x86/x86_64 netbooting, you may ensure that you have installed a *recent* version of the syslinux package installed and can ignore this message entirely.  Files in this directory, should you want to support all architectures, should include pxelinux.0, menu.c32, elilo.efi, and yaboot. The 'cobbler get-loaders' command is the easiest way to resolve these requirements.
4 : file /etc/xinetd.d/rsync does not exist
5 : debmirror package is not installed, it will be required to manage debian deployments and repositories
6 : The default password used by the sample templates for newly installed machines (default_password_crypted in /etc/cobbler/settings) is still set to 'cobbler' and should be changed, try: "openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'" to generate new one
7 : fencing tools were not found, and are required to use the (optional) power management features. install cman or fence-agents to use them
```

根据提示一一修改
解决方法

1. disable selinux
2. 改配置文件
3. 执行cobbler get-loaders
4. 新建/etc/xinetd.d/rsync，增加disable = no,修改 rsync 和 tftp 这两个服务的 xinetd 配置

```
# vi /etc/xinetd.d/rsync
service rsync
{
        disable = no
}

# vi /etc/xinetd.d/tftp
service tftp
{
        disable = no
}
```

5. 不支持debian系，cobbler服务器能同时部署CentOS/Fedora/Debian/Ubuntu系统，所以需要安装debmirror，安装debmirror-20090807-1.el5.noarch.rpm，在此之前，需要先安装一些其他的依赖包：
暂时不管，我这里只测试centos
```sh
wget ftp://rpmfind.net/linux/epel/6/x86_64/debmirror-2.14-2.el6.noarch.rpm
sudo rpm -ivh debmirror-2.14-2.el6.noarch.rpm
```

```
# yum install ed patch perl perl-Compress-Zlib perl-Cwd perl-Digest-MD5 perl-Digest-SHA1 perl-LockFile-Simple perl-libwww-perl
# wget ftp://fr2.rpmfind.net/linux/epel/5/ppc/debmirror-20090807-1.el5.noarch.rpm
# rpm –ivh debmirror-20090807-1.el5.noarch.rpm
# 修改/etc/debmirror.conf 配置文件，注释掉 @dists 和 @arches 两行

# vim /etc/debmirror.conf

#@dists=”sid”;
@sections=”main,main/debian-installer,contrib,non-free”;
#@arches=”i386″;
```

6. 生成密码。修改默认系统密码用 openssl 生成一串密码后加入到 cobbler 的配置文件（/etc/cobbler/settings）里，替换 default_password_crypted 字段：

```
# openssl passwd -1 -salt ‘bihan’ ‘Abcd1234′
$1$‘bihan$bndMeAmxTpT0ldGYQoRSw0
# vi /etc/cobbler/settings
修改内容如下：
default_password_crypted: “$1$‘bihan$bndMeAmxTpT0ldGYQoRSw0″
```

7. yum install cman或者fence-agents，我装的是fence-agents

改完之后运行

```sh
sudo service cobblerd restart
sudo cobbler sync
# 再check一下
sudo cobbler check
```

就只剩下debmirror的问题了，可以暂时不管

下载并挂载iso

```sh
wget wget http://mirrors.sina.cn/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1503-01.iso

#sudo mount -t iso9660 -o loop,ro ./CentOS-7-x86_64-Minimal-1503-01.iso /mnt
sudo mount -t iso9660 -o loop,ro /home/i3/save/iso/CentOS-7-x86_64-Minimal-1503-01.iso /mnt/centos
#sudo cobbler import --name=centos7 --arch=x86_64 --path=/mnt
sudo cobbler import --name=centos7 --arch=x86_64 --path=/mnt/centos
#sudo vi /etc/fstab
# 增一行/home/i3/save/iso/CentOS-7-x86_64-Minimal-1503-01.iso   /home/i3/save/cobbler_os iso9660 defaults,ro,loop  0 0

#umount /somedir
```

挂载时报错

```
# sudo cobbler import --name=centos7 --arch=x86_64 --path=/mnt/centos
task started: 2015-11-04_215116_import
task started (id=Media import, time=Wed Nov  4 21:51:16 2015)
Found a candidate signature: breed=redhat, version=rhel6
Found a candidate signature: breed=redhat, version=rhel7
Found a matching signature: breed=redhat, version=rhel7
Adding distros from path /var/www/cobbler/ks_mirror/centos7-x86_64:
creating new distro: centos7-x86_64
trying symlink: /var/www/cobbler/ks_mirror/centos7-x86_64 -> /var/www/cobbler/links/centos7-x86_64
creating new profile: centos7-x86_64
Exception occured: <type 'exceptions.UnicodeEncodeError'>
Exception value: 'ascii' codec can't encode character u'\u2018' in position 3: ordinal not in range(128)
Exception Info:
  File "/usr/lib/python2.7/site-packages/cobbler/remote.py", line 87, in run
    rc = self._run(self)
   File "/usr/lib/python2.7/site-packages/cobbler/remote.py", line 231, in runner
    self.logger
   File "/usr/lib/python2.7/site-packages/cobbler/api.py", line 938, in import_tree
    return import_module.run(path,mirror_name,network_root,kickstart_file,arch,breed,os_version)
   File "/usr/lib/python2.7/site-packages/cobbler/modules/manage_import_signatures.py", line 140, in run
    os.path.walk(self.path, self.distro_adder, distros_added)
   File "/usr/lib64/python2.7/posixpath.py", line 246, in walk
    walk(name, func, arg)
   File "/usr/lib64/python2.7/posixpath.py", line 246, in walk
    walk(name, func, arg)
   File "/usr/lib64/python2.7/posixpath.py", line 238, in walk
    func(arg, top, names)
   File "/usr/lib/python2.7/site-packages/cobbler/modules/manage_import_signatures.py", line 255, in distro_adder
    adtls.append(self.add_entry(dirname,kernel,initrd))
   File "/usr/lib/python2.7/site-packages/cobbler/modules/manage_import_signatures.py", line 360, in add_entry
    self.profiles.add(profile,save=True)
   File "/usr/lib/python2.7/site-packages/cobbler/collection.py", line 352, in add
    self.lite_sync.add_single_profile(ref.name)
   File "/usr/lib/python2.7/site-packages/cobbler/action_litesync.py", line 133, in add_single_profile
    self.sync.pxegen.make_pxe_menu()
   File "/usr/lib/python2.7/site-packages/cobbler/pxegen.py", line 330, in make_pxe_menu
    self.make_actual_pxe_menu()
   File "/usr/lib/python2.7/site-packages/cobbler/pxegen.py", line 480, in make_actual_pxe_menu
    menu_items = self.get_menu_items()
   File "/usr/lib/python2.7/site-packages/cobbler/pxegen.py", line 404, in get_menu_items
    arch=distro.arch, include_header=False)
   File "/usr/lib/python2.7/site-packages/cobbler/pxegen.py", line 702, in write_pxe_file
    image, arch, kickstart_path)
   File "/usr/lib/python2.7/site-packages/cobbler/pxegen.py", line 880, in build_kernel_options
    append_line = self.templar.render(append_line,utils.flatten(blended),None)
   File "/usr/lib/python2.7/site-packages/cobbler/templar.py", line 137, in render
    data_out = data_out.replace("@@%s@@" % str(x), str(search_table[str(x)]))

!!! TASK FAILED !!!

```


删除

```sh
sudo cobbler profile remove --name=centos7-x86_64
sudo cobbler distro remove --name=centos7-x86_64
```

再重来，看看是不是哪里代码的问题

python编码的问题，在python的Lib\site-packages文件夹下新建一个sitecustomize.py
```python
# encoding=utf8  
import sys

reload(sys)
sys.setdefaultencoding('utf8') 
```

```sh
sudo cobbler distro report
sudo cobbler system add --name=test --profile=centos7-x86_64
sudo cobbler system list
sudo cobbler system report --name=test

# 待安装机器的mac和IP
sudo cobbler system edit --name=test --interface=eth0 --mac=d0:27:88:d1:4d:7f --ip-address=192.168.161.52 --netmask=255.255.255.0 --static=1 
#--dns-name=bogon
sudo cobbler system edit --name=test --gateway=192.168.161.1 
#--hostname=bogon
sudo cobbler sync

```

-----------------------

`本博客欢迎转发,但请保留原作者信息`

github:[codejuan](https://github.com/CodeJuan)

博客地址:http://blog.decbug.com/
