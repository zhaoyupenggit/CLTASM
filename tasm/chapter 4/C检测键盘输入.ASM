;检测键盘是否有输入
;example of BIOS 16h 00 01 function
.386
DATA SEGMENT USE16
  MESG        DB  'BIOS INVOKES!', 0DH,0AH,'$'
  BUF         DB   ?
  NOPRESS     DB  'NO Press !   ', 0DH,0AH,'$'
  HAVEPRESS   DB  'Have press!  ', 0DH,0AH,'$'
 DATA ENDS

CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
BEG:    MOV AX,DATA
        MOV DS,AX
LAST:   MOV AH,9
        MOV DX,OFFSET MESG
        INT 21H
    ;TEST 16H
        ;BIOS 00H
        ;MOV AH,0
        ;INT 16H
SCAN:   MOV AH,9
        MOV DX, OFFSET NOPRESS
        INT 21H
        MOV AH,1
        INT 16H
        JZ SCAN

        ;MOV AH 0
        ;INT 16H
        ;MOV BUF,AL

        MOV AH,9
        MOV DX,OFFSET HAVEPRESS
        INT 21H

        MOV AH,4CH
        INT 21H
        CODE ENDS
  END BEG

        ;BIOS 01H

