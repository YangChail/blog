---
title: hadoop编译
date: 2017-04-11 12:08:13
tags: hadoop
---
**1、安装jdk 配置环境变量**

**2、安装maven 配置环境变量**

下载地址  http://maven.apache.org/download.cgi 根据需要下载适合自己的版本，我选择的是3.3.3
解压   tar -zxvf apache-maven-3.3.3-bin.tar.gz  到  /usr/soft
配置maven环境变量

```
vi ~/.bash_profile
 
export MAVEN_HOME=/home/hadoop/app/apache-maven-3.3.9
export PATH=.:$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin

source ~/.bash_profile
```
 检验是否安装成功
```
mvn -version
```


**3、安装依赖库** 

```
yum install g++ autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev gcc*
```

**4、root用户下安装protobuf** 

下载地址：http://download.csdn.net/detail/linlinv3/9203869

解压  protobuf
```
cd 到 protobuf目录里面
./configure
make
make install
```

输入  protoc --version 验证是否成功，出现 libprotoc 2.5.0证明成功！

**5、编译Hadoop**

下载hadoop 地址：http://hadoop.apache.org/releases.html  

```
tar -zxvf hadoop-2.7.3-src.tar.gz
```

进入源码目录执行

```
cd hadoop-2.7.3-src
mvn clean package -Pdist,native -DskipTests -Dtar 
```

等待结果......经过漫长的等待。如果看到如下结果证明编译成功！


5、查看编译后的文件
查看下面的文件native


编译成功！