---
title: Java程序cpu过高查询办法
date: 2017-04-11 15:08:13
tags: java
---
最近开发Java 高并发的项目时，部署发现程序cpu过高，通过查询资料给出下面解决办法


----------


查看cpu过高的PID
```
top -u capaa
```
![这里写图片描述](http://img.blog.csdn.net/20170330223833593?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMzMxMDAyNQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

<!-- more -->
----------
查询进程里面的线程id,以及cpu使用率和线程运行时间
```
ps -mp 7790 -o THREAD,tid,time | sort -rn
```
![这里写图片描述](http://img.blog.csdn.net/20170330224104649?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMzMxMDAyNQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


----------
把线程id转成16进制以供jstack 去查看JAVA虚机的线程 DUMP

```
printf "%x\n" 17607 
```
![这里写图片描述](http://img.blog.csdn.net/20170330224312335?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMzMxMDAyNQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


----------
查看线程7790的运行情况
```
jstack 7790 |grep 44c7 -A 10
```
![这里写图片描述](http://img.blog.csdn.net/20170330224356430?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMzMxMDAyNQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

最后通过排查发现同事用了线程不安全的HashHMap导致程序死循环，最后改用cocurrentHashMap
