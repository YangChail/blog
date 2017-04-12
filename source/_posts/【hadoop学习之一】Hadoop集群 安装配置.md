---
title: 【hadoop学习之一】Hadoop集群 安装配置
date: 2017-04-11 12:08:13
tags: hadoop
---




#**（一）环境准备**#
##**1.机器准备**##
>ps:以下使用的机器是自己搭建的虚拟机，操作系统是CentOS 6.7版本,内存2G,Cpu双核
###**(1).机器IP 配置**

集群中包括3个节点：1个Master，2个slave，节点之间局域网连接，可以相互ping通，节点IP地址分布如下：
| 机器名 | ip地址 | 用途
| ------------- |-------------|-------------|
| master | 192.168.78.128 | NameNode
| slave1 | 192.168.78.129 | DataNode
| slave2 | 192.168.78.130 |DataNode

###**(2).修改主机名**

分别更改3台主机的主机名，此处仅以NameNode为例：

```
[root@localhost~]   vi /etc/sysconfig/network
```
分别修改三个机器的主机名master ，slave1，slave2，如master 那台机器配置
```		
NETWORKING=yes
HOSTNAME=master
```
修改后重启机器
###**(3).修改host**
分别配置3台主机的hosts文件：

```
[root@master ~]  vi /etc/hosts
```

将以下代码加入到hosts中：

```
192.168.78.128 master
192.168.78.129 slave1
192.168.78.130 slave2
```

###**(4).关闭防火墙**
初学安装建议关闭系统的防火墙，关闭方法如下
```
[root@master ~] service iptables stop 
```
###**(5).创建hadoop用户**
```
[root@master ~] useradd hadoop //创建hadoop用户
[root@master ~] passwd hadoop //修改hadoop密码
```

----------
##**2.软件准备**
###**(1).java 环境**
JDK版本：1.7

下载地址：http://www.oracle.com/technetwork/java/javase/downloads/index.html
###**(2).hadoop下载** 

Hadoop版本：2.6.4

下载地址：https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-2.6.4/

----------

##**3.无密码访问SSH**

> Hadoop运行过程中需要管理远端Hadoop守护进程，在Hadoop启动以后，NameNode是通过SSH（Secure
> Shell）来启动和停止各个DataNode上的各种守护进程的。这就必须在节点之间执行指令的时候是不需要输入密码的形式，故我们需要配置SSH运用无密码公钥认证的形式，这样NameNode使用SSH无密码登录并启动DataName进程，同样原理，DataNode上也能使用SSH无密码登录到NameNode。

下面以Master 与Slave1两台服务器相互访问为例，其他Master 与Slave2，Slave1与Slave2，配置方法相同。
**(1).    在Master服务器下生成公钥和私钥对。**

```
[hadoop@master ~]$ ssh-keygen -t rsa -P ''
```
或者
```
[hadoop@master ~]$ ssh-keygen 
```

注：-P表示密码，-P '' 就表示空密码，也可以不用-P参数，这样就要**三次回车**，用-P就**一次回车**。它在/home/chenlb下生成.ssh目录，.ssh下有id_rsa和id_rsa.pub。

----------

**(2).   把Master服务器下的id_rsa.pub（公钥）复制到Slave1服务器的/home/hadoop目录下**，
id_rsa.pub在Master机的/home/hadoop/.ssh文件里，（.ssh文件夹是隐藏文件夹，使用ls -al命令可以看到），复制方法可以随便，下面选择用scp复制。
```
[hadoop@master ~]$ scp /home/hadoop/.ssh/id_rsa.pub hadoop@slave1:/home/hadoop/id_rsa.pub 
```
注：由于还没有免密码登录的，所以要输入密码。设置完无密码登陆之后，scp就不用密码登录了

----------

**(3).    在slave1服务器下生成公钥和私钥对。**

```
[hadoop@slave1 ~]$ ssh-keygen -t rsa -P ''
```

----------
**(4).  到Slave1服务器把从Master服务器的id_rsa.pub（公钥）添加到.ssh/authorzied_keys（授权文件）文件里。**
注：authorzied_keys在 ***/home/hadoop/.ssh*** （.ssh文件夹是隐藏文件夹，使用ls-al命令可以看到）

> 进入.ssh文件夹内，查看/home/hadoop/.ssh里面有没有authorized_keys文件，
>如果不存在authorized_keys，就生成文件
> ``` 
> [hadoop@slave1 ~]$ cat id_rsa.pub > /home/hadoop/.ssh/authorized_keys 
> ``` 
>如果存在authorized_keys文件，就追加文件 
> ``` 
> [hadoop@slave1 ~]$ cat id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
> ```

**注：授权authorized_keys的权限要是600。**
```
[hadoop@slave1 ~]$ chmod 600 /home/hadoop/.ssh/authorized_keys
```
----------

**(5).   把Slave1服务器下的id_rsa.pub（公钥）复制到Master服务器的/home/hadoop目录下**

```
[hadoop@slave1~]$ scp /home/hadoop/.ssh/id_rsa.pub hadoop@master:/home/hadoop/id_rsa.pub 
```
**(6).  到Master服务器把从Slave1服务器的id_rsa.pub（公钥）添加到.ssh/authorzied_keys（授权文件）文件里。**
> 进入.ssh文件夹内，查看/home/hadoop/.ssh里面有没有authorized_keys文件，
>如果不存在authorized_keys，就生成文件
> ``` 
> [hadoop@slave1 ~]$ cat id_rsa.pub > /home/hadoop/.ssh/authorized_keys 
> ``` 
>如果存在authorized_keys文件，就追加文件 
> ``` 
> [hadoop@slave1 ~]$ cat id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
> ```

