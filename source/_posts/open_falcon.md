---
title: 尝试open falcon
date: 2015-11-29 00:00:00
categories:
- code
tags: 
- ops
- monitoring
mathjax: true
description: 
---

# 背景

尝试一下小米的open falcon

<!--more-->

--------------------------------------------------------------

# 步骤
```sh
sudo yum install -y redis
sudo yum install -y mysql-server

export HOME=/home/work
export WORKSPACE=$HOME/open-falcon
mkdir -p $WORKSPACE
cd $WORKSPACE

git clone https://github.com/open-falcon/scripts.git
cd ./scripts/
mysql -h localhost -u root -p < db_schema/graph-db-schema.sql
mysql -h localhost -u root -p < db_schema/dashboard-db-schema.sql

mysql -h localhost -u root -p < db_schema/portal-db-schema.sql
mysql -h localhost -u root -p < db_schema/links-db-schema.sql
mysql -h localhost -u root -p < db_schema/uic-db-schema.sql


DOWNLOAD="https://github.com/XiaoMi/open-falcon/releases/download/0.0.5/open-falcon-0.0.5.tar.gz"
cd $WORKSPACE

mkdir ./tmp
#下载
wget $DOWNLOAD -O open-falcon-latest.tar.gz

#解压
tar -zxf open-falcon-latest.tar.gz -C ./tmp/
for x in `find ./tmp/ -name "*.tar.gz"`;do \
    app=`echo $x|cut -d '-' -f2`; \
    mkdir -p $app; \
    tar -zxf $x -C $app; \
done
```



----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/

