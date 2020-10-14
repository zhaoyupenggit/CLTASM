;用户登录验证程序的实现
;程序执行后,给出操作提示，请用户输人用户名和密码;用户在输人密码时，程序不
;回显输入字符;只有当用户输人的用户名、 密码字符串和程序内定的字符串相同时，才显示欢迎界面，并返回DOS。 
;界面颜色自定(彩色或黑白)。
;输入用户名如果不正确就立即报错提示重新输入
;------------------------------------------------------------------
;主要使用BIOS功能调用来实现的相关功能
.386
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
LNAM  	= 10;姓名支持的最大长度
LKEY  	= 10;密码支持的最大长度
LPT   	= 10;打印的起始行数
LTIME   = 3;设置用户可以尝试的最大次数，注意修改第47行左右的字符串

NAM  	DB '1','$';姓名列表
KEY   	DB '1',0DH;密码列表
NAME1 	DB 'LENA','$'
PASS1 	DB 'JOBS',0DH
NAME2 	DB 'lau','$'
PASS2 	DB '.',0DH
ENDD  	DW ?,?

BUF   	DB LNAM+1
		DB ?
		DB LNAM+1 DUP(?);用来作为存储用户名的缓冲区
;下面是字符串
MESGN 	DB LNAM DUP(' ')
MESGP 	DB 'No.'
		DB ?
MESG1 Db 'welcome to THE login systerm'
L     =  $-MESG1
MESG2 DB 'please input your NAME'
LL    =  $-MESG2
MESG3 DB 'please input your password,YOU have THERE chance'
LLL   =  $-MESG3

MESG4 DB 'NO information!PLEASE input AGAIN'
L4    =  $-MESG4
MESG5 DB 'INCORRECT!TRY AGAIN'
L5    DB '$'

MESG7 DB ' Welcome!ENJOY your time'
L7    =  $-MESG7
MESG8 DB 'LOGIN failed',0DH,0ah
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

		DISP LPT,(80-L)/2,MESG1, L,1FH;欢迎界面

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
		DISP LPT+3,40-L4/2,MESG4,L4,4;
		JMP FIRST

		;输入密码
SEC:	DISP LPT+3,(80-LLL)/2,MESG3, LLL,2
		MOV CX,LTIME
SECOND:
		MOV DH,LPT+LTIME+3+1
		MOV BH,0
		SUB DH,CL
		MOV DL,(80-LKEY)/2
		MOV AH,02H
		INT 10H;设置光标位置
		CALL KEYCHECK
		JZ   YES
		CMP CX,1
		JZ  NO
		MOV AH,09H
		MOV DX,OFFSET MESG5
		INT 21H
		LOOP SECOND

		;登录结果反馈
NO:	    DISP LPT+LTIME+5,(80-L8)/2,MESG8,L8,4
		JMP LAST
YES:	DISP LPT+LTIME+6,0,MESG7,L7,1FH
		MOV AH,09H
		LEA DX,MESG9
		INT 21H
		MOV BL,BUF+1
        MOV BH,0
        MOV SI,OFFSET BUF+2
        MOV BYTE PTR[BX+SI],'$'
		MOV AH,09H
		MOV DX,OFFSET BUF+2
		INT 21H
LAST:	MOV AH ,4CH
	    INT 21H


;------------------------字符串比较-------------------------
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
;--------------------检查密码是否正确----------------------
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
