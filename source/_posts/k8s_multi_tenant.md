---
title: kubernetes多租户分析
date: 2016-08-01 01:00:00
categories:
- code
tags: 
- docker
- kubernetes
- multi-tenant
mathjax: true
description: 
---
# 背景
公有云产品有个很重要的概念叫多租户，比如OpenStack的Domain/Project。提供资源隔离，权限控制，等等。
kubernetes如果作为PaaS的基础，那么也需要具备此能力。
<!--more-->

# NameSpace
> Kubernetes supports multiple virtual clusters backed by the same physical cluster. These virtual clusters are called namespaces.

一组逻辑的集群，可以大概类似于租户的概念，可以做到一定程度的资源隔离，Quota。如果非要和OpenStack做个映射，那么就大概对应于Project吧。

举个例子
- kubectl --namespace=abc run nginx --image=nginx
- kubectl  run nginx --image=nginx
这两条命令虽然都是run起来一个nginx，但是作用域却不一样。命令1是在一个叫abc的namespace里运行nginx，命令2则是在Default


# Resource Quota
> A resource quota, defined by a ResourceQuota object, provides constraints that limit aggregate resource consumption per namespace.
限制某个name space的资源总数

使用方法: It is enabled when the apiserver --admission-control= flag has ResourceQuota as one of its arguments

## Compute Resource Quota
Resource Name|Description
--|--
cpu|Across all pods in a non-terminal state, the sum of CPU requests cannot exceed this value.
limits.cpu|Across all pods in a non-terminal state, the sum of CPU limits cannot exceed this value.
limits.memory|Across all pods in a non-terminal state, the sum of memory limits cannot exceed this value.
memory|Across all pods in a non-terminal state, the sum of memory requests cannot exceed this value.
requests.cpu|Across all pods in a non-terminal state, the sum of CPU requests cannot exceed this value.
requests.memory|Across all pods in a non-terminal state, the sum of memory requests cannot exceed this value.


## Object Count Quota
Resource Name|Description
--|--
configmaps|The total number of config maps that can exist in the namespace.
persistentvolumeclaims|The total number of persistent volume claims that can exist in the namespace.
pods|The total number of pods in a non-terminal state that can exist in the namespace. A pod is in a terminal state if status.phase in (Failed, Succeeded) is true.
replicationcontrollers|The total number of replication controllers that can exist in the namespace.
resourcequotas|The total number of resource quotas that can exist in the namespace.
services|The total number of services that can exist in the namespace.
services.loadbalancers|The total number of services of type load balancer that can exist in the namespace.
services.nodeports|The total number of services of type node port that can exist in the namespace.
secrets|The total number of secrets that can exist in the namespace.

对象的总数，比如限制最多可以创建几个pod，最多几个rc

```
$ kubectl describe quota compute-resources --namespace=myspace
Name:                  compute-resources
Namespace:             myspace
Resource               Used Hard
--------               ---- ----
limits.cpu             0    2
limits.memory          0    2Gi
pods                   0    4
requests.cpu           0    1
requests.memory        0    1Gi

$ kubectl describe quota object-counts --namespace=myspace
Name:                   object-counts
Namespace:              myspace
Resource                Used    Hard
--------                ----    ----
configmaps              0       10
persistentvolumeclaims  0       4
replicationcontrollers  0       20
secrets                 1       10
services                0       10
services.loadbalancers  0       2
```

# Limit Range

需要在Admission Controller启用LimitRanger插件

By default, pods run with unbounded CPU and memory limits.

Let’s create a simple limit in our namespace.
```
$ kubectl create -f docs/admin/limitrange/limits.yaml --namespace=limit-example

limitrange "mylimits" created
```

Let’s describe the limits that we have imposed in our namespace.
```
$ kubectl describe limits mylimits --namespace=limit-example
Name:   mylimits
Namespace:  limit-example
Type        Resource      Min      Max      Default Request      Default Limit      Max Limit/Request Ratio
----        --------      ---      ---      ---------------      -------------      -----------------------
Pod         cpu           200m     2        -                    -                  -
Pod         memory        6Mi      1Gi      -                    -                  -
Container   cpu           100m     2        200m                 300m               -
Container   memory        3Mi      1Gi      100Mi                200Mi              -
```

# ABAC

限定某个用户能做的事情，比如
Alice can do anything to all resources:
```json
{
    "apiVersion":"abac.authorization.kubernetes.io/v1beta1",
    "kind":"Policy",
    "spec":{
        "user":"alice",
        "namespace":"*",
        "resource":"*",
        "apiGroup":"*"
    }
}
```

Bob can just read pods in namespace “projectCaribou”
```json
{
    "apiVersion":"abac.authorization.kubernetes.io/v1beta1",
    "kind":"Policy",
    "spec":{
        "user":"bob",
        "namespace":"projectCaribou",
        "resource":"pods",
        "readonly":true
    }
}
```

缺点是，必须在api server启动的时候就传入文件。如果需要对权限做修改，那么必须重启api server才能生效

# RBAC
之前提到了ABAC比较弱，所以呢1.3出来个新特性，叫RBAC，目前还是Alpha。
从名字就能看出来`“RBAC” (Role-Based Access Control)`，基于角色，有点像OpenStack的角色了
## Roles
```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1alpha1
metadata:
  namespace: default
  name: pod-reader
rules:
  - apiGroups: [""] # The API group "" indicates the default API Group.
    resources: ["pods"]
    verbs: ["get", "watch", "list"]
    nonResourceURLs: []
```

## RolesBindings
```
# This role binding allows "jane" to read pods in the namespace "default"
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1alpha1
metadata:
  name: read-pods
  namespace: default
subjects:
  - kind: User # May be "User", "Group" or "ServiceAccount"
    name: jane
roleRef:
  kind: Role
  namespace: default
  name: pod-reader
  apiVersion: rbac.authorization.k8s.io/v1alpha1
```
## 一图胜千言
{% plantuml %}
package "namespace1" as ns1 {

}

package "namespace2" as ns2{

}

[role1]->ns1
[userA]->[role_binding1]
[role_binding1]->[role1]
[userB] -up->[role_binding1]

[userB] -down->[role_binding2]
[role_binding2]->[role2]
[role2]->ns2
{% endplantuml %}

userA和userB是通过`[role_binding1][role1]`连接到name space 1，得到在name space1进行操作的权限。
userB则是`[role_binding2]->[role2]`得到在name space2进行操作的权限。


# webhook
感觉很强大，是否可以和keystone对接？把OpenStack的多租户能力借鉴过来？




-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/
