---
title: 【解决办法】Hadoop安装完后，启动时报Error- JAVA_HOME is not set and could not be found.
date: 2017-04-11 12:08:13
tags: hadoop
---

Hadoop安装完后，启动时报Error: JAVA_HOME is not set and could not be found.


解决办法：
        修改/etc/hadoop/hadoop-env.sh中设JAVA_HOME。
        应当使用绝对路径。
        export JAVA_HOME=$JAVA_HOME                  //错误，不能这么改
        export JAVA_HOME=/usr/java/jdk1.6.0_45        //正确，应该这么改