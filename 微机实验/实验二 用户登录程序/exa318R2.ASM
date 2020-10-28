;用户登录验证程序的实现
;程序执行后,给出操作提示，请用户输人用户名和密码;用户在输人密码时，程序不
;回显输入字符;只有当用户输人的用户名、 密码字符串和程序内定的字符串相同时，才显示欢迎界面，并返回DOS。 
;界面颜色自定(彩色或黑白)。
;输入用户名如果不正确就立即报错提示重新输入
;------------------------------------------------------------------
;使用DOS功能调用来实现界面显示功能
.386
SCOMP MACRO S1,L1,S2,L2
		LOCAL NEQ,CEQ,IEQ
		MOV CL,L1
		CMP CL,L2
		JNZ NEQ
		MOV CH,0
		LEA BX,S1
		LEA SI,S2
CEQ:	MOV AL,[SI]
		CMP AL,[BX]
		JNZ NEQ
		INC SI
		INC BX
		LOOP CEQ
		JMP IEQ
NEQ:    MOV FLAG,'N'
IEQ:
endm

DATA SEGMENT USE16
LNAM	= 10;最大用户名长度
LKEY   	= 10;最大密码长度
NAM    	DB 'Bleqbs13'
L     	=$-NAM
KEY   	DB 'leqbs13'
LL    	=$-KEY
NAMI  	DB LNAM
		DB ?
	    DB LNAM DUP(?);用于键入用户名信息
KEYI    DB ?
		DB LKEY DUP(?);用于键入密码信息
FLAG    DB 'y'
MESGNAM DB '>-++->INPUT YOUR NAME: '
DB '$'
MESGKEY DB 0AH,0DH,'>-++->INPUT YOUR KEY : '
DB '$'
MESGERR DB 0AH,0DH,'( -^- )INCORRECT KEY OR NAME ,PLEASE TRY AGAIN',0DH,0AH
DB '$'
MESGWEL DB 0AH,0DH,'(~ v ~) WELCOME!LOGIN SUCCESSFULLY'
DB '$'
DATA ENDS

CODE SEGMENT USE16
	ASSUME DS:DATA,CS:CODE,ES:DATA
BEG:	MOV AX,DATA
		MOV DS,AX
		MOV ES,AX
		MOV AX,03H
		INT 10H;清理屏幕内容
START:	MOV FLAG,'y';输入用户名
INNAM:	MOV AH,9H
		MOV DX,OFFSET MESGNAM
		INT 21H
		MOV AH,0AH
		LEA DX,NAMI
		INT 21H
INKEY:	;输入密码
		MOV AH,9H
		MOV DX,OFFSET MESGKEY
		INT 21H	;提示用户输入密码
		LEA BX,KEYI
		MOV CX,LKEY
  KBEG:	MOV AH,08H
		INT 21H;输入一个字符
		CMP AL,0DH
		JZ  step
		INC BX
		MOV [BX],AL;保存该字符
		MOV AH,02H
		MOV DL,'*'
		INT 21H;输出掩码
		LOOP KBEG
   step:MOV BX,LKEY
		SUB BX,CX
		MOV KEYI,BL;记录密码串总长度
CHECK:  SCOMP NAM,L,NAMI+2,NAMI+1
		SCOMP KEY,LL,KEYI+1,KEYI
		CMP FLAG,'N'
		JNZ YES
NO:	    MOV AH,9H
		LEA DX,MESGERR
		INT 21H
		JMP START
YES:	MOV AH,9H
		LEA DX,MESGWEL
		INT 21H
		MOV AH,4CH
		INT 21H
CODE ENDS
END BEG

