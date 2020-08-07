;串口通信8250编程
; 查询方式 单工通讯
; 例：A、B两机利用主串口，查询方式，进行单工通信，A机发送电文“HELLO”至B机。试为A机编写发送程序。
; 要求：波特率=2400，奇校验，停止位1位，数据位7位，采用查询方式。
.386
DATA	SEGMENT  USE16
		BUF	    DB	'HELLO'
		LENs     EQU	$ - BUF
		DATA    ENDS
CODE	SEGMENT USE16
		ASSUME    CS:CODE , DS:DATA
BEG:	MOV  AX , DATA
		MOV	 DS , AX		
		CALL	I8250;进行初始化
		LEA	BX, BUF
		MOV	CX, LENS
		;利用查询方式发送字符串
SCAN:	MOV	DX, 3FDH;通信线状态寄存器
		;????还没有in吧
		IN AL,DX
		TEST	AL, 20H
		;查询D5位：发送保持寄存器空闲标志位。D5＝1，表示数据已从发送保持寄存器转移到发送移位寄存器，发送保持寄存器空闲，CPU可以写入新数据。当新数据送入发送保持寄存器后， D5置0。
		JZ	SCAN;如果允许通信就继续下一步
		MOV	DX, 3F8H
		MOV	AL, [BX]
		OUT    DX, AL;逐字节发送需要发送的数据
		INC      BX
		LOOP  SCAN
NEXT:   MOV    DX, 3FDH
        IN        AL, DX
        TEST   AL, 40H;D6位：发送移位寄存器空闲标志位。D6＝1，表示一帧数据已发送完毕。当下一个数据由发送保持寄存器移入发送移位寄存器时，该位被置0。
		JZ        NEXT
        MOV   AH, 4CH
        INT      21H

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
	MOV	AL, 0;查询方式下 不需要允许中断
	OUT	DX, AL
    MOV	DX, 3FCH;modem控制寄存器
	MOV	AL, 0
	OUT	DX, AL
	RET
I8250	ENDP

CODE	ENDS
	END	BEG