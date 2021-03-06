---
title: pandoc---markdown转换利器 
date: 2015-03-10 23:30:09
categories:
- code
tags: 
- pandoc
- html
- slide
mathjax: true
description: 
---

# 背景

项目要发布一堆开发文档，并支持快速更新。经过我的不断安利，领导同意用markdown（*感觉好有成就感啊*）。
经过一番探索，决定采用[pandoc](http://johnmacfarlane.net/pandoc/index.html)，因为功能真的很强大，请看官网介绍


> If you need to convert files from one markup format into another, pandoc is your swiss-army knife. Pandoc can convert documents in markdown, reStructuredText, textile, HTML, DocBook, LaTeX, MediaWiki markup, TWiki markup, OPML, Emacs Org-Mode, Txt2Tags, Microsoft Word docx, EPUB, or Haddock markup to
    - HTML formats: XHTML, HTML5, and HTML slide shows using Slidy, reveal.js, Slideous, S5, or DZSlides.
    - Word processor formats: Microsoft Word docx, OpenOffice/LibreOffice ODT, OpenDocument XML
    - Ebooks: EPUB version 2 or 3, FictionBook2
    - Documentation formats: DocBook, GNU TexInfo, Groff man pages, Haddock markup
    - Page layout formats: InDesign ICML
    - Outline formats: OPML
    - TeX formats: LaTeX, ConTeXt, LaTeX Beamer slides
    - PDF via LaTeX
    - Lightweight markup formats: Markdown, reStructuredText, AsciiDoc, MediaWiki markup, DokuWiki markup, Emacs Org-Mode, Textile
    - Custom formats: custom writers can be written in lua.

<!--more-->

此后再折腾了一下，打算不转PDF，还是转换成html比较好。
优势在于

1. html浏览起来很方便，不需要装其他软件。

2. 转PDF要安装引擎[MiKTeX](http://miktex.org/)。

3. 转换速度快，即时反馈。

4. pandoc对中文的支持还是不够理想。

5. 随时可以发布。


# 下载安装

[官网](http://johnmacfarlane.net/pandoc/installing.html)


[release](https://github.com/jgm/pandoc/releases)


当前最新版是1.13.2。

学习资料
[神器Pandoc的安装与使用](http://zhouyichu.com/misc/Pandoc.html)
[tzengyuxio](https://github.com/tzengyuxio/pages)



# 转html

写了一个脚本，封装了一下，另外加了点css，代码放在[https://github.com/CodeJuan/pandoc](https://github.com/CodeJuan/pandoc)
下一步计划把slide也美化一下，以后就可以抛弃PPT了。

``` bat  
::脚本内容
pandoc -s --self-contained -c style.css "%1" -o "%2.html" --toc
```  

- `--self-contained`表示将图片嵌入到页面
- `-c` 表示使用style.css，用的是
- `--toc`表示生成目录(table of contents)

## 调用方法

``` bat  
::脚本内容
html.bat "input_file_name" "output_name"
```  

# 改css

看下效果，感觉比较一般，打算再修改一下

## 修改前的效果


![修改前的效果](https://raw.githubusercontent.com/CodeJuan/codejuan.github.io/master/images/blog/pandoc/css_origin.png)


## 修改后的效果

主要修改点

1. body字体，代码字体

2. body居中

3. 图片居中

4. table加border


![修改后的效果](https://raw.githubusercontent.com/CodeJuan/codejuan.github.io/master/images/blog/pandoc/css_new.png)




##　详情请查看
[css提交记录](https://github.com/CodeJuan/pandoc/blob/master/style.css)



-----------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

