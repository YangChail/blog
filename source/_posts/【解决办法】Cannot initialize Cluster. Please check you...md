---
title: 【解决办法】Cannot initialize Cluster. Please check you...
date: 2017-04-11 12:08:13
tags: hadoop
---

eclipse 运行 hadoop mapreduce 程序 提交到集群运行 报错：
---------------------------------


```
Cannot initialize Cluster. Please check your configuration for mapreduce.framework.name and the correspond server addresses.  
  
```

**解决办法：**
在maven 中添加如下依赖，自动下载hadoop-mapreduce-client-jobclient.jar ，即可解决
```
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-mapreduce-client-jobclient</artifactId>
        <version>${hadoop.version}</version>
        <scope>provided</scope>
    </dependency>
```