---
title: PostgreSQL 常用命令 使用
date: 2017-04-11 12:08:13
tags: PostgreSQL
---

#PostgreSQL 常用命令#

##**（一）用户实用程序**：##
----------

创建一个新的PostgreSQL的数据库（和SQL语句：CREATE DATABASE 相同） 
```
create db 
```


创建一个新的PostgreSQL的用户（和SQL语句：CREATE USER 相同） 

```
create user 
```

删除数据库 

```
drop db 
```
删除用户

```
drop user 
```

 将PostgreSQL数据库导出到一个脚本文件 
```
pg_dump 
```
将所有的PostgreSQL数据库导出到一个脚本文件 
```
pg_dump all 
```
从一个由pg_dump或pg_dumpall程序导出的脚本文件中恢复PostgreSQL数据库 
```
pg_restore 
```



##**（二）系统实用程序** ##

创建一个用于存储数据库的PostgreSQL数据目录，并创建预定义的模板数据库，template0和template1,生成共享目录表 catalog；此程序通常只在安装PostgreSQL时运行一次 
```
initdb 
```
 创建一个辅助的PostgreSQL数据库存储区域
```
 initlocation
```
PostgreSQL服务启停
```
pg_ctl  start    启动 PostgreSQL服务（service postgresql start相同）
pg_ctl  stop     停止 PostgreSQL服务
pg_ctl  restart  重启 PostgreSQL服务

```
显示PostgreSQL服务的内部控制信息 
```
pg_controldata
```


在数据库中的一些命令
```
template1=# \l 查看系统中现存的数据库 

template1=# \q 退出客户端程序psql 

template1=# \c 从一个数据库中转到另一个数据库中，如template1=# \c sales 从template1转到sales 

template1=# \dt 查看表 

template1=# \d 查看表结构 

template1=# \di 查看索引 数据库操作]======================== 
```
*创建数据库： 
```
create database [数据库名]; 
```
*查看数据库列表： 
```
\d 
```
*删除数据库： 
```
drop database [数据库名];  
```
创建表： 
```
create table ([字段名1] [类型1] <references 关联表名(关联的字段名)>;,[字段名2] [类型2],......<,primary key (字段名m,字段名n,...)>;); 
```
*查看表名列表： 
```
\d 
```
*查看某个表的状况： 
```
\d [表名] 
```
*重命名一个表： 
```
alter table [表名A] rename to [表名B]; 
```
*删除一个表： 
```
drop table [表名]; 
```



*在已有的表里添加字段： 

```
alter table [表名] add column [字段名] [类型]; 
```

*删除表中的字段： 

```
alter table [表名] drop column [字段名]; 
```

*重命名一个字段：  

```
alter table [表名] rename column [字段名A] to [字段名B]; 
```

*给一个字段设置缺省值：  

```
alter table [表名] alter column [字段名] set default [新的默认值]; 
```

*去除缺省值：  

```
alter table [表名] alter column [字段名] drop default; 
```

在表中插入数据： 

```
insert into 表名 ([字段名m],[字段名n],......) values ([列m的值],[列n的值],......); 
```

修改表中的某行某列的数据： 

```
update [表名] set [目标字段名]=[目标值] where [该行特征]; 
```

删除表中某行数据： 

```
delete from [表名] where [该行特征]; 
delete from [表名];--删空整个表 
```


对数据库进行清理、收回磁盘空间并更新统计信息，使用下面的命令就搞定！ 

```
vaccumdb -d sales -z 

-a 对所有的数据库操作 

-z 保证不断地删除失效的行，节约磁盘空间，将统计信息更新为最近的状态 
```

##**（三）PostgreSQL用户认证** ##
```
PostgreSQL数据目录中的pg_hba.conf的作用就是用户认证，可以在/var/lib/pgsql/data中找到。 
```
有以下几个例子可以看看： 

(1)允许在本机上的任何身份连接任何数据库 

```
TYPE DATABASE         USER     IP-ADDRESS    IP-MASK     METHOD 
```

local all             all                                 trust(无条件进行连接) 

(2)允许IP地址为192.168.1.x的任何主机与数据库sales连接 

```
TYPE DATABASE         USER     IP-ADDRESS    IP-MASK     METHOD 


host sales            all      192.168.1.0    255.255.255.0 ident sameuser(表明任何操作系统用户都能够以同名数据库用户进行连接) 
```
**示例**

> **(1)进入PostgreSQL高级用户** 

>**(2)启用客户端程序，并进入template1数据库** 


>`psql template1` 


>**(3)创建用户** 


>`template1=# CREATE USER hellen WITH ENCRYPED PASSWORD'zhenzhen'` 


>**(4)因为设置了密码，所以要编辑pg_hba.conf，使用户和配置文件同步。在原有记录上面添加md5 **


>local    all    hellen      md5 


>**(5)使用新用户登录数据库** 


>`template1=# \q` 


>`psql -U hellen -d template1` 


>在一个数据库中如果要切换用户，要使用如下命令：
> `template1=# \!psql -U tk -d template1` 



创建一个用户组： 

```
sales=# CREATE GROUP sale; 
```

添加几个用户进入该组 

```
sales=# ALTER GROUP sale ADD USER sale1,sale2,sale3; 
```

授予用户级sale针对表employee和products的SELECT权限 

```
sales=# GRANT SELECT ON employee,products TO GROUP sale; 
```

在sale中将用户user2删除 

```
sales=# ALTER GROP sale DROP USER sale2; 
```


##**（四）备份数据库 ** ##


可以使用pg_dump和pg_dumpall来完成。比如备份sales数据库： 

```
pg_dump sales>/home/tk/pgsql/backup/1.bak 
```