---
title: Oracle GoldenGate Adapter11.2 取trail  文件 中文乱码问题
date: 2017-04-11 12:08:13
tags: ogg
---

#**Oracle GoldenGate Adapter11.2 取trail  文件 中文乱码问题**

 源库中的字符集为：
![这里写图片描述](http://img.blog.csdn.net/20161214163613058?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMzMxMDAyNQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

Adapter 程序取trail 文件的时候，对于有中文的列的值都是显示乱码，根据 Adapter 官方文档有个参数设置

![这里写图片描述](http://img.blog.csdn.net/20161214163811356?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMzMxMDAyNQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

在properties 文件中加入goldengate.userexit.utf8mode=true，Adapter 会把所有的值都转成utf-8，如果设置成false 则按系统的字符集
