
;--------------------------------------------
.486
DISP	MACRO	Y, X, VAR, LENGTH, COLOR
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
flag  DB ?
MESG1 DB 'welcome to  login systerm'
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

NAM   DB 'name'
ln    DB $-nam
KEY   DB 'key'
Lk    =  $-key
LNAM  = 10
LKEY  = 10
LPT   = 10
NAME1 DB 'LENA'
PASS1 DB 'JOBS'
NAMEI DB 10 DUP(?)
KEYI DB 10 DUP(?)
BUF   DB 10
	  DB ?
	  DB 10 DUP(?)
BUFP  DB 10
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
		DISP LPT,(80-L)/2,MESG1, L,4;欢迎界面
		;输入用户名
		DISP LPT+1,(80-LL)/2,MESG2, LL,2
		MOV BH,0
		MOV DH,LPT+2
		MOV DL,36
		MOV AH,02H
		INT 10H
FIRST: 	MOV AH,0AH
		MOV DX,OFFSET BUF
		INT 21H
		;输入密码
		DISP LPT+3,(80-LLL)/2,MESG3, LLL,2
SECOND:	MOV DH,LPT+7
		MOV BH,0
		SUB DH,CL
		MOV DL,36
		MOV AH,02H
		INT 10H
		CALL KEYCHECK
		CALL NAMECHECK
		JZ   YES
		LOOP SECOND
		DISP 25,40,MESG8,L8,4
		JMP LAST

		;登录结果反馈
NO:	    DISP LPT+8,(80-L8)/2,MESG8,L8,4
		jmp beg
YES:	DISP LPT+8,(80-L7)/2,MESG7,L7,4
LAST:	MOV AH ,4CH
	    INT 21H
;---------检查用户名是否正确-------
NAMECHECK PROC
		lea bx,buf+1
		lea si,nam
		cmp [bx],byte ptr ln
		jnz nno
		inc bx
		mov cx,ln
nbeg:	cmp [bx],[si]
		jnz nno
		inc bx
		inc si
		loop nbeg
		mov flag,1
nno:	mov flag,0
NAMECHECK ENDP
;---------检查密码是否正确---------
KEYCHECK  PROC
	    MOV CX,LKEY
		LEA BX,KEY
		MOV DH,0
kBEG:	MOV AH,08H
		INT 21H
		CMP AL,0DH
		JZ  kNEX
		CMP [BX],AL
		JZ  STEP
		inc DH
   STEP:INC BX
		MOV AH,02H
		MOV DL,'*'
		INT 21H
		LOOP kBEG
kNEX:   CMP DH,0
		jnz kend
		mov flag,1
kend :
		RET
KEYCHECK	ENDP
CODE ENDS
END BEG

