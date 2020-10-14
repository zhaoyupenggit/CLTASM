# 遇到的一些问题

## 报错问题

## 其他问题

### 程序总是一直不结束

1. 程序陷入了死循环，检查循环的变量 是否正常变化，程序结束循环的条件是否正确，程序的循环变量是不是太大了，是不是赋值的时候，没有注意大小

不同的编译器会报不同的错以及可能有多种原因导致一个报错。我只记录了我所遇到的错误。

1.relative jump out of range by XXXh bytes
跳转距离过长。
解决方法：
1.在程序中增加无条件的跳转中介。
2.将一部分代码片段移出跳转

2.missing or unreachable cs
解决方法：
assume cs:code
注意这句话写在代码标号之前，否则也会报错

3.near jump or call to different cs
同上

4.expecting scalar type
操作时候用了变量
解决方法：改用寄存器

5.illegal memory reference
非法内存引用
可能是将变量或者数组直接运算
解决方法：将一个操作数换成寄存器

6.Improper operand type
移位超过1位以上必须使用寄存器

7.constant expetcted
移位使用cl寄存器

8.unexpected end of file encounter
结尾没有加end main

9.illegal intexing mode
dx不能用作index

10.argument needs type override
参数没有指定类型，参数前加上byte ptr

11.oprand types do not match
操作数类型不一样，应该换成相同类型的，比如al和ds:[dx]
————————————————
版权声明：本文为CSDN博主「HGGshiwo」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：<https://blog.csdn.net/HGGshiwo/article/details/105464296>
