;from ppt chapter 4  page79
;example of macro
;BIOS macro
.386
DISP MACRO Y,X,VAR,LENGTH,COLOR
        MOV AH,13H
        MOV AL,1
        MOV BH,0
        MOV BL,COLOR
        MOV CX,LENGTH
        MOV DH,Y
        MOV DL,X
        MOV DL,X
        LEA BP,VAR
        INT 10H
ENDM
EDATA SEGMENT USE16
        SS1 DB 'HELLO'
        SS2 DB 'WELCOME'
        SS3 DB 'BYE_BYE'
 EDATA ENDS
CODE SEGMENT USE16
ASSUME CS:CODE,ES:EDATA
 beg:   MOV AX,EDATA
        MOV ES,AX
        MOV AX,3
        INT 10H
        DISP 0,5,SS1,5,2
        DISP 12,36,SS2,8,4
        DISP 24,66,SS3,7,0EH
  SCAN: MOV AH,1
        INT 16H
        JZ SCAN

        MOV AX,2
        INT 10H
        MOV AH,4CH
        INT 21H
     CODE ENDS
     END BEG

