---
title: KVM的几种缓存模式
date: 2017-01-17 01:00:00
categories:
- code
tags:
- KVM
- cache
mathjax: true
description: 
---

现象：
1. 虚拟机的IO性能比物理机/容器好？
1. 容器和物理机差不多，这个很好理解，如果没有做IO limit，肯定和物理机相近
1. 用的virsh disk-attach宿主机上的一个/dev/sdxxx，用的是default
1. 顺序读写完爆物理机
1. 随机读写从1K，4K，16K到1M都比物理机强，唯有64M的写比物理机差

比较奇怪，需要分析一下

<!--more-->

# 改cache mode
>writethrough
>writethrough mode is the default caching mode. With caching set to writethrough mode, the host page cache is enabled, but the disk write cache is disabled for the guest. Consequently, this caching mode ensures data integrity even if the applications and storage stack in the guest do not transfer data to permanent storage properly (either through fsync operations or file system barriers). Because the host page cache is enabled in this mode, the read performance for applications running in the guest is generally better. However, the write performance might be reduced because the disk write cache is disabled.
>默认模式，认为host page开启，没有用disk cache，会保证数据可靠，写性能会差，读性能会好？

>writeback
>With caching set to writeback mode, both the host page cache and the disk write cache are enabled for the guest. Because of this, the I/O performance for applications running in the guest is good, but the data is not protected in a power failure. As a result, this caching mode is recommended only for temporary data where potential data loss is not a concern.
>host page和disk cache都开启，性能最好，但在掉电时会有丢数据的风险

>none
>With caching mode set to none, the host page cache is disabled, but the disk write cache is enabled for the guest. In this mode, the write performance in the guest is optimal because write operations bypass the host page cache and go directly to the disk write cache. If the disk write cache is battery-backed, or if the applications or storage stack in the guest transfer data properly (either through fsync operations or file system barriers), then data integrity can be ensured. However, because the host page cache is disabled, the read performance in the guest would not be as good as in the modes where the host page cache is enabled, such as writethrough mode.
>只开disk cache，不开host page，号称写性能最强，读一般

>unsafe
>Caching mode of unsafe ignores cache transfer operations completely. As its name implies, this caching mode should be used only for temporary data where data loss is not a concern. This mode can be useful for speeding up guest installations, but you should switch to another caching mode in production environments.
>只写到缓存，不落盘，建议只保存临时数据

改成none试了下，竟然性能都变差？按理说写性能会提升啊？

# host page cache对性能的影响
- 64M性能下降是因为cache被打穿？对于大块用direct IO性能更好？即使改成direct IO，那么也是只绕过guest os的page cache啊？此时用none会更好？然而实际上，none的性能不好。
- 只要有空闲，系统的cache buffer都会很大。物理机是128G内存，所以虚拟机的读写操作都在内存里完成？
- 小块性能好，因为都在内存里？


# 结论
真的是缓存的原因？大丈夫？


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


