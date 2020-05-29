;ask the user for his name and print it to the screen
;ppt chapter 4,example for the instructions for DOS
;mov ah 09h (int 21h) print string
;move ah 0ah(int 21h) get string
 .586
DATA SEGMENT USE16
 MESG DB 0DH,0AH
      DB 'WHAT IS YOUR NAME?--$'
 BUF  DB 30
      DB ?
      DB 30 DUP(?)
DATA ENDS

CODE SEGMENT USE16
 ASSUME CS:CODE,DS:DATA
BEG:  MOV AX,DATA
      MOV DS,AX
AGAIN:MOV AH,09H
      MOV DX,OFFSET MESG
      INT 21H
      MOV AH,0AH

      MOV DX,OFFSET BUF
      INT 21H
      MOV BL,BUF+1
      MOV BH,0
      MOV SI,OFFSET BUF+2
      MOV BYTE PTR[BX+SI],'$'

      MOV AH,02H
      MOV DL,0AH
      INT 21H

      MOV AH,09H
      MOV DX,OFFSET BUF+2
      INT 21H
      MOV AH,4CH
      INT 21H

CODE ENDS
END BEG
