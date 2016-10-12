---
title: sysdig源码分析
date: 2016-10-12 00:00:00
categories:
- code
tags: 
- APM
mathjax: true
description: 
---

之前分析APM的时候，试用了sysdig，觉得sysdig很厉害
1. 通过内核抓事件，不用侵入到容器
2. 可以自己写铲子，扩展起来很方便。
于是就顺手看下他的实现原理

<!--more-->

# 源码
[https://github.com/draios/sysdig](https://github.com/draios/sysdig)

# 流程

{% plantuml %}
    (*) --> "Initialization"

    --> "sysdig register event"

    --> "chisel(lua) on_init\n set_filter & set_snaplen"


    --> "kernel event"

    if "while GetEvent?" then
       -->[yes] "callback c"
       -> "callback chisel"
       -> "chisel on_event"
       --> "kernel event"
    else
      ->[no] "exit"

    -->[Ending process] (*)


{% endplantuml %}

# chisels的原理
安装之后会在/usr/share/sysdig/chisels，看下memcachelog这个铲子的代码
```lua
-- Initialization callback
function on_init()
    util = {}
    start_time = os.time()
    sysdig.set_filter("(fd.sport=11211 or proc.name=memcached) and evt.is_io=true")
    sysdig.set_snaplen(4096)
    data = chisel.request_field("evt.arg[1]")
    datetime = chisel.request_field("evt.datetime")
    return true
end

-- Event callback
function on_event()
  local data = evt.field(data)
  local line = split(data, " ")
  if string.match(line[1], '^[gs]et') ~= nil then
    local method = line[1]
    local key = line[2]
    local size = tonumber(line[5]) or 0
    if key ~= nil then
      if opt_method ~= nil and opt_method ~= method then
        return true
      end
      if opt_method == 'set' and size < opt_size then
        return true
      end
      print(string.format("%s method=%s size=%dB key=%s",
              evt.field(datetime),
              method,
              size,
              key
      ))
    end
  end
  return true
end
```
on_init 设置filter，以及需要哪些data field

on_event，获取参数，得到method，是get/set，以及key

# sysdig原理

`driver/event_table.c` 事件都在这里g_event_info

`driver/ppm_fillers.c` g_ppm_events事件的回调

`userspace/libsinsp/chisel_api.cpp` lua_cbacks这个类是，lua调用c代码的接口

疑问：
1. 当事件发生，如何通过g_ppm_events里的回调函数再调用到lua里的on_event
2. event_table里的事件是如何发送到内核的？用到哪个API？是不是和systemtap差不多？

晚上回家继续看看


----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


