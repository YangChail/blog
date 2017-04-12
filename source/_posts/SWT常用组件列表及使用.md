---
title: SWT常用组件列表及使用
date: 2017-04-11 12:08:13
tags: ogg
---
最近一直在使用swt开发kettle 插件，下面是我整理的swt常用组件的一些样式和使用方法。


----------


 [TOC]


----------


**一.按钮（Button）**
============

###**1.Button常用样式**


样式    | 说明
-------- | ---
SWT.NONE|无
SWT.PUSH| 按钮
SWT.CHECK| 多选按钮
SWT.RADIO| 单选按钮
SWT.ARROW| 箭头按钮
SWT.NONE| 默认按钮
SWT.CENTER| 文字居中与
SWT.LEFT| 左对齐
SWT.RIGHT| 右对齐
SWT.BORDER| 深陷型按钮
 SWT.FLAT| 平面型按钮
 
> **注**：   一个Button可以指定多个样式，只要将指定的各个样式用符号“|”连接起来即可例如下面的Button 的样式为：**多选.深陷.左对齐**。

>**Button bt=new Button(shell,SWT.CHECK|SWT.BORDER|SWT.LEFT);**


----------


###**2.Button组件的常用方法**

方法    | 说明
-------- | ---
    setText(String string),|设置组件的标签文字
    setBounds(int x,int y,int width,int height);|设置组件的坐标位置和大小
    setEnabled(Boolean enabled);|设置组件是否可用，默认为true
    setFont(Font font);|设置文字的字体
    setForeground(Color color);|设置前景色
    setBackground(Color color);|设置背景色
    setImage(Image image);|设置显示用的图片
    setSelection(Boolean selected);|设置是否选中,默认为false
   setToolTipText(String string);|设置鼠标停留在组件上是显示的提示信息
   


----------
**二.标签（Label）**
============

样式    | 说明
-------- | ---
 SWT.CENTER|   居中
    SWT.RIGHT  | 右对齐
    SWT.LEFT  | 左对齐
    SWT.NONE |  默认样式
    SWT.WRAP |  自动换行
    SWT.BORDER |  深陷型
    SWT.SEPARATOR |  分栏符，默认为竖线分栏符
    HORIZONTAL |  横线分栏符


----------
**三.文本框组件（Text）**
============


样式    | 说明
-------- | ---
  SWT.NONE |   默认式样
    SWT.CENTER | 居中
    SWT.RIGHT | 右对齐
    SWT.LEFT | 左对齐
    SWT.MULTI  |  可以输入多行，需回车换行
    SWT.WRAP  |  可以输入多行，自动换行
    SWT.PASSWORD  |  密码型，输入字符显示成“*”
    SWT.BORDER    |  深陷型
    SWT.V_SCROLL  |  垂直滚动条
    SWT.H_SCROLL  | 水平滚动条

 
 ----------
**四.下拉框组件（Combo）**
============
###**1.Combo常见样式**


样式    | 说明
-------- | ---
    SWT.NONE  |  默认
 SWT.READ_ONLY | 只读
  SWT.SIMPLE   | 无需单击下拉框，列表会一直显示


----------


###**2.Combo下拉框常用方法** 

 
方法    | 说明
-------- | ---
    add(String string)   | 在Combo上添加一项
    add(String string,int index)   | 在Combo的第index（从0开始）项后插入一项
    deselectAll()    |  使Combo组件中的当前选项为空
    removeAll()     |   将Combo中的所有选项清空
    setItems(String[] items)   | 将数组中的各项依次加入到Combo中
    select(int index)  |  将Combo的第index+1项设置为当前选择项

 
----------


**五.下拉框组件（Combo）**
============

###**1.List常见样式**

样式    | 说明
-------- | ---
    SWT.NONE  |  默认样式
 SWT.V_SCROLL  |带垂直滚动条
 SWT.MULTI |   允许复选
SWT.SINGLE  |  允许单选


----------


### **2.List常用方法**

List和Combo组件的方法是一样的，但由于List可选择多项，而Combo只能选择一项 ，所以List没有**getText()**方法，List的取值使用**getSelection（）**，返回一个**String数组**。


----------


 
**六.菜单（Menu，MenuItem）**
============
 菜单（Menu.MenuItem）是常用的SWT组件，**Menu**是一个菜单栏，同时也是一个容器，可以容纳菜单项**MenuItem**。
 
### **1.Menu常见样式**


样式    | 说明
-------- | ---
    SWT.BAR  |   菜单栏，用于主菜单
 SWT.DROP_DOWN |  下拉菜单，用于子菜单
 SWT.POP_UP  |   鼠标右键弹出菜单

### **2.MenuItem常见样式**

样式    | 说明
-------- | ---
SWT.CASCADE|  有子菜单的菜单项
  SWT.CHECK   | 选中后前面显示一个小勾
 SWT.PUSH   | 普通型菜单
SWT.RADIO    |选中后前面显示一个圆点
 SWT.SEPARATOR|  分隔符

