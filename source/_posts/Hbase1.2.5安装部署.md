---
title: Hbase 1.2.5 安装部署
date: 2017-05-02 22:08:13
tags: hadoop,hbase,数据库
cover: /img/hbase.jpg
---

#一、安装zookeeper
1、下载zookeeper 
地址：https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/stable/zookeeper-3.4.10.tar.gz
2、解压软件 
```
tar vfx zookeeper-3.4.10.tar.gz
```
3、创建log和data文件夹

```
mkdir zookeeper-3.4.10/log
mkdir zookeeper-3.4.10/data
```
4、修改配置文件

```
cd  zookeeper-3.4.10/conf
touch zoo.cfg
```

5、填入下面配置项，地址可以根据自己的机器集群环境配置 

> 注：其中的master、node1、node2为我配置的机器的机器名

```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/home/hadoop/zookeeper-3.4.10/data
dataLogDir=/home/hadoop/zookeeper-3.4.10/log
clientPort=2181
server.1=master:2888:3888
server.2=node1:2888:3888
server.3=node2:2888:3888
```


6、用scp 命令把配置好的zookeeper 程序分发到各个机器上

```
scp  zookeeper-3.4.10 hadoop@node1:/home/hadoop
scp  zookeeper-3.4.10 hadoop@node2:/home/hadoop
```
7、创建一个myid文件，每个机器的数字不同，根据配置文件对应的数字分别填入myid 文件中
```
cd zookeeper-3.4.10/data
echo 1 > myid
```

8、到每台集群机器上分别启动zookeeper

```
cd zookeeper-3.4.10/bin
./zkServer.sh start
```
9、查看zookeeper 运行状态，若没有报错则运行成功

```
./zkServer.sh status
```
#二、安装配置Hbase
1、下载hbase
地址：https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/stable/hbase-1.2.5-bin.tar.gz
2、解压软件

```
 tar vfx hbase-1.2.5-bin.tar.gz 
```

3、添加环境变量

```
export HBASE_HOME=/home/hadoop/hbase-1.2.5
export PATH=$HBASE_HOME/bin:$PATH
```
应用环境变量

```
source .bash_profile
```
4、创建hbase的临时文件tmp文件夹

```
mkdir /hbase-1.2.5/tmp
```

5、到 /hbase-1.2.5/conf里配置hbase的配置文件



> **配置hbase-env.sh**

```
export JAVA_HOME=/java/jdk1.8.0_101  #Java的环境
export HBASE_CLASSPATH=/home/hadoop/hadoop/etc/hadoop #hadoop配置文件的地址
```

> **配置hbase-site.xml**

```
<configuration>
	<property>
		<name>hbase.rootdir</name>
		<value>hdfs://master:9000/hbase</value>
	</property>
	<property>
		<name>hbase.cluster.distributed</name>
		<value>true</value>
	</property>
	<property>
		<name>hbase.tmp.dir</name>
		<value>/home/hadoop/hbase-1.2.5/tmp</value>
	</property>
	<property>
		<name>hbase.zookeeper.quorum</name>
		<value>master,node1,node2</value>
	</property>
	<property>
		<name>hbase.zoopkeeper.property.dataDir</name>
		<value>/home/hadoop/zookeeper-3.4.10/data</value>
	</property>
</configuration>
```

> **配置regionservers **

```
master
node1
node2
```
6、用scp 命令把配置好的hbase程序分发到各个机器上

```
scp  hbase-1.2.5 hadoop@node1:/home/hadoop
scp  hbase-1.2.5 hadoop@node2:/home/hadoop
```

7、运行hbase

```
hbase-1.2.5/bin/start-hbase.sh 
```

8、测试，查看web 运行情况
地址：http://master:16030





