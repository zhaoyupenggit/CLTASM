;第三次版本
;filename exa318.asm
;程序执行后,给出操作提示，请用户输人用户名和密码
;用户在输人密码时，程序不回显输入字符
;只有当用户输人的用户名、 密码字符串和程序内定的字符串相同时，才显示欢迎界面，并返回DOS。
; 界面颜色自定(彩色或黑白)。
;------------------------------------------------------------------
.586
DISP	MACRO	Y, X, VAR, LENGTH, COLOR;BIOS按照要求显示字符串
		 MOV         AH,13H
		 MOV         AL,1
		 MOV         BH,0                   ;选择0页显示屏
		 MOV         BL,COLOR                ;color属性字(颜色值) →BL
		 MOV         CX,LENGTH               ;LENGTH串长度 →CX
		 MOV         DH,Y                    ;Y行号 →DH
		 MOV         DL,X                    ;X列号 →DL
		 MOV         BP,OFFSET VAR           ;VAR串有效地址→BP
		 INT            10H
ENDM 

DATA SEGMENT USE16
LNAM  = 10;姓名支持的最大长度
LKEY  = 10;密码支持的最大长度
LPT   = 10;打印的起始行数
BUF   DB 10
	  DB ?
	  DB 10 DUP(?);用来作为存储用户名的缓冲区
MESGN DB LNAM DUP('_')
NAM   DB '1804','$';姓名列表
KEY   DB '0215',0DH;密码列表
NAME1 DB 'LENA','$'
PASS1 DB 'JOBS',0DH
LCHECK =  $-NAM
ENDD  DW ?
;下面是字符串
MESG1 DB 'welcome to 東氏 login systerm'
L     =  $-MESG1
MESG2 DB 'please input your NAME'
LL    =  $-MESG2
MESG3 DB 'please input your password,YOU have THERE chance'
LLL   =  $-MESG3

MESG4 DB 'NO information of this username'
MESG5 DB 'INCORRECT KEY,PLEASE CX AGAIN'
MESG7 DB ' Welcome!'
L7    =  $-MESG7
m7b   db '$'
MESG8 DB ' failed'
L8    =  $-MESG8
MESG9 	DB 0DH,0AH
		DB 'HI,'
		DB '$'
DATA ENDS

CODE SEGMENT USE16
	ASSUME DS:DATA,CS:CODE,ES:DATA
BEG:	MOV AX,DATA
		MOV DS,AX
		MOV ES,AX
		MOV AX,3   
		INT 10H ;设置屏幕显示方式  
		DISP LPT,(80-L)/2,MESG1, L,4;欢迎界面
		;输入用户名
		DISP LPT+1,(80-LL)/2,MESG2, LL,2
FIRST:	DISP LPT+2,(80-LNAM)/2,MESGN,LNAM,2;引导输入字符
		MOV BH,0
		MOV DH,LPT+2
		MOV DL,(80-LNAM)/2
		MOV AH,02H
		INT 10H	;设置光标位置			
		MOV AH,0AH
		MOV DX,OFFSET BUF
		INT 21H;读入用户键入的字符串放在buf中		
		MOV DI,OFFSET NAM
   STE:	CALL SCOMP
		JZ  SEC
		CMP di, OFFSET ENDD
		JC  STE		
		JMP FIRST
		
		;输入密码
SEC:	DISP LPT+3,(80-LLL)/2,MESG3, LLL,2
SECO:		MOV CX,3
SECOND:	MOV DH,LPT+7
		MOV BH,0
		SUB DH,CL
		MOV DL,36
		MOV AH,02H
		INT 10H
		CALL KEYCHECK
		JZ   YES
		LOOP SECOND

		;登录结果反馈
NO:	    DISP LPT+8,(80-L8)/2,MESG8,L8,4
		JMP LAST
YES:	DISP LPT+8,(80-L7)/2,MESG7,L7,4
LAST:	MOV AH,09H
		LEA DX,MESG9
		INT 21H
		MOV BL,BUF+1
        MOV BH,0
        MOV SI,OFFSET BUF+2
        MOV BYTE PTR[BX+SI],'$'
		MOV AH,09H
		MOV DX,OFFSET BUF+2
		INT 21H
		MOV AH ,4CH
	    INT 21H
		
		
;-------------------------串比较-------------------------
SCOMP PROC;正确Z为1 错误Z为0
		MOV CL,BUF+1
		MOV CH,0
		LEA SI,BUF+2
		CLD
		REPE CMPSB
		JNZ SNO
		CMP BYTE PTR [DI],'$'
		JZ  SYES
SNO:	CMP BYTE PTR [DI],0DH
		JZ  SSNO
		INC DI
		JMP SNO	
SYES:  INC DI
		cmp di,di;z标志置1
		JMP SLAST
		
SSNO:   INC DI 
		TEST DI,DI;z标志置0 	
SLAST:	MOV ENDD,DI
RET
SCOMP ENDP
;---------检查密码是否正确---------
KEYCHECK  PROC
		MOV DI,ENDD
		MOV ENDD+2,DI
		MOV DH,0;将dh作为标志
KBEG:	MOV AH,08H
		INT 21H;输入一个字符
		CMP AL,0DH
		JZ KAL0D
		CMP BYTE PTR [DI],0DH
		JNZ KNEX
		INC DH
KNEX:	CMP BYTE PTR [DI],AL
		JZ  KSTEP
		INC DH
KSTEP:  INC DI    
		MOV AH,02H
		MOV DL,'*'
		INT 21H
		JMP KBEG
 
KAL0D:	CMP BYTE PTR [DI],0DH
		JZ  KLAST
		INC DH 
KLAST:	CMP DH,0
		RET
KEYCHECK	ENDP
CODE ENDS
END BEG 
