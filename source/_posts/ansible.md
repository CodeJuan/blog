---
title: 学习ansible
date: 2015-10-11 00:00:00
categories:
- code
tags: 
- devops
- ansible
- deploy
mathjax: true
description: 
---

# 入门文档
开始get ops技能，自动部署应该算是基础的基础了吧，而ansible美名远扬，自然不能错过。
先从入门文档开始[http://docs.ansible.com/](http://docs.ansible.com/)
<!--more-->

# install
老规矩，从源码开始
```bash
git clone https://github.com/ansible/ansible.git --recursive
cd ./ansible
source ./hacking/env-setup

# 依赖的库
sudo pip install paramiko PyYAML Jinja2 httplib2 six
```

当然，也可以直接用pip安装
```bash
sudo pip install ansible
```

# Inventory


## 创建hosts
```bash
sudo mkdir /etc/ansible/

sudo vi /etc/ansible/hosts
# 在hosts写上agent的IP

export ANSIBLE_INVENTORY=/etc/ansible/hosts
```

## 执行ping
```bash
ansible all -m ping
```
## 提示失败
```bash
192.168.161.52 | UNREACHABLE! => {
    "changed": false, 
    "msg": "ERROR! SSH encountered an unknown error during the connection. We recommend you re-run the command using -vvvv, which will enable SSH debugging output to help diagnose the issue", 
    "unreachable": true
}
```
我明明已经把master加入到可信SSH里了呀，可以不用密码ssh到agent呢。

## 解决
查看官方文档[http://docs.ansible.com/ansible/intro_inventory.html](http://docs.ansible.com/ansible/intro_inventory.html)，提到
> `ansible_host`
  The name of the host to connect to, if different from the alias you wish to give to it.
`ansible_port`
  The ssh port number, if not 22
`ansible_user`
  The default ssh user name to use.
ansible_ssh_pass
  The ssh password to use (this is insecure, we strongly recommend using --ask-pass or SSH keys)
ansible_ssh_private_key_file
  Private key file used by ssh.  Useful if using multiple keys and you don't want to use SSH agent.
ansible_ssh_common_args
  This setting is always appended to the default command line for
  sftp, scp, and ssh. Useful to configure a ``ProxyCommand`` for a
  certain host (or group).
ansible_sftp_extra_args
  This setting is always appended to the default sftp command line.
ansible_scp_extra_args
  This setting is always appended to the default scp command line.
ansible_ssh_extra_args
  This setting is always appended to the default ssh command line.
ansible_ssh_pipelining
  Determines whether or not to use SSH pipelining. This can override the
  ``pipelining`` setting in ``ansible.cfg``.


需要设置IP、port和user


## 改写hosts文件
加上user
```
g530 ansible_user=g530 ansible_ssh_host=192.168.161.52
```
再次调用`ansible all -m ping`，提示成功

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

