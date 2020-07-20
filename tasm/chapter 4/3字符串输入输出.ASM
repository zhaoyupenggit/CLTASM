;询问用户名字并打印到屏幕ask the user for his name and print it to the screen
;ppt chapter 4,example for the instructions for DOS
;21H的9号功能打印字符串mov ah 09h (int 21h) print string
;21H的0AH功能获取字符串move ah 0ah(int 21h) get string
 .386
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
      INT 21H;打印提示信息
      MOV AH,0AH
      MOV DX,OFFSET BUF
      INT 21H;获取字符串

      MOV BL,BUF+1
      MOV BH,0
      MOV SI,OFFSET BUF+2
      MOV BYTE PTR[BX+SI],'$';加工字符串
      MOV AH,02H
      MOV DL,0AH
      INT 21H;换行

      MOV AH,09H
      MOV DX,OFFSET BUF+2
      INT 21H;打印字符串
      MOV AH,4CH
      INT 21H

CODE ENDS
END BEG
