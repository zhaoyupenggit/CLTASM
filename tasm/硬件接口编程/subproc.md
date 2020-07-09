# 学习过程中的代码段

## 这里记录学习串行通信8250的几个代码段

### PPT page36 通信线状态寄存器

#### 示例1 利用主串口查询方式发送一个"A"

```assembly
SCANT: MOV DX,3FDH;通信线状态寄存器
  IN AL,DX
  TEST AL,20H;0010 0000
  JZ SCANT;判断D5是否为1
  MOV DX,3F8H;发送保持寄存器
  MOV AL,'A'
  OUT DX,AL
;示例2：利用辅串口查询方式接受一个字符
SCANR: MOV  DX,2FDH
   IN  AL,DX
  TEST AL,01H;0000 0001
  JZ   SCANR;判断D0是否为1
  MOV DX,2F8H;接收缓冲寄存器
  IN AL,DX
```

#### 编写子程序，对PC系列机主串口进行初始化

要求：
;1.通信速率=1200波特，一帧数据包括：8个数据位，1 个停止位，无校验
;2.查询方式，完成内环自检
; 分析： (1)速率=1200
           ; 分频系数=1.8432M/(16*1200)= 0060H
               ; (也可查表得到)
         ; (2)一帧数据结构命令字：00000011B = 03H
         ; (3) 中断允许命令字  =  0
         ; (4) MODEM控制字00010000H = 10H

```assembly
I8250    PROC
             MOV       DX，3FBH;访问通信线寄存器BH
             MOV       AL，80H;将通信线寄存器的寻址位D7置一
             OUT        DX，AL;使得下一步9H和8H访问除数寄存器
             MOV       DX，3F9H
             MOV       AL，0
             OUT        DX，AL   ;高位置数00
             MOV       DX，3F8H
             MOV       AL，60H
             OUT        DX，AL;低位置数60
             MOV       DX，3FBH
             MOV       AL，03H
             OUT        DX，AL;定义数据帧格式
             MOV       DX，3F9H
             MOV       AL，0
             OUT        DX，AL;置数 中断允许寄存器
             MOV       DX，3FCH
             MOV       AL，10H
             OUT        DX，AL;置数 MODEM控制寄存器
             RET
 I8250  ENDP
 ```

 ; 例：要求微机系统主串口以9600 bps(分频系数:000CH)进行异步串行通信，
; 每个字符 7 位，2个停止位，奇校验，允许所有中断。

```tasm
MOV   DX, 3FBH            ;置除数锁存器(分频系数)
MOV  AL, 80H
OUT   DX, AL                  ;通讯线路控制寄存器最高位置“1”
MOV  DX, 3F8H
MOV  AL, 0CH
OUT   DX, AL                   ;除数低位送入 除数锁存器 LSB (低8位)
MOV  DX, 3F9H
MOV  AL, 0                      ;除数高位送入 除数锁存器 MSB (高8位)
OUT  DX, AL
MOV  DX, 3FBH              ;置通信线路控制寄存器(数据格式)
MOV  AL, 00001110B      ;7 个字符位，2个停止位，奇校验
OUT  DX, AL
MOV  DX, 3F9H               ;置中断允许寄存器
MOV  AL, 0FH                 ;允许所有中断
OUT  DX, AL
MOV  DX, 3FCH              ;置MODEM控制器
MOV  AL, 08H                 ;使 OUT2=0，MODEM可送出中断
OUT  DX, AL
```
