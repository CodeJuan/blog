---
title: kubernetes自定义admission插件
date: 2016-06-28 00:00:00
categories:
- code
tags: 
- docker
- kubernetes
mathjax: true
description: 
---

# 背景

## quota
k8s的resourcequota的粒度太粗，只能针对namespace级进行quota。
为了实现更细粒度的quota，有必要自制一个admission插件。

## ABAC
由于ABAC是在api server启动的时候载入，如果有修改，就必须重启api server才能生效。所以我想做个动态ABAC插件，把权限信息保存到etcd

<!--more-->

# 分析源码
代码在plugin/pkg/admission，已有admit, deny, resourcequota等插件。
有两个函数需要重点关注
## init
```
func init() {
	admission.RegisterPlugin("AlwaysAdmit", func(client clientset.Interface, config io.Reader) (admission.Interface, error) {
		return NewAlwaysAdmit(), nil
	})
}
```
注册`AlwaysAdmit`，返回值是`admission.Interface`，注意看admit函数

## admit
```
func (alwaysAdmit) Admit(a admission.Attributes) (err error) {
	return nil
}
```

# 自定义插件
也要实现一个init，用于注册及返回Interface。然后完成admit函数
```
func (l *myadmission) Admit(a admission.Attributes) (err error) {
    // 加上我的判断逻辑
    if allow {
        return nil
    } else {
        return admission.NewForbidden()
    }
}
```


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

