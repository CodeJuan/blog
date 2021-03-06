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

## 配置ssh-agent试试
```bash
ssh-agent bash
ssh-add ~/.ssh/id_rsa
```
还是不行

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

# dynamic_inventory
[http://docs.ansible.com/ansible/intro_dynamic_inventory.html](http://docs.ansible.com/ansible/intro_dynamic_inventory.html)
暂时不看，等用到的时候再看

# pattern & ad-hoc command
也暂时略过

# playbook

## ping
先写一个最简单的ping

```
---                                                                        
- hosts: g530
  tasks:
  - name: ping
    ping:  
```

然后调用
```
ansible-playbook -i /etc/ansible/hosts playbook.yml
```
显示
```
PLAY ***************************************************************************

TASK [setup] *******************************************************************
ok: [g530 -> localhost]

TASK [ping] ********************************************************************
ok: [g530 -> localhost]

PLAY RECAP *********************************************************************
g530                       : ok=2    changed=0    unreachable=0    failed=0   
```
说明成功

代码放在[https://github.com/CodeJuan/ansible_play/tree/master/ping](https://github.com/CodeJuan/ansible_play/tree/master/ping)

## advanced
来尝试一个高端点的，带roles handler template的
### playbook
```
---
- name: role_handler
  hosts: g530
  
  roles:
  - test
```

### 创建roles
```
current_dir
|--playbook.yml
|--roles
   |--test
      |--handlers
         |--main.yml
      |--tasks
         |--main.yml
      |--templates
         |--存放模板
```
需要创建一个roles文件夹，里边的子文件夹的名字就是playbook里写的roles名字

### handlers
每个role都会有handlers文件夹，里边的main.yml放一些响应事件
```
---
- name: restart
  service: name=iptables state=restarted enabled=yes
```
例子里表示重启iptables

### tasks
role的tasks里的main.yml就是真正要执行的任务
```
---
- name: ping and restart iptables
  ping:  
  notify: restart test
```
表示先ping，然后调用handler里的restart

### template
在template里创建一个文件`haha`，将他拷贝到agent的`/tmp`
tasks mail.yml改为
```
---
- name: ping
  ping:   
  template: src=haha dest=/tmp/haha
  notify: restart test
```
提示语法错误，看起来似乎一个`name`只能有一个操作

改为两个name貌似就好了
```
---
- name: ping
  ping:   

- name: template iptables
  template: src=haha dest=/tmp/haha
  notify: restart test
```

再play一下
```
PLAY [role_handler] ************************************************************

TASK [setup] *******************************************************************
ok: [g530 -> localhost]

TASK [test : ping] *************************************************************
ok: [g530 -> localhost]

TASK [test : template iptables] ************************************************
changed: [g530 -> localhost]

PLAY RECAP *********************************************************************
g530                       : ok=3    changed=1    unreachable=0    failed=0   

```
果然多了一个操作

代码放在[https://github.com/CodeJuan/ansible_play/tree/master/advancded_play](https://github.com/CodeJuan/ansible_play/tree/master/advancded_play)


# 深入学习
已经了解了基本概念，接下来就要看一些优秀案例了
[http://docs.ansible.com/ansible/playbooks_best_practices.html](http://docs.ansible.com/ansible/playbooks_best_practices.html)
[https://github.com/ansible/ansible-examples](https://github.com/ansible/ansible-examples)





----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

