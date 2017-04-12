---
title: 源码方式安装postgresql
date: 2017-04-11 12:08:13
tags: ogg
---

**源码方式安装postgresql**
------

**1.1、软件下载**
```
在root 用户下
cd /usr/local/src/
wget https://ftp.postgresql.org/pub/source/v9.6.1/postgresql-9.6.1.tar.gz
```

**1.2、安装依赖包**

```
yum install -y perl-ExtUtils-Embed readline-devel zlib-devel pam-devel libxml2-devel libxslt-devel openldap-devel  python-devel gcc-c++ openssl-devel cmake
```

**1.3、解压安装包** 

```
tar vfx postgresql-9.6.1.tar.gz
```

**1.4、配置编译选项**

```
cd postgresql-9.6.1
./configure --prefix=/usr/local/src/postgresql-9.6.1 --with-perl --with-python --with-libxml --with-libxslt 
```

**1.5、编译**
```
gmake
gmake install
安装PG插件
cd /usr/local/src/postgresql-9.6.1/contrib
gmake
gmake install
```


**1.6、加载动态库**
```
echo "/usr/local/src/postgresql-9.6.1/lib" >> /etc/ld.so.conf.d/pgsql.conf
ldconfig
```
**1.7、创建用户postgres**
```
useradd postgres
echo "postgres"|passwd --stdin postgres
```
**1.8、创建PG数据目录（在初始化的时候，看提示添加超级用户的密码）**
```
mkdir -p /data/pg/data
chown -R postgres:postgres /data/pg
su - postgres
/usr/local/src/postgresql-9.6.1/bin/initdb --no-locale -U postgres -E utf8 -D /data/pg/data -W
```
**1.9、配置运行环境变量（方便管理）**
```
到 root  用户下vi /etc/profile
复制下面代码：
PGDATA=/data/pg/data
PGHOST=127.0.0.1
PGDATABASE=postgres
PGUSER=postgres
PGPORT=5432
PATH=/usr/local/src/postgresql-9.6.1/bin:$PATH
export PATH
export PGDATA PGHOST PGDATABASE PGUSER PGPORT
```
**1.10、配置运行环境变量（方便管理）**
```
source /etc/profile
```

**1.11、postgresql服务管理**
```
启动：
pg_ctl start -D /data/pg/data
重启：
pg_ctl restart -D /data/pg/data
停止：
pg_ctl stop -D /data/pg/data
强制重启：
pg_ctl restart -D /data/pg/data -m f
强制停止：
pg_ctl stop -D /data/pg/data -m f
加载配置：
pg_ctl reload -D  /data/pg/data
显示服务状态：
pg_ctl status -D  /data/pg/data
```

**1.12、配置开机启动**

a.复制启动脚本
```
到root用户下
cp /usr/local/src/postgresql-9.6.1/contrib/start-scripts/linux /etc/init.d/postgresql
```
b.设置可执行
```
chmod +x /etc/init.d/postgresql
```
c.vi /etc/init.d/postgresql
```
把PGDATA改成PGDATA=/data/pg/data
把prefix 改成prefix =/usr/local/src/postgresql-9.6.1
```

d.加入开机启动
```
chkconfig postgresql on
```

**1.13、管理PG服务时也可以直接用上面启动脚本**
```
启动：service postgresql start
停止：service postgresql stop
重启：service postgresql restart
加载：service postgresql reload
状态：serivce postgresql status
```

**1.14、测试**
```
psql -h 127.0.0.1 -U postgres -p 5432 -d postgres -W
（-d 指定数据库 ,-W 输入密码 , -U 指定用户,-p 指定端口,-h 指定IP）
```

**1.15、配置所有用户连接**
```
修改/var/lib/pgsql/data/postgresql.conf
listen_addresses = '*'     //监听所有ip的连接，默认是本机  
port = 5432             //这个不开也行，默认就是5432端口  
修改/var/lib/pgsql/data/pg_hba.conf
host    all         all         0.0.0.0/0             md5  
```