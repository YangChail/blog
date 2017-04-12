---
title: 【解决办法】hadoop运行warn “util.NativeCodeLoader- Unable to load native-hadoop library for your platform”
date: 2017-04-11 12:08:13
tags: ogg
---

★★★ps:本片博文主要介绍如何解决 hadoop 在运行的时候出现如下 warn 的解决办法*★★★


----------
**资源链接：**

1. **hadoop官方文档所有版本地址：**
https://hadoop.apache.org/docs/
 

2. **hadoop Native Libraries 的官方介绍：**
http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/NativeLibraries.html


2. **2.6.x-native-64位包 下载地址：**
http://download.csdn.net/detail/u013310025/9657359

----------
Hadoop是使用Java语言开发的,但是有一些需求和操作并不适合使用java所以会引入了本地库（Native Libraries）的概念，通过本地库，Hadoop可以更加高效地执行某一些操作.
当我们在linux 输入   ***hdoop fs -ls /*** 去查看 hdfs 文件系统上的资源时会出现下面错误

错误详情：
```
WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
```


**方法一：**

在Hadoop的配置文件core-site.xml中可以设置是否使用本地库：（**Hadoop默认的配置为启用本地库**）

```
<property>
  <name>hadoop.native.lib</name>
  <value>false</value>
  <description>Should native hadoop libraries, if present, be used.</description>
</property>
```


----------


**方法二：**

直接下载编译好的2.6.x-native-64位包，替换原来的native包
**下载地址**：http://download.csdn.net/detail/u013310025/9657359

下载完后传到namenode 和datanode服务器上

**删除native 下的所有包：**
```
rm -rf  /[hadoopHome的目录]/lib/native/*
```
**解压文件：**
```
tar -xvf hadoop-native-64-2.6.0.tar /[hadoopHome的目录]/lib/native
```
**再试着执行查看文件命令**

```
hdoop fs -ls /
```
如果没有报错即替换成功，若还是报错重新启动所有进程