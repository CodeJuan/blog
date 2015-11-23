---
title: 通过python将json转换成lua
date: 2015-11-23 00:00:00
categories:
- code
tags: 
- json
- lua
- python
mathjax: true
description: 
---

# 背景

某需求要将json转换成lua代码，同事们的做法是人肉翻译，肉眼读json，然后一条条拷贝到lua，如果遇到嵌套多的情况，一不小心就搞错了。
即使没有出错，顺利翻译完成，一条简单的json将耗时半小时。如果是100条，将浪费50个小时，太恐怖了。

我在翻译了一次之后，实在是无法接受，于是想通过python来解析json，然后按照格式生成lua代码，也就是`用代码写代码`。
这样可以避免机械劳动，不再浪费生命，可以从原来的半小时减少到1分钟，并且不容易出错。


<!--more-->

--------------------------------------------------------------

# 效果
原始的json文件
```json
{
    "glossary": {
        "title": "example glossary",
		"GlossDiv": {
            "title": "S",
			"GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}
```

转换成lua的样子
```lua
local msg = {}
local glossary = {}
local GlossDiv = {}
local GlossList = {}
local GlossEntry = {}
local GlossDef = {}
GlossDef.GlossSeeAlso = {"GML","XML"}
GlossDef.para = "A meta-markup language, used to create markup languages such as DocBook."
GlossEntry.GlossDef = GlossDef
GlossEntry.GlossSee = "markup"
GlossEntry.Acronym = "SGML"
GlossEntry.GlossTerm = "Standard Generalized Markup Language"
GlossEntry.Abbrev = "ISO 8879:1986"
GlossEntry.SortAs = "SGML"
GlossEntry.ID = "SGML"
GlossList.GlossEntry = GlossEntry
GlossDiv.GlossList = GlossList
GlossDiv.title = "S"
glossary.GlossDiv = GlossDiv
glossary.title = "example glossary"
msg.glossary = glossary

```


# 思路
- simplejson解析原始的json文件
- 识别出array，subitem，alue
- subitem递归下去，然后一层一层往上汇总
- 根据规律分别组装出lua代码
- 输出

-----------------------------

# 步骤

### simplejson
先要安装simplejson

```sh
sudo pip install simplejson
```

### 分析value
```python
def printValue(key, value, prefix, substring):
    left = '{}{}{}'.format(prefix, key, ' = ')
    right = ''
    if 'None' in substring:
        right = 'gLuaNULL.null'
    elif 'True' in substring:
        right = 'true'
    else:
        right = '"{}"'.format(value)
    print '{}{}'.format(left, right)
```
根据不同的值，转换成lua的结果。例如`None`对应的是`gLuaNULL.null`，`True`对应`true`,普通的值就等于'"json中的值"'
例如
```json
"GlossEntry": {
		"ID": "SGML"
	}
```
转换成
```lua
GlossEntry.ID = "SGML"
```

### 分析array
```json
"GlossSeeAlso": ["GML", "XML"]
```
类似于这样的，就要转换成
```lua
GlossDef.GlossSeeAlso = {"GML","XML"}
```

python代码如下
```python
def printArray(key, value, prefix):
    elements = '{'
    for i in value:
        elements += '"{}",'.format(i)
    elements = elements[:-1]
    elements += '}'
    print '{}{}{}{}'.format(prefix, key, ' = ', elements)
```

### 分析subitem
需要用到递归，将item不停的传递下去，直到完成
不多解释了，直接看代码吧
```python
def printSubItem(key, value, prefix):
    #print '{}11111111111'.format(key)
    local = 'local ' + key + ' = {}'
    print local
    parseJson(value, key+'.')
    print '{}{} = {}'.format(prefix, key, key)
    #print '{}22222222222'.format(key)
```

-----------------------------------

# 代码链接
放在[https://github.com/CodeJuan/python_convert_json2lua](https://github.com/CodeJuan/python_convert_json2lua)




----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

