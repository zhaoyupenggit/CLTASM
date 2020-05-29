;8250串口通信 双中断的程序代码
.586
DATA	SEGMENT  USE16
        OLD0C   DD ?;用来存储中断向量
        FLAG    DB 0
        BUF	    DB 'NIHAO hello HOLA ohayou nice to meet you this is the world of the box DOSBox and the asm'
        LENS   =$-BUF
        ERROR DB      'COM1 BAD !',0DH,0AH,'$'
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
		LEA	 BX, BUF
        MOV	 CX, LENS;读取内存中需要发送的信息
        ;循环体
        MOV     AL,11B
        MOV     DX, 3FAH
        OUT     DX,AL
        STI 
CHECK:  CMP CX,0
        MOV DX,3FDH
        IN  AL,DX
        MOV AH,AL
        MOV DX,3FAH
        IN  AL,DX
        JNZ CHECK
        CLI
        CALL  RESET
        STI
        MOV AH,4CH
        INT 21H
;------------
SERVICE PROC
        PUSH  AX
        PUSH  DX
        PUSH  DS
        MOV DL,'S'
        MOV AH,02H
        INT 21H
        MOV   AX,DATA
        MOV   DS,AX
GET:    MOV     DX, 3FAH
        IN      AL, DX
        AND     AL,03H
        CMP    AL, 100B;j接收数据准备好
        JNZ     SEND
        MOV   DX,3F8H
        IN    AL,DX;读取接收缓冲区的内容
        AND   AL,7FH
        MOV AH,2
        MOV DL,AL
        INT 21H;显示字符
        MOV DL,'O'
        MOV AH,2
        INT 21H
        ;MOV FLAG,1
SEND:   MOV	    DX, 3FAH;中断识别寄存器
		IN      AL,DX
        AND     AL,03H
		CMP    AL, 02H;
		JNZ     EXIT
		MOV     DX, 3F8H
		MOV     AL, [BX]
		OUT     DX, AL;逐字节发送需要发送的数据	
        MOV     DL,'O'
        MOV AH,2
        INT 21H
NEXT:   MOV     DX, 3FDH;D0位：接收数据准备好(接收缓冲器满)标志位
        IN      AL, DX
        TEST    AL, 40H;D6位：发送移位寄存器空闲标志位。D6＝1，表示一帧数据已发送完毕。当下一个数据由发送保持寄存器移入发送移位寄存器时，该位被置0。
		JZ      NEXT
        INC     BX
        DEC     CX
EXIT:   MOV AL,20H
        OUT 20H,AL;中断结束
        POP DS
        POP DX
        POP AX
        IRET
        SERVICE ENDP
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
	MOV	AL, 0FH;允许送出接收和接收中断
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
    LEA DX,SERVICE
    MOV AX,250CH
    INT 21H
    POP DS
    RET
WR0C  ENDP
RESET PROC
    IN AL,21H
    OR AL,00010000B
    OUT 21H,AL
    MOV AX,250CH;21h的25H功能用来写中断向量
    MOV DX,WORD PTR OLD0C
    MOV DS,WORD PTR OLD0C+2
    INT 21H
    RET
    RESET ENDP
CODE	ENDS
	END	BEG