---
title: hive 2.1.1 部署安装
date: 2017-04-20 21:08:13
tags: hadoop hive
cover: /img/hive.jpg
---

安装hive 之前，要保证hadoop安装成功，本教程对应的是hadoop版本为2.6.4,hive 版本为 2.1.1，默认情况下，Hive元数据保存在内嵌的 Derby 数据库中，只能允许一个会话连接，只适合简单的测试。为了支持多用户多会话，则需要一个独立的元数据库，我们使用 MySQL 作为元数据库
#一、下载Hive
下载地址：https://mirrors.tuna.tsinghua.edu.cn/apache/hive/
#二、mysql配置
**1、下载mysql源安装包**
```
wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
```
**2、安装mysql源**
```
yum localinstall mysql57-community-release-el7-8.noarch.rpm
```
**3、安装mysql**
此过程有点缓慢，请耐心等待
```
yum install mysql-community-server
```
**4、配置开机启动**

```
systemctl enable mysqld
```
**5、修改root默认密码**

```
cat /var/log/mysqld.log
```
找到这句：

```
2017-04-19T14:35:14.944334Z 1 [Note] A temporary password is generated for root@localhost: Nf:pGZk1MfB7
```
Nf:pGZk1MfB7 为root的初始化密码，然后登录 mysql 修改密码

```
mysql -uroot -p

```
执行下面sql

```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; 
```

> 注意：mysql5.7默认安装了密码安全检查插件（validate_password），
> 默认密码检查策略要求密码必须包含：大小写字母、数字和特殊符号，并且长度不能少于8位。 否则会提示ERROR 1819 (HY000):
> 
> **Your password does not satisfy the current policy requirements**
> 错误详细配置密码策略去看官网：
> http://dev.mysql.com/doc/refman/5.7/en/validate-password-options-variables.html#sysvar_validate_password_policy

>关闭策略
>如果不需要密码策略，添加/etc/my.cnf文件中添加如下配置禁用即可：
validate_password = off

重新启动mysql服务使配置生效：

```
systemctl restart mysqld
```

**6、添加远程登录用户**

```
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
```

重载授权表：

```
mysql>FLUSH PRIVILEGES;
```

创建 hive 数据库

```
mysql>create database hive;
```


退出mysql数据库：

```
mysql>exit
```

#三、安装hive
**1、配置hive环境变量**
修改环境变量
```
vi .bash_profie
```
加入hive相关的环境变量
```
export HIVE_HOME=/home/hadoop/hive-2.1.1
export PATH=$HIVE_HOME/bin:$HIVE_HOME/conf:$PATH
```
加载环境变量
```
source .bash_profile 
```

**2、修改Hive的配置文件**
到hive 配置文件目录中
```
cd /home/hadoop/hive-2.1.1/conf
```
把初始化的文件 复制一份出来 并且改名

```
cp hive-env.sh.template hive-env.sh
cp hive-default.xml.template hive-site.xml
cp hive-log4j2.properties.template hive-log4j2.properties
cp hive-exec-log4j2.properties.template hive-exec-log4j2.properties
```

**3、修改hive-env.sh**

```
export JAVA_HOME=/usr/lib/jdk1.7.0_79    ##Java路径
export HADOOP_HOME=/home/hadoop/hadoop   ##Hadoop安装路径
export HIVE_HOME=/home/hadoop/hive-2.1.1    ##Hive安装路径
export HIVE_CONF_DIR=/home/hadoop/hive-2.1.1/conf    ##Hive配置文件路径
```

在hdfs 中创建下面的目录 ，并且授权

```
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /user/hive/tmp
hdfs dfs -mkdir -p /user/hive/log
hdfs dfs -chmod -R 777 /user/hive/warehouse
hdfs dfs -chmod -R 777 /user/hive/tmp
hdfs dfs -chmod -R 777 /user/hive/log
```

**4、修改hive-site.xml**

将 hive-site.xml 文件中以下几个配置项的值设置成上一步中创建的几个路径。

```
<property>
    <name>hive.exec.scratchdir</name>
    <value>/user/hive/tmp</value>
</property>
<property>
    <name>hive.metastore.warehouse.dir</name>
    <value>/user/hive/warehouse</value>
</property>
<property>
    <name>hive.querylog.location</name>
    <value>/user/hive/log</value>
</property>
```
需要在 hive-site.xml 文件中配置 MySQL 数据库连接信息。

```
<property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://localhost:3306/hive?createDatabaseIfNotExist=true&amp;characterEncoding=UTF-8&amp;useSSL=false</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.jdbc.Driver</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>root</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>root</value>
  </property>
```

**5、创建tmp文件**

```
 mkdir /home/hadoop/hive-2.1.1/tmp
```


> 在配置文件 hive-site.xml 里面
> 
把**{system:java.io.tmpdir}** 改成  **/home/hadoop/hive-2.1.1/tmp/**

> 把 **{system:user.name}**   改成 **{user.name}**


**5、配置jdbc驱动包**
mysql的jdbc 驱动包下载地址：

下载完成后把mysql-connector-java-5.1.30-bin.jar 然后放入 $HIVE_HOME/lib 目录下

**6、初始化hive**
从 Hive 2.1 版本开始, 我们需要先运行 schematool 命令来执行初始化操作。

```
schematool -dbType mysql -initSchema
```

看到schemaTool completed 则初始化完成
 检测hive 是否成功 直接在命令行输入hive即可
```
hive
```
