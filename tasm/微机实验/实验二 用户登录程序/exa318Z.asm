;filename exa318.asm
;程序执行后,给出操作提示，请用户输人用户名和密码
;用户在输人密码时，程序不回显输入字符
;只有当用户输人的用户名、 密码字符串和程序内定的字符串相同时，才显示欢迎界面，并返回DOS。
; 界面颜色自定(彩色或黑白)。
;--------------------------------------------
.486
DISP	MACRO	Y, X, VAR, LENGTH, COLOR
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
MESG1 DB 'welcome to 東氏 login systerm'
L     =  $-MESG1
MESG2 DB 'please input your name'
LL    =  $-MESG2
MESG3 DB 'please input your password'
LLL   =  $-MESG3
MESG4 DB 'NO information of this username'
MESG5 DB 'wrony password'
MESG6 DB 'login successfully'
MESG7 DB 'welcome'
NAME1 DB '1804'
PASS1 DB '0215'
NAME2 DB 'LENA'
PASS2 DB 'JOBS'
NAMEI DB 8 DUP(?)
PASSI DB 8 DUP(?)
BUF   DB 10
	  DB ?
	  DB 10 DUP(?)
DATA ENDS

CODE SEGMENT USE16
	ASSUME DS:DATA,CS:CODE,ES:DATA
BEG:	MOV AX,DATA
		MOV DS,AX
		MOV ES,AX
		MOV AX,3   
		INT 10H   
		DISP 10,(80-L)/2,MESG1, L,4
		DISP 14,(80-LL)/2,MESG2, LL,2
		MOV BH,0
		MOV DH,16
		MOV DL,36
		MOV AH,02H
		INT 10H
		;输入用户名
		MOV AH,0AH
		MOV DX,OFFSET BUF
		INT 21H
		LEA SI,BUF+2
		MOV BL,BUF+1
		mov BH,0
		DISP 1,1,BUF,BX,2
		DISP 15,(80-LLL)/2,MESG3, LLL,2
		
	
	
	
	MOV AH ,4CH
	INT 21H
	
CODE ENDS
END BEG
	