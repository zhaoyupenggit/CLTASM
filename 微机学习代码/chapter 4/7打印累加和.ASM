;from the chapter 4 page 66
;EXAMPLE of LOOP
;return the 1+2+...+100
.386
DATA SEGMENT USE16
SUM     DW ?
BUF     DB '1+2+...+100=', 4 DUP(?) ,'H $'
COUNT   DB 4
DATA ENDS
CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG: MOV AX,DATA
      MOV DS,AX
      MOV AX,0
      MOV CX,100
AGAIN:ADD AX,CX
      LOOP AGAIN
      MOV SUM,AX         ;calculate

      MOV DX,AX
      SAL EDX,16;
      CALL N2_16ASC
      MOV AH,9
      MOV DX,OFFSET BUF
      INT 21H           ;display the SUM

      MOV AH, 4CH
      INT 21H

N2_16ASC PROC
      MOV SI,OFFSET BUF
      ADD SI,12
      MOV COUNT,4
LAST: ROL EDX,4
      AND DL,0FH
      CMP DL,10
      JC  NEXT
      ADD DL,7
NEXT: ADD DL,30H
      MOV [SI],DL
      INC SI
      DEC COUNT
      JNZ LAST
      RET
 N2_16ASC ENDP
 CODE ENDS
    END BEG
