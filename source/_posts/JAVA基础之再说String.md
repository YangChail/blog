---
title: JAVA基础之再说String
date: 2017-07-20 22:08:13
tags: java
cover: /img/String.jpg
categories: 学习
---

# String
## 概念
String 类代表字符串。Java 程序中的所有字符串字面值（如 "abc" ）都作为此类的实例实现。字符串是常量；它们的值在创建之后不能更改。字符串缓冲区支持可变的字符串。因为 String 对象是不可变的，所以可以共享。

## 特性
### 1、不可变
一个字符串对象创建后它的值不能改变。  如果在程序中我们要平凡的操作一个字符串的累加，可以用StringBuffer效率高

```
String str1="hello";//创建一个对象hello，不会变；  
System.out.println(str1);  
str1+=" world!";//两个字符串对象粘粘，系统其实创建了一个新的对象，把Str1的指向改了，指向新的对象；hello就                     //变成了垃圾；  
System.out.println(str1);  
//如果一直这样创建会影响系统的效率；要频繁的改变字符串对象的值就用StringBuffer来描述；  
StringBuffer sb=new StringBuffer("[");  
sb.append("hehe");  
  
sb.append("]");//append();不会制造垃圾，真正在改sb的值；  
System.out.println(sb);
```
 ### 2、对象池
 创建一个Stirng对象，主要就有以下两种方式：  
  

```
String str1 = new String("abc");      
Stirng str2 = "abc";
```


虽然两个语句都是返回一个String对象的引用，但是jvm对两者的处理方式是不一样的。
（1）jvm会马上在heap中创建一个String对象，然后将该对象的引用返回  

（2）jvm首先会在内部维护的strings pool中通过String的 equels 方法查找是对象池中是否存放有该String对象，如果有，则返回已有的String对象给用户，而不会在heap中重新创建一个新的String对象；如果对象池中没有该String对象，jvm则在heap中创建新的String对象，将其引用返回给用户，同时将该引用添加至strings pool中。注意：使用第一种方法创建对象时，jvm是不会主动把该对象放到strings pool里面的，除非程序调用 String的intern方法。看下面的例子：


```
String str1 = new String("abc"); //jvm 在堆上创建一个String对象     
    
 //jvm 在strings pool中找不到值为“abc”的字符串，因此     
 //在堆上创建一个String对象，并将该对象的引用加入至strings pool中     
 //此时堆上有两个String对象     
Stirng str2 = "abc";   //并没有创建对象，因为对象池里已经有"abc" 了  
    
 if(str1 == str2){     
         System.out.println("str1 == str2");     
 }else{     
         System.out.println("str1 != str2");     
 }     
  //打印结果是 str1 != str2,因为它们是堆上两个不同的对象     
    
  String str3 = "abc";     
 //此时，jvm发现strings pool中已有“abc”对象了，因为“abc”equels “abc”     
 //因此直接返回str2指向的对象给str3，也就是说str2和str3是指向同一个对象的引用     
  if(str2 == str3){     
         System.out.println("str2 == str3");     
  }else{     
         System.out.println("str2 != str3");     
  }     
 //打印结果为 str2 == str3
```
### 3、String / StringBuffer / StringBuilder   区别
StringBuilder 比 StringBuffer 效率高一点，但是线程不安全，建议都使用StringBuffer


### 4、API
 char charAt (int index)     返回index所指定的字符  
 String concat(String str)   将两字符串连接  
 boolean endsWith(String str)    测试字符串是否以str结尾  
 boolean equals(Object obj)  比较两对象  
 char[] getBytes     将字符串转换成字符数组返回  
 char[] getBytes(String str)     将指定的字符串转成制服数组返回  
 boolean startsWith(String str)  测试字符串是否以str开始  
 int length()    返回字符串的长度  
 String replace(char old ,char new)  将old用new替代  
 char[] toCharArray  将字符串转换成字符数组  
 String toLowerCase()    将字符串内的字符改写成小写  
 String toUpperCase()    将字符串内的字符改写成大写  
 String valueOf(Boolean b)   将布尔方法b的内容用字符串表示  
 String valueOf(char ch)     将字符ch的内容用字符串表示  
 String valueOf(int index)   将数字index的内容用字符串表示  
 String valueOf(long l)  将长整数字l的内容用字符串表示  
 String substring(int1,int2)     取出字符串内第int1位置到int2的字符串  
 ## 常见问题
 ### 1、String类为什么是final的。
由于String类不能被继承，所以就不会没修改，这就避免了因为继承引起的安全隐患；
String类在程序中出现的频率比较高，如果为了避免安全隐患，在它每次出现时都用final来修饰，这无疑会降低程序的执行效率，所以干脆直接将其设为final一提高效率；
