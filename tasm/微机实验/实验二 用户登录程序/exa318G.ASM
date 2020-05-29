
;--------------------------------------------
.486
DATA SEGMENT USE16
flag  DB ?
MESG1 DB 'error input again',0ah,0dh
db '$'
MESG2 DB 'please input your NAME: '
db '$'
MESG3 DB 0ah,0dh,'please input your password: '
db '$'
MESG4 DB 'NO information of this username'
MESG5 DB 0ah,0dh,'INCORRECT KEY or name ,PLEASE try AGAIN',0dh,0ah
db '$'
MESG7 DB 0ah,0dh,' Welcome!login successfully'
db '$'
MESG8 DB ' login failed'
db '$'

NAM   DB 'B18040215'
ln    DB $-nam
KEY   DB '0'
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
	ASSUME DS:DATA,CS:CODE
BEG:	MOV AX,DATA
		MOV DS,AX
		mov ax,03h
		int 10h
start:	mov flag,1;设置标记

		;输入用户名
		mov ah,9h
		mov dx,offset mesg2
		int 21h	
FIRST: 	MOV AH,0AH
		MOV DX,OFFSET BUF
		INT 21H	
		
		;输入密码		
		mov ah,9h
		mov dx,offset mesg3
		int 21h	
		

SECOND:	CALL KEYCHECK
		CALL NAMECHECK	
		cmp flag,1
		jz yes
		;登录结果反馈
NO:	    mov ah,9h
		mov dx,offset mesg5
		int 21h	
		jmp start
YES:	mov ah,9h
		mov dx,offset mesg7
		int 21h	
LAST:	MOV AH ,4CH
	    INT 21H
;---------检查用户名是否正确-------
NAMECHECK PROC
		mov  bx,offset buf+1
		mov  si,offset nam
		mov cl,[bx]
		cmp cl,ln
		jnz nno
		inc bx
		mov ch,0
nbeg:	mov al,byte ptr [si]
		cmp al,[bx]
		jnz nno
		inc bx
		inc si
		loop nbeg
		jmp nend
nno:mov flag,0	
nend:
ret
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
		jz kend	
		mov flag,0			
kend :	
		RET
KEYCHECK	ENDP
CODE ENDS
END BEG

