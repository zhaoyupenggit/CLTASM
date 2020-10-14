;8250串口通信
;对微机系统的串行口进行自发自收内环测试
;需要发送的信息存储在数据段中，屏幕显示接收到的数据。
; 由于缺乏外环环境，因此本实验采用内环方式。
;本代码使用查询方式发送，中断方式接受
.386
DATA	SEGMENT  USE16
        OLD0C   DD ?;用来存储中断向量
        FLAG    DB 0;标志位
	    BUF	    DB 'A big black bug bit a big black bear and made the big black bear bleed blood.'
        LENS   =$-BUF
DATA    ENDS

CODE	SEGMENT USE16
		ASSUME    CS:CODE , DS:DATA
        
BEG:	MOV  AX , DATA
		MOV	 DS , AX	
        CLI;关中断
        CALL I8259;中断控制器初始化
        CALL RD0C;读主串口中断对应的中断向量
        CALL WR0C;写中断向量
		CALL I8250;串口芯片初始化
        STI
		LEA	 BX, BUF
        MOV	 CX, LENS;读取内存中需要发送的信息
        ;循环体
FIRST:  MOV     FLAG,0
;利用查询方式发送字符
SCAN:	MOV	    DX, 3FDH;通信线状态寄存器
		IN      AL,DX
		TEST    AL, 20H
		JZ      SCAN;如果允许通信就继续下一步
SEND:	MOV     DX, 3F8H
		MOV     AL, [BX]
		OUT     DX, AL;逐字节发送需要发送的数据	
        ;等待发完数据
SCANT:  CMP     FLAG,1
        JNZ     SCANT   
;以上两行的作用为等输出发送完成，可以用一下两种方法代替
;方法1：反复检查发送移位寄存器，判断数据是否发完
;  RSCAN: MOV     DX, 3FDH    
;         IN      AL, DX
;         TEST    AL, 40H     
; 		JZ      RSCAN
;方法2：通过延时的方式，等待数据发送完,会拖慢程序
;         MOV     SI,0
; DELAY:  DEC     SI
;         CMP     SI,0
;         JNZ     DELAY

        INC      BX
        LOOP  FIRST
        CALL  RESET
        MOV AH,4CH
        INT 21H
;------------
RECEIVE PROC
        PUSH  AX
        PUSH  DX
        PUSH  DS
        MOV   AX,DATA
        MOV   DS,AX
        MOV   DX,3F8H
        IN    AL,DX;读取接收缓冲区的内容
        AND   AL,7FH
        MOV AH,2
        MOV DL,AL
        INT 21H;显示字符
NEX:    MOV FLAG,1
EXIT:   MOV AL,20H
        OUT 20H,AL;中断结束
        POP DS
        POP DX
        POP AX
        IRET
        RECEIVE ENDP
I8250	PROC
	MOV	DX, 3FBH;通信线路控制寄存器
	MOV	AL, 80H
	OUT	DX, AL
	MOV	DX, 3F9H;访问除数锁存器高位MSB
	MOV	AL, 0
	OUT	DX, AL
	MOV	DX, 3F8H;访问除数锁存器低位LSB
	MOV	AL, 30H
	OUT	DX, AL

	MOV	DX, 3FBH;通信线控制寄存器
	MOV	AL, 00001010B
	OUT	DX, AL
	MOV	DX, 3F9H;访问中断允许寄存器
	MOV	AL, 01H;允许接收中断
	OUT	DX, AL
    MOV	DX, 3FCH;modem控制寄存器
	MOV	AL, 18H;内环 允许接收
	OUT	DX, AL
	RET
I8250	ENDP
I8259   PROC
    IN AL,21H;21H为系统分配给主8259A的奇地址（中断屏蔽寄存器口地址305）
    AND AL,11101111B;IR4为主串口的中断引脚，对应的中断程序为0CH
    out 21H,AL
    RET
I8259  ENDP
;-----------------
RD0C    PROC
    MOV AX,350CH        ;21H的35H功能将1CH的中断向量读出来
    INT 21H
    MOV WORD PTR OLD0C,BX 
    MOV WORD PTR OLD0C+2,ES    
RET
RD0C    ENDP
WR0C    PROC
    PUSH DS
    MOV AX,CODE
    MOV DS,AX
    LEA DX,RECEIVE
    MOV AX,250CH
    INT 21H             ;21h的25H功能用来写中断向量
    POP DS
    RET
WR0C  ENDP
RESET PROC
    IN AL,21H
    OR AL,00010000B
    OUT 21H,AL
    MOV AX,250CH        ;21h的25H功能用来写中断向量
    MOV DX,WORD PTR OLD0C
    MOV DS,WORD PTR OLD0C+2
    INT 21H
    RET
    RESET ENDP
CODE	ENDS
	END	BEG