;上交老师的版本
.386
DATA 	SEGMENT USE16
	MESG 	DB 'Bleqbs15',0DH,0AH,'$'
	MESG1		DB '<-->PRINT MESG PER HALF SEC',0DH,0AH
			DB '<-->PLEASE PRESS ANY KEY TO STOP',0AH,0DH,'$'
	MESG2   DB '(-v-)PRESSED!',0DH,0AH,'$'
	COUNT	Dw 0
	ICOUNT1 DB 100;100*5ms=0.5s 每0.5s输出一次字符串
	ICOUNT2 DB 11;11*5ms=55ms 每55ms提一次日时钟中断
	OLD08   DD ?;用于保存原来的08H服务程序地址
DATA ENDS
CODE	SEGMENT USE16
	ASSUME CS:CODE,DS:DATA
BEG:	MOV AX,DATA
		MOV DS,AX
		MOV AH,9
		LEA DX,MESG1
		INT 21H
		CLI			;关中断，进行初始化工作
		CALL I8254		;设置8254计数器
		CALL READ08		;读取原中断程序地址
		CALL WRITE08	;写新的中断程序地址
		STI			;开中断，开始接受计数器发来的中断，实现动态显示功能
SCAN:	MOV AH,1	;检测键盘是否有输入
        INT 16H
        JZ SCAN			;无输入便循环

RETURN:	CLI			;有输入则关中断，准备结束程序
		MOV AH,9
		LEA DX,MESG2
		INT 21H
		CALL RESET08		;将原来的08服务程序地址还原
		STI
		MOV AH,4CH
		INT 21H

;----
SERVICE	PROC
		PUSHA			;保存寄存器值
		PUSH DS			;保存段寄存器值
FIRST:	DEC ICOUNT1		;判断中断间隔是否满半秒
		JNZ NEXT			;不满则继续判断直到满为止
;		CALL HEXPC
		MOV AH,9			;打印字符串
		LEA DX,MESG
		INT 21H
		MOV ICOUNT1,200		;重置计数位
NEXT:	DEC ICOUNT2		;判断是否为55ms间隔的中断
		JNZ EXIT			;不是则结束子程序，还原现场
		MOV ICOUNT2,11		;是则调用原来的中断程序
		POP DS
		POPA
		JMP OLD08
EXIT:   MOV AL,20H
		OUT 20H,AL		;送中断结束命令字，表示中断程序运行结束
		POP DS
		POPA
		IRET
SERVICE ENDP
READ08  PROC;读取原中断程序地址
		MOV AX,3508H
		INT 21H
		MOV WORD PTR OLD08,BX
		MOV WORD PTR OLD08+2,ES
		RET
	READ08 ENDP
WRITE08 PROC;写新的中断程序地址
		PUSH DS
		MOV  AX,CODE
		MOV  DS,AX
		LEA  DX,SERVICE
		MOV  AX,2508H
		INT 21H
		POP DS
		RET
	WRITE08 ENDP
I8254	PROC;调整计数器设置
		MOV AL,00100110B		;00为0号计数器|11为3号读写方式|011为3号工作方式|0使用初始值为二进制数
		OUT 43H,AL
		MOV AX,5966				;计数初值 = fclk / fout 其中fclk=1.193182 MHZ 根据要求输出fout=200Hz
		OUT 40H,AL
		MOV AL,AH
		OUT 40H,AL
		RET
	I8254 ENDP
RESET08 PROC
	MOV DX,WORD PTR OLD08		;这两行使用的是立即寻址，默认的段寄存器为DS
	MOV DS,WORD PTR OLD08+2
	MOV AX,2508H
	INT 21H
	RET
RESET08 ENDP
CODE ENDS
END BEG
; HEXPC PROC
;         MOV DX,COUNT
;         MOV CX,4
;         SAL EDX,16
; AGA:    ROL EDX,4
;         AND DL,0FH
;         CMP DL,10
;         JC EXT
;         ADD DL,7
; EXT:   ADD DL,30H
;         MOV AH,02H;
; 		INT 21H
;         INC BX
;         LOOP AGA
;         INC COUNT
;         RET
; HEXPC ENDP