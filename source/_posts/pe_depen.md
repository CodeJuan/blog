---
title: 自动生成软件中模块依赖图
date: 2015-07-26 00:00:00
categories:
- code
tags: 
- module
- dependency
- graphviz
mathjax: true
description: 
---


# 前言
上回实现了[自动生成sln中各project依赖图](http://blog.decbug.com/2015/07/06/dependency_in_sln/)，可以分析一个VS solution里面每个project的依赖关系，但是这个太弱了。我需要exe、dll之间依赖图，所以只能继续想办法了。

# 思路
1. 获取该软件目录下所有模块(exe和dll)
2. 通过vs自带的dumpbin命令得到每个模块文件的依赖
3. 画出graphviz的dot脚本
4. graphviz绘图

<!--more-->

# 使用方法
代码已经写好，放在[https://github.com/CodeJuan/pe_dependency](https://github.com/CodeJuan/pe_dependency)
先说怎么用
1. 安装graphviz2.38[http://www.graphviz.org/Download_windows.php](http://www.graphviz.org/Download_windows.php)到D盘program files
2. 安装VS2010到到D盘program files
```batch
powershell .\dependency.ps1 -sw_path "软件的路径"
```
比如说我要分析腾讯TM，那么`powershell .\dependency.ps1 -sw_path "D:\Program Files\Tencent\TM"`就OK啦


# 代码
## 获取目录下所有PE
```powershell
$get_pe_cmd = "dir /S /B /a-d-h-s `"$sw_path`" | findstr /I `".dll .exe`" > files.txt"
cmd /c "$get_pe_cmd"
```
其中`findstr /I`表示忽略大小写

## 拷贝mspdb100.dll
由于无法直接调用vs2010 command prompt，所以没有设置环境变量，在使用dumpbin的时候会提示缺少`mspdb100.dll`，这就需要把`mspdb100.dll`拷贝到dumpbin.exe所在的`vc_bin`目录下
```powershell
$vs_path="D:\Program Files\Microsoft Visual Studio 10.0"
copy-item "$vs_path\Common7\IDE\mspdb100.dll" "$vc_bin" -Force 
```
我的测试机是`x86 32位`，如果路径有变化，修改`$vs_path`即可

## graphviz画图
```powershell
$graph_dot="D:\Program Files\Graphviz2.38\bin\dot.exe"
$draw = "`"$graph_dot`"  -Tpng graph.txt > graph.png" 
cmd /c "$draw"
```
我的graphviz装在D盘，如果有变化，修改`$graph_dot`即可

## 通过dumpbin获取依赖
```powershell
$dump_cmd = "`"$dumpbin`" /dependents `"$line`" | findstr /I .dll | findstr /I /vi `"dump of file`" > $deptxt"
cmd /c "`"$dump_cmd`""
```

## 把依赖关系写入dot
```powershell
append "`"$pename`"[shape=box,fontname=consolas];"
append "`"$pename`"->{"
if ($bFound -eq 1)
{
    append "`"$depen`";"
}
append "};"
```

## graphviz画图
```powershell
$draw = "`"$graph_dot`" $graphtxt -Tpng  > dependency_graph.png" 
write-host $draw
cmd /c "$draw"

````

# 效果图
分析了一下腾讯TM
![](https://github.com/CodeJuan/pe_dependency/raw/master/dependency_graph11.png)


-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

