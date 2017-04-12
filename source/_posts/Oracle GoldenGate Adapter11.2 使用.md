---
title: Oracle GoldenGate Adapter11.2 使用
date: 2017-04-11 12:08:13
tags: ogg
---


Oracle GoldenGate Adapter11.2 使用
================================



**1、下载解压GoldenGate Adapter**
----------------------------
[Oracle GoldenGate Adapter下载 ](http://www.oracle.com/us/products/middleware/data-integration/goldengate/overview/index.html)

[官方文档](http://docs.oracle.com/goldengate/gg121211/gg-adapter/index.html)

下载解压后文件目录介绍：
![目录介绍](http://img.blog.csdn.net/20161012134924675)

**2、生成source Def 配置文件**
-------------------

生成source Def 配置文件（.def文件可以用11g的ogg生成，生成完成后复制到GoldenGate Adapter目录下的/dirdef目录即可）
编辑参数文件 source.prm，放在dirprm目录下：

```
defsfile ./dirdef/source.def,purge
userid odc,password odc
table odc.*;
```

进入安装目录运行如下命令:
```
defgen paramfile ./dirprm/source.prm reportfile ./dirrpt/source.rpt
```
**3、编写java程序**
----------

在./ggjava新建java文件，命名为SampleHandler.java (具体的java api 查看/ggjava/docs/里面的文档)




```
public class SampleHandler extends AbstractHandler {    
    private final Logger    logger        = LoggerFactory.getLogger(SampleHandler.class);
    @Override
    public void init(DsConfiguration conf, DsMetaData metaData) {

        logger.info("init!");
         return Status.OK;
    }

    @Override
    public Status transactionCommit(DsEvent e, DsTransaction tx) {

            logger.info("transactionCommit!");
             return Status.OK;

    }

    @Override
    public void destroy() {
        logger.info("destroy redis!");
        jedis.close();
     }

    @Override
    public String reportStatus() {
        return "status report...===";
    }  
```
    
   


**4、编译java程序**
----------

创建完java 文件后 在 /ggjava下运行下面命令（最好用绝对路径）：
```
javac -d （E:/ggs_Adapters_Windows_x64，程序的主目录）/dirprm -classpath （E:/ggs_Adapters_Windows_x64，程序的主目录）/ggjava/ggjava.jar SampleHandler.java
```
运行完命令后再 ./dirprm里面生成了一个/sample/SampleHandler.class 文件

**5、配置JavaAdapter的配置文件**
--------------------

**1、在dirprm 下新建一个javaue.prm 的文件 ，输入如下配置 保存**
```
Extract JAVAUE
SourceDefs dirdef/source.def
getEnv (JAVA_HOME)
getEnv (LD_LIBRARY_PATH)
getEnv (PATH)
-- windows:
 CUserExit ggjava_ue.dll CUSEREXIT PassThru IncludeUpdateBefores
-- unix/linux:
--CUserExit libggjava_ue.so CUSEREXIT PassThru IncludeUpdateBefores
GetUpdateBefores
Table odc.*;
```
**2、在dirprm 下新建一个javaue3.properties 的文件 ，输入如下配置 保存**
```
gg.handlerlist=sample.SampleHandler
java.naming.provider.url=tcp://localhost:61616
java.naming.factory.initial=org.apache.activemq.jndi.ActiveMQInitialContextFactory
gg.handler.sample.type=sample.SampleHandler
goldengate.userexit.timestamp=utc
goldengate.userexit.nochkpt=true
```

**六、配置ggsci**
---------

进入 根目录 ，运行 ggsci 程序 (.\dirdat\aa为ogg 生成的trail 文件，可以用ogg10版本、11版本、12版本的程序 生成2进制的trail文件到oggadapter的目录/dirdat/中)
```
add extract javaue, extTrailSource .\dirdat\aa
start javaue
```
**小结：**
---

由于ogg的版本更新 目前oracle官网上只有Oracle GoldenGate Application Adapters 12.1.2.1的版本，下载后解压后 复制 ggjava文件夹 及 ggjava_ue.dll文件到ogg 12版本的根目录中，就可以在ogg12版本的ggsci中运行Application Adapters 配置方法相同
linux 环境下 要加入下面到环境变量里
```
export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server:$LD_LIBRARY_PATH
```