### **3.MenuItem常用方法**

 - 首先建立一个菜单栏，需要用到SWT.BAR属性

 ```
 Menu mainMunu=new Menu(shell,SWT.BAR);
 ```


 -  在窗体中指定需要显示的菜单栏
 ```
    shell.setMenuBar(mainMenu);
 ```
 -  创建顶级菜单项，需要使用SWT.CASCADE属性

  ```
  MenuItem fileItem=new MenuItem(mainMenu,SWT.CASCADE);
  fileItem.setText("file&F");
 ```
 -  创建与顶级菜单项相关的下拉式菜单


  ```
    Menu fileMenu=new Menu(shell,SWT.DROP_DOWN);

  ```
 -  将顶级菜单项与下拉菜单关联


  ```
      fileItem.setMenu(fileMenu);

  ```
 -   二级菜单的建立只需要重复③~⑤即可

 

---


**六.容器**
============
### **1 .面板（Composite）**


方法    | 说明
-------- | ---
    getLayout()  |获得布局管理器
 getLayoutData()    |得到布局数据
 getParent()   | 得到容纳该容器的父容器
    getShell()  |  得到容纳该容器的Shell
    layout()   | 将容器上的组件重新布局，相当于刷新

 

 

### **2.分组框（Group）**

   Group是Composite的子类，所以两者用法基本相同。主要区别是Group显示有一个方框，且方框线上还可以显示说明文字

 

### **3.选项卡（TabFolder.TabItem）**

  选项卡包括一个选项卡（TabFolder类）和一个选项页（TabItem类），TabFolder是容器，可以容纳其它容器和组件，但TabItem不是容器，可以把它看成是一个选项标签，TabFolder通过TabItem来对其中的组件进行控制。每一个TabItem用setControl（）来控制一个界面组件。

 
**七.布局管理器**
============


### **1.充满式布局（FillLayout）**

   FillLayout是最简单的布局管理器，它把组件按一行或一列充满整个容器，并强制组件的大小一致。 一般组件高度和最高组件相同，宽度与最宽组件相同。FillLayout不能折行，不能设置边界距离和间距。 如果容器中只有一个组件，则该组件会充满整个容器。

   **（1）.构造方法**

>    FillLayout()  创建按一行充满容器的对象。FillLayout(int type)  创建按指定类型充满容器的对象，type有：SWT.HORIZONTAL（行）SWT.VERTICAL（列）

  **（2）.常用属性**

>    int type 指定组件充满容器的类型
    FillLayout.type=SWT.VERTICAL 或 SWT.HORIZONTAL;

 

###**2.行式布局（RowLayout）**

   RowLayout可以是组件折行显示，可以设置边界距离和间距。另外，还可以对每个组件通过setLayoutData()方法设置RowData对象。RowData用来设置组件大小。

  **（1）.构造方法**

>   RowLayout()       创建按行放置组件的对象
   RowLayout(int type)       创建按指定类型放置组件的对象。
  type：SWT.HORIZONTAL  SWT.VERTICAL

  **（2）.常用属性**

属性   | 说明
-------- | ---
    int marginWidth    | 组件距容器边缘的宽度（像素），默认为0
    int marginHeight  | 组件距容器边缘的高度（像素），默认为0
    int marginTop   |  组件距容器上边缘的距离（像素），默认为3
    int marginBottom  | 组件距容器下边缘的距离（像素），默认为3
    int spacing     |  组件之间的距离，默认值为3
    boolean justify    | 如果该属性为true，则组件间的距离随容器的拉伸而变大，默认值为false
    boolean wrap   |  如果该属性为true，当空间不足时会自动折行，默认为true
    boolean pack   |  如果该属性为true，组件大小为设定值；如果为false，则强制组件大小相同 默认为true
    int tyep   |  SWT.HORIZONTAL（行）  SWT.VERTICAL（列）


----------


 **（3）RowData类**

>    RowData称为RowLayout的布局数据类，可用于改变容器中组件外观形状，其构造方法为 RowData（int width，int height）

 

### **3.网格式布局（GridLayout）**

   GridLayout是实用而且功能强大的标准布局，也是较为复杂的一种布局。这种布局把容器分成网格，把组件放置在网格中。GridLayout有很多可配置属性，和RowLayout一样，也有专用的布局数据类  GridData.GridLayout的构造方法无参数，但可以通过GridData和设置GridLayout属性来设置组建的排列.形状.和位置。

 **（1）.GridLayout属性**
  
属性   | 说明
-------- | ---
    int numColumn    |设置容器的列数，组件从左到右按列放置，当组件数大于列数时，下一个组件 将自动添加到新的一行
    boolean makeColumnsEqualWidth  |强制使列都具有相同的宽度，默认为false
    int marginWidth  |  设置组件与容器边缘的水平距离，默认值为5
    int marginHeight | 设置组件与容器边缘的垂直高度，默认值为5
    int horizontalSpacing  |设置列与列之间的间距，默认为5
    int verticalSpacing   | 设置行与行之间的间隔，默认为5

 


