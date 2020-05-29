;TEST 8250
DATA  SEGMENT USE16
   OLD0C   DW ?
   DATA ENDS
CODE SEGMENT USE16
ASSUME CS:CODE,DS:DATA
BEG:    MOV AX,DATA
        MOV DS,AX

        CLI
        CALL I8250
        CALL I8259
        STI
        MOV SI,0
CIR:    DEC SI
 mov ah,3
        MOV DX,0
        INT 16H
        CMP SI,0
        JZ EXIT
        JMP CIR
CLI
 EXIT:       CALL  RESET
        STI
        MOV AH,4CH
        INT 21H
;------------
SERVICE PROC
        cli 
        PUSH  AX
        PUSH  DX
        PUSH  DS
        MOV AL,'S';TEST
        MOV AH,0EH
        INT 16H
       
        POP DS
        POP DX
        POP AX
        sti
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
	MOV	AL, 01H;允许送出接收和接收中断
	OUT	DX, AL
    MOV	DX, 3FCH;modem控制寄存器
	MOV	AL, 18H;D4置1，内环自检，允许送出中断请求
	OUT	DX, AL
	RET
I8250	ENDP
I8259   PROC
    IN AL,21H;21H为系统分配给主8259A的奇地址（中断屏蔽寄存器口地址305）
    mov  AL,11101111B;IR4为主串口的中断引脚，对应的中断程序为0CH
    out 21H,AL
    RET
I8259  ENDP
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