---
title: SSH 免密登陆解析
date: 2017-04-11 12:08:13
tags: ssh
---


**一、ssh工作流程图**
----------


![这里写图片描述](http://img.blog.csdn.net/20161019233917333)


ssh 无密码登录要使用公钥与私钥。linux下可以用ssh-keygen生成公钥/私钥对。

机器配置
A：192.168.1.1 
B：192.168.1.2



**二、配置过程**
------


**1.    在A机下生成公钥/私钥对。**

```
[yc@A ~]$ ssh-keygen -t rsa -P ''
```
或者
```
[yc@A ~]$ ssh-keygen 
```

注：-P表示密码，-P '' 就表示空密码，也可以不用-P参数，这样就要三车回车，用-P就一次回车。它在/home/chenlb下生成.ssh目录，.ssh下有id_rsa和id_rsa.pub。


----------


**2.   把A机下的id_rsa.pub复制到B机下**，
在B机的.ssh/authorized_keys文件里，我用scp复制。
 

```
[yc@A ~]$ scp .ssh/id_rsa.pub yc@192.168.1.2:/home/yc/id_rsa.pub 


```
由于还没有免密码登录的，所以要输入密码。
```
[yc@A ~]$ yc@192.168.1.2's password:
```


----------


**3.  B机把从A机的id_rsa.pub（公钥）添加到.ssh/authorzied_keys（授权文件）文件里。**
注：authorzied_keys在我们home目录下的.ssh文件夹内，如果没有的话可以创建一个authorized_keys文件

```
[yc@B ~]$ cat id_rsa.pub >> .ssh/authorized_keys
```

授权authorized_keys的权限要是600。
```
[yc@B ~]$ chmod 600 .ssh/authorized_keys
```


----------


**4.  A机登录B机。**

```
[yc@A ~]$ ssh 192.168.1.2

```



第一次登录是时要你输入yes。现在A机可以无密码登录B机了。若想让A，B机无密码互登录，那B机以上面同样的方式配置即可。

