;8250串口通信
;对微机系统的串行口进行自发自收内环测试
;**从键盘输入字符串来发送**，屏幕显示接收到的数据。
; 由于缺乏外环环境，因此本实验采用内环方式。
;本代码使用查询方式发送，中断方式接受

.386
DATA	SEGMENT  USE16
        OLD0C   DD ?
        FLAG    DB 0
        INPUT   DB 'PLEASE INPUT ONE MESSAGE WITHIN 30CHARS',0AH,0DH,'$'
        MESG    DB ' is the string I send',0AH,0DH,0AH,0DH,'THE STRING I GET IS:$'
		BUF	    DB	30
                DB  ?
                DB  30 DUP(?)
		DATA    ENDS

CODE	SEGMENT USE16
		ASSUME    CS:CODE , DS:DATA
        
BEG:	MOV  AX , DATA
		MOV	 DS , AX	
        CLI
        CALL I8259
        CALL RD0C
        CALL WR0C	
		CALL	I8250;进行初始化
        STI   
        ;键入需要显示的字符串
        LEA DX,INPUT
        MOV AH,9
        INT 21H
        MOV AH,0AH
        mov DX,OFFSET BUF
        INT 21H
		LEA	BX, BUF
        INC BX
        MOV CX,0
        MOV	CL, [BX]
        INC BX	
        
        MOV SI,CX
        MOV WORD PTR [BX+SI],'$'
        MOV DX,BX
        MOV AH,9
        INT 21H
        LEA DX,MESG
        MOV AH,9
        INT 21H
        ;开启循环体
		;利用查询方式发送字符
SCAN:	MOV	DX, 3FDH;通信线状态寄存器
		IN AL,DX
		TEST	AL, 20H;查询D5位：发送保持寄存器空闲标志位。D5＝1，表示数据已从发送保持寄存器转移到发送移位寄存器，发送保持寄存器空闲，CPU可以写入新数据。当新数据送入发送保持寄存器后， D5置0。
		JZ	SCAN;如果允许通信就继续下一步
SEND:	MOV	DX, 3F8H
		MOV	AL, [BX]
		OUT    DX, AL;逐字节发送需要发送的数据	
		INC      BX
		MOV FLAG,0
SCANT:  CMP FLAG,1
        JNZ  SCANT  
        LOOP  SEND
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
	MOV	AL, 80H;最高位置1表示下次访问9H的时候指的是除数锁存器低位，而不是中断允许寄存器
	OUT	DX, AL
	MOV	DX, 3F9H;访问除数锁存器高位MSB
	MOV	AL, 0
	OUT	DX, AL
	MOV	DX, 3F8H;访问除数锁存器低位LSB
	MOV	AL, 30H
	OUT	DX, AL

	MOV	DX, 3FBH;通信线控制寄存器
	MOV	AL, 00001010B
	;0非除数寄存器0正常通信001奇效验0一位停止位107位数据位（ASCII码为七位）
	OUT	DX, AL
	MOV	DX, 3F9H;访问中断允许寄存器
	MOV	AL, 01H;允许接收中断
	OUT	DX, AL
    MOV	DX, 3FCH;modem控制寄存器
	MOV	AL, 18H;D4置1，内环自检，允许送出中断请求
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
    MOV AX,350CH;dos调用的35H功能将1CH的中断向量读出来
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
    INT 21H
    POP DS
    RET
WR0C  ENDP
RESET PROC
    IN AL,21H
    OR AL,00010000B
    OUT 21H,AL
    MOV AX,250CH
    MOV DX,WORD PTR OLD0C
    MOV DS,WORD PTR OLD0C+2
    INT 21H
    RET
    RESET ENDP
CODE	ENDS
	END	BEG