---
title: Docker基础知识: namespace cgroup
date: 2016-08-15 00:00:00
categories:
- code
tags: 
- docker
- cgroup
- namespace
mathjax: true
description: 
---

记录一下docker基础知识

namespace是环境隔离，cgroup是资源隔离，加起来就是docker的基础

<!--more-->

# namespace

1. CLONE_NEWPID
2. CLONE_NEWUTS
3. CLONE_NEWNS
4. CLONE_NEWIPC
5. CLONE_NEWNET
6. CLONE_NEWUSER

## 不带namespace

```c
#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

//子进程堆栈空间大小
#define STACK_SIZE (1024 * 1024)

static char child_stack[STACK_SIZE];

char* const child_cmd[] = {
    "/bin/bash",
    NULL
};

int child()
{
    printf("Child start!\n");
    printf("Child pid in child process: %5d\n", getpid());
    //使用bash替换掉原进程便于观察
    execv(child_cmd[0], child_cmd);
    printf("Child stop!\n");
    return 0;
}

int main()
{
    printf("Parent start!\n");
    printf("Parent pid: %5d\n", getpid());
    int child_pid = clone(child, child_stack+STACK_SIZE, SIGCHLD, NULL);
    printf("Child pid in parent process: %5d\n", child_pid);
    waitpid(child_pid, NULL, 0);
    printf("Parent stop!\n");
    return 0;
}
```

## UTS

# cgroup

# 参考
[https://yq.aliyun.com/articles/57743](https://yq.aliyun.com/articles/57743)
[http://coolshell.cn/articles/17049.html](http://coolshell.cn/articles/17049.html)

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