----------


  **（2）布局数据类（GridData类）**

   GridData是GridLayout专用的布局数据类，用GridData可以构建很多复杂的布局方式。

   
 - **构造方法**



  >    GridData()  创建一个属性值为默认值的对象
  >    
  >GridData（int type）
 - **常用类型**

  
    类型   | 说明
  -------- | ---
      GridData.FILL | 通常与对象属性horizontalAlignment和verticalAlignment配合使用，充满对象 属性指定空间。
      GridData.FILL_HORIZONTAL |   水平充满，
      GridData.FILL_VERTICAL   |   垂直充满
      GridData.FILL_BOTH      |  双向充满
      GridData.HORIZONTAL_ALIGN_BEGINNING   | 水平靠在对齐
      GridData.HORIZONTAL_ALIGN_END |     水平靠右对齐
      GridData.HORIZONTAL_ALIGN_CENTER  |  水平居中对齐


 - **常有对象属性**

    属性   | 说明
  -------- | ---
      int horizontalSpan  |设置组件占用的列数，默认为1
      int verticalSpan  |设置组件占用的行数，默认为1
      horizontalAlignment  |设置组件对齐方式为水平方向
      verticalAlignment  |设置组件对齐方式为垂直方向
      grabExcessHorizontalSpace  |抢占额外水平空间
      grabExcessVerticalSpace   | 抢占额外垂直空间
      
      
      

---

 - **horizontalAlignment和verticalAlignment可以取以下值：**
属性 | 说明
---|---
      GEGINNING  |开始（水平对齐时居左，垂直对齐时居上）
      CENTER   | 居中，默认
      END      |结束（水平对齐时居右，垂直对齐时居下）
      FILL   | 充满

 
### **4.表格式布局（FormLayout）**



   FormLayout是一种非常灵活.精确的布局方式，FormData使其专用的布局数据类。 此外，还增加了一个FormAttachment类。FormAttachment定义了组件的四边与父容器 （Shell.Composite）的边距，为保证组件在父容器中的相对位置不变，FormAttachment 类用不同的构造方法来实现组件的定位，用FormData和FormAttachment配合，可以创建复杂的界面，而且当主窗体大小改变时，组件的相对位置能保持相对不变。

  **（1）FormLayout构造函数**

  >  FormLayout（）;

  **（2）FormLayout的属性**

 >    int marginWidth    //设置组件与容器边缘的水平距离，默认值为0
  >  int marginHeihgt  //设置组件与容器边缘的垂直距离，默认为0

  **（3）FormData类**
  
 - FormData的构造方法

 >  FormData（）
FormData（int width，int height）设置组件的宽度和高度

 - FormData的属性

 >    width  设置组件的宽度
>      height  设置组件的高度
>      top 和 FormAttachment配合设置组件底部和父容器底部的边距
>      left 和 FormAttachment配合设置组件右边和父容器右边的边框
>      如果FormData中的width和height设置的宽度和高度与FormAttachment设置的约束发生冲突，则按照FormAttachment设置，width和height的设定值就不起作用了。

**（4）.FormAttachment类**

 Attachment的含义是附着.粘贴。
 FormAttachment类就是用来指定组件在父容器中粘贴的位置。FormAttachment计算组件粘贴位置和组件大小的方法是依据下面的表达式：

```
     y=ax+b
```
 - FormatAttachment构造方法

   >   FormatAttachment()组件紧贴父容器的左边缘和上边缘，如果父容器设置了FormLayout属

     >  性marginWidth.marginHeight，则距父容器的上边缘和左边缘为其值。

       >  FormatAttachment(Control control)以指定组件control为参照物

     >    FormatAttachment(Control control,int offset)以指定组件control为参照物，相对指定  组件偏移量为offset

      >   FormatAttachment(Control control,int offset,int alignment)对齐方式为alignment

      >    SWT.TOP  SWT.BOTTOM  SWT.LEFT  SWT.RIGHT  SWT.CENTER

      >   FormAttachment(int m,int n,int offset)以组件相对与父容器宽度或高度的百分比(即斜率a)来给组件定位，m为a的分子，n为分母，offset为偏移量

     >    FormAttachment(int m,int offer)  n默认为100
  
    >    FormAttachment(int m) n默认为100，offset默认为0

 

 
**八.SWT的常用事件**
============

所有事件.监听器和适配器都放在包org.eclipse.swt.events中。 SWT中常用事件如下：
  
-  **addMouseListener鼠标监听器**

 > mouseDown()
     mouseUP()
     mouseDoubleClick()

-  **addKeyListener按键监听器**

   >   keyPressed() 按下
     keyReleased()释放

- **addSelectionListener组件选择监听器**

   >   widgetSelected()

-  **addFocusListener焦点监听器**

   >    focusGained()   得到焦点
      focusLost()    失去焦点        

 


----------

