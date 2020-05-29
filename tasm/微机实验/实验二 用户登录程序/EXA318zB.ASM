;第二次的代码
;filename exa318.asm
;程序执行后,给出操作提示，请用户输人用户名和密码
;用户在输人密码时，程序不回显输入字符
;只有当用户输人的用户名、 密码字符串和程序内定的字符串相同时，才显示欢迎界面，并返回DOS。
; 界面颜色自定(彩色或黑白)。
;--------------------------------------------
.486
DISP	MACRO	Y, X, VAR, LENGTH, COLOR;BIOS按照要求显示字符串
		 MOV         SP,CX
		 MOV         AH,13H
		 MOV         AL,1
		 MOV         BH,0                   ;选择0页显示屏
		 MOV         BL,COLOR                ;color属性字(颜色值) →BL
		 MOV         CX,LENGTH               ;LENGTH串长度 →CX
		 MOV         DH,Y                    ;Y行号 →DH
		 MOV         DL,X                    ;X列号 →DL
		 MOV         BP,OFFSET VAR           ;VAR串有效地址→BP
		 INT            10H
		 MOV          CX,SP
ENDM 
DATA SEGMENT USE16
LNAM  = 10;姓名支持的最大长度
LKEY  = 10;密码支持的最大长度
LPT   = 10;打印的起始行数
NAMEI DB ?;存入键入的姓名所在的记录的地址
FLAG  DW ?;判断支付串是否正确的标志符号
KEYI DB 10 DUP(?)
BUF   DB 10
	  DB ?
	  DB 10 DUP(?)
DATA ENDS

EDATA SEGMENT USE16
NAM   DB '1804','$';姓名列表
KEY   DB '0215',0DH;密码列表
NAME1 DB 'LENA','$'
PASS1 DB 'JOBS',0DH
LCHECK =  $-NAM
ENDD  DB ?

MESG1 DB 'welcome to 東氏 login systerm'
L     =  $-MESG1
MESG2 DB 'please input your NAME'
LL    =  $-MESG2
MESG3 DB 'please input your password,YOU have THERE chance'
LLL   =  $-MESG3
MESG4 DB 'NO information of this username'
MESG5 DB 'INCORRECT KEY,PLEASE CX AGAIN'
MESG7 DB ' Welcome!login successfully'
L7    =  $-MESG7
MESG8 DB ' login failed'
L8    =  $-MESG8
EDATA ENDS

CODE SEGMENT USE16
	ASSUME DS:DATA,CS:CODE,ES:EDATA
BEG:	MOV AX,DATA
		MOV DS,AX
		MOV AX,EDATA
		MOV ES,AX
		MOV AX,3   
		INT 10H ;设置屏幕显示方式  
		DISP LPT,(80-L)/2,MESG1, L,4;欢迎界面
		;输入用户名
		DISP LPT+1,(80-LL)/2,MESG2, LL,2
FIRST:	MOV BH,0
		MOV DH,LPT+2
		MOV DL,36
		MOV AH,02H
		INT 10H	;设置光标位置	
		MOV AH,0AH
		MOV DX,OFFSET BUF
		INT 21H;读入用户键入的字符串放在buf中
		MOV FLAG,OFFSET NAM 
   STE:	CALL SCOMP
		CMP FLAG, OFFSET ENDD
		JNC FIRST
		JNZ  STE
		
		;输入密码		
		MOV CX,3
		DISP LPT+3,(80-LLL)/2,MESG3, LLL,2
SECOND:	MOV DH,LPT+7
		MOV BH,0
		SUB DH,CL
		MOV DL,36
		MOV AH,02H
		INT 10H
		CALL KEYCHECK
		JZ   YES		
		LOOP SECOND
		DISP 25,40,MESG8,L8,4
		JMP LAST		

		;登录结果反馈
NO:	    DISP LPT+8,(80-L8)/2,MESG8,L8,4
YES:	DISP LPT+8,(80-L7)/2,MESG7,L7,4
LAST:	MOV AH ,4CH
	    INT 21H
;---------检查用户名是否正确-------
; NAMECHECK PROC
		; LEA SI, BUF+2;键入用户名的起始地址
		; MOV BL, BUF+1
		; MOV BH, 0;加入用户名的实际字符数
		; MOV CX,LCHECK
; NNEX:	LEA DI,NAM;读取已经注册的用户数据
		; CMP BYTE PTR[DI],BYTE PTR[SI];		
		; JNZ NNO
		; Inc BH		
		; CMP BH,BL
		; JZ  NLAST
		; LOOP NNEX
		; CMP [DI],'$'

		; CMP [DI],0DH
		

; NLAST:  		
; RET
; NAMECHECK ENDP
;----------字符串比较程序-----------
SCOMP PROC;正确Z为1 错误Z为0
		MOV DI,FLAG
		MOV CL,BUF+1
		MOV CH,0
		LEA SI,BUF+2
		CLD
		REPE CMPSB
		JNZ SNO
		CMP BYTE PTR [DI],'$'
		JMP  SYES
SNO:	CMP BYTE PTR [DI],0DH
		JZ  SEXIT
		INC DI
		JMP SNO
SYES:   
SEXIT: MOV FLAG,DI
RET
SCOMP ENDP
;---------检查密码是否正确---------
KEYCHECK  PROC

		mov BP,cx
	    MOV CX,LKEY
		LEA BX,KEY	
		MOV DH,0
KBEG:	MOV AH,08H
		INT 21H
		CMP AL,0DH
		JZ  KNEX
		CMP [BX],AL
		JZ  KSTEP
		MOV DH,1
  KSTEP:INC BX    
		MOV AH,02H
		MOV DL,'*'
		INT 21H
		LOOP KBEG
KNEX:   MOV CX,BP	
		CMP DH,0
		RET
KEYCHECK	ENDP
CODE ENDS
END BEG

