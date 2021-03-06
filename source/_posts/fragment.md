---
title: 真的是内存碎片吗
date: 2015-01-15 23:30:09
categories:
- code
tags: 
- memory
- fragment
mathjax: true
description:
---


## 背景 


| 配置        | 参数           |
| ------------- |-------------|
| 系统      | win32 |
| CPU      | E5505      |
| 内存      | 4G      |


某程序在运行过程中峰值达到1.8G，此后在申请小块内存时出现异常，此时进程只使用了900M内存。
如你所知，windows 32bit的每个进程可用虚拟内存是4G，其中内核态2G，用户态2G（`打开3G开关后就会是3G，但是不建议打开`）。异常时，进程尚有近1G的内存可用，但为什么会抛出异常呢？
真的是内存碎片造成的吗？

<!--more-->

## 调查


运行两次，在不同的地方crash，抓到两个dump，用windbg简单分析一下。

### Crash 1 : vector.push_back

异常链:  `push_back -> allovator -> new -> MemoryException`。说明是在`push_back`申请内存时抛出的内存异常。简单回忆一下vector的内存分配机制，vector是连续存储的容器，它在新插入一个元素的时候，如果发现当前持有的*内存*放不下，那么就会再申请一块更大的内存（内存分配策略有差异，可以简单视为两倍），然后将旧内存中的元素复制到新内存中，并释放旧内存中的元素，再插入新的元素。
由此猜测，push_back时vector里是不是有很多元素，使得此次会申请很大的一块连续内存，而系统没有合适的内存空间，然后申请失败抛出异常呢？
查看代码，并询问开发小伙，得知crash时vector中元素个数不多，push_back时申请的不会是一块很大的连续内存，难道是真的是传说中的碎片？


### Crash 12: CString.AppendFormat


异常链:  `AppendFormat -> PrepareWrite -> Reallocate -> MemoryException`。
有`allocate`的字样，看起来又像是在申请内存。查看一下微软CString的源码，在preparewrite函数中实现了这么一个内存算法：

``` cpp
//凭印象写的，领会精神
PrepareWrite()
{
	if (current_len < 1G)
	{
		//小于1G，每次都是申请1.5倍
		new_len = current_len * 1.5;
	}
	else
	{
		//大于1G，每次加1M
		new_len = current_len + 1M;
	}
}
```

```cpp
PrepareWrite()
{
	if (current_len < 1G)
	{
		//小于1G，每次都是申请1.5倍
		new_len = current_len * 1.5;
	}
	else
	{
		//大于1G，每次加1M
		new_len = current_len + 1M;
	}
}
```


查看了当前string的长度，几百几千个字符而已，也就只申请几K内存。只是申请这么小的内存，怎么也申请失败了？


## 简单分析

查了下微软的一些文档

> .Net application, 32-bit process, 32-bit OS, 800-1200 MB

微软说32位.Net程序内存在800M-1200M的时候，可能会出现out of memory的异常。

> High memory usage or memory leak can cause virtual memory usage in a process to keep growing over time and prevent it from ever returning to normal usage levels. The process can then run out of memory and this can cause it to terminate unexpectedly. During these out-of-memory instances, the virtual memory may fall below 1 Gb, instead of the 2 Gb allowed to Win 32 processes. This problem is sometimes caused by high memory fragmentation.

微软建议虽然win32进程可以用2G，但最好是低于1G，否则可能会许多奇怪问题，有时就是内存碎片引起的。

如此，可能真的是碎片引起的。


## 初步解决方法

将前面的内存降下去，就能顺利申请到内存，正常运行。但还是不能确定真的是内存碎片引起的。
As a modern OS, the strategy of memory allocation so sucks? I don't think so. The  failure of memory allocattion caused by fragment. And The fragment should be caused by memory leak..


-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