授权authorized_keys的权限要是600。
```
[hadoop@slave1 ~]$ chmod 600 /home/hadoop/.ssh/authorized_keys
```
----------
**(7). 测试master服务器登录slave1 服务器。**

```
[hadoop@master ~]$ ssh slave1 

```

**(8). 测试slave1 服务器登录master服务器。**

```
[hadoop@slave1 ~]$ ssh master

```


>PS: 其他机器上述配置一样，配置完之后测试两台机器相互SSH无密码访问

#**（二）安装hadoop**

> 安装hadoop分为配置环境变量和修改软件配置两个步骤，下面以一台master 为例的配置方法,其他三台服务器配置方法相同。建议首先在一台服务器上配置hadoop配置文件，然后把一台的服务器上的配置好的软件（整个hadoop文件夹）直接复制到其他服务器上。


##**1.解压软件并修改文件夹名**
```
[hadoop@master ~] tar -zxvf /home/hadoop/hadoop-2.6.4.tar.gz
[hadoop@master ~] mv hadoop-2.6.4 hadoop

```
##**2.修改环境变量**
编辑用户环境变量配置文件
```
[hadoop@master ~]vi .bash_profile
```
加入下面内容
```
export HADOOP_HOME=/home/hadoop/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```
环境生效

```
[hadoop@master ~]source .bash_profile
```
##**3.创建tmp、names 、data文件夹**
```
[hadoop@master ~] mkdir /home/hadoop/hadoop/tmp
[hadoop@master ~] mkdir /home/hadoop/hadoop/names 
[hadoop@master ~] mkdir /home/hadoop/hadoop/data
```
##**4.修改Hadoop配置文件**
共有5个文件需要配置，如下：

```
core-site.xml 
hdfs-site.xml 
yarn-site.xml 
mapred-site.xml 
slaves
```

**(1).core-site.xml**（位置：/home/hadoop/hadoop/etc/hadoop/core-site.xml）
```
<configuration>
  <property>
    <name>fs.defaultFS</name>
        <value>hdfs://master:9000</value>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
        <value>/home/hadoop/hadoop/tmp</value>
  </property>
  <property>
     <name>io.file.buffer.size</name>
        <value>131072</value>
  </property>
</configuration>
```


**(2).hdfs-site.xml**（位置：/home/hadoop/hadoop/etc/hadoop/hdfs-site.xml）
```
<configuration>
<property>
    <name>dfs.namenode.name.dir</name>
    <value>/home/hadoop/hadoop/names</value>
</property>
<property>
    <name>dfs.datanode.data.dir</name>
    <value>/home/hadoop/hadoop/data</value>
</property>
<property> 
    <name>dfs.replication</name> 
    <value>3</value> 
</property> 
<property>
    <name>dfs.datanode.ipc.address</name>
    <value>0.0.0.0:50020</value>
</property>
<property>
    <name>dfs.datanode.http.address</name>
    <value>0.0.0.0:50075</value>
</property>
</configuration>
```


**(3).yarn-site.xml**（位置：/home/hadoop/hadoop/etc/hadoop/yarn-site.xml）
```
<configuration>
<property>
    <name>yarn.resourcemanager.hostname</name>
    <value>master</value>
</property>
<property>
    <name>yarn.nodemanager.aux-services</name> 
    <value>mapreduce_shuffle</value> 
</property>
</configuration>
```
**(4).mapred-site.xml**（位置：/home/hadoop/hadoop/etc/hadoop/mapred-site.xml）
```
<configuration>
<property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
</property>
</configuration>

```
**(5).slaves文件**（位置/home/hadoop/hadoop/etc/hadoop/slaves）

```
slave1
slave2
```

修改其他datanode服务器上的环境变量和master相同，然后复制/home/hadoop/hadoop文件夹到其他服务器上即可完成配置。


#**（三）测试**

1.**NameNode初始化**，这个操作只在第一次启动的时候执行。

```
[hadoop@master ~] hadoop namenode -format
```

2.**启动hadoop**
```
[hadoop@master ~] cd /home/hadoop/hadoop/sbin
[hadoop@master sbin]./start-all.sh 
```
3.**验证进程都启动完成**

(1).master 机服务器上的进程
```
[hadoop@master ~]jps

3067 SecondaryNameNode
2885 NameNode
3210 ResourceManager
19491 Jps
```
(2).slave服务器上的进程

```
[hadoop@master ~]jps
30955 Jps
30827 NodeManager
30714 DataNode
```

(3).浏览器查看hadoop及hdfs的运行状态

hadoop运行状态：http://192.168.78.128:8088/ 若在nodes 里面看到两个进程则部署成功

![hadoop运行状态](http://img.blog.csdn.net/20161204225547755)


hdfs运行状态：http://192.168.78.128:50070/

![hdfs运行状态](http://img.blog.csdn.net/20161204225606875)

#**（四）备注**

如果按照配置不能正常启动hadoop 可以去/home/hadoop/hadoop/logs文件夹查看hadoop启动的日志。

#**（五）常见错误处理**
[1、【解决办法】hadoop运行warn “util.NativeCodeLoader: Unable to load native-hadoop library for your platform”](http://blog.csdn.net/u013310025/article/details/52853941)


[2、【解决办法】Hadoop2.6.4 datanode 无法启动，错误：All specified directories are failed to load.](http://blog.csdn.net/u013310025/article/details/52796233)