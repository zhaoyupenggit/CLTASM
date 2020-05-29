;example of the use of complex branchees
;from ppt chapter 4,page 61
;there are 9 people in a department 
;calculate the number of people whose incomes are between 2000 and 4000
;display them in the form of decimal numbers
.586
DATA SEGMENT USE16
NUM DW 1000,23232,2300,4895,2999,1299,8769,4545,9990
DATA ENDS
CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG:   MOV AX,DATA
        MOV DS,AX
        MOV BX,OFFSET NUM
        MOV CX,9 ;SET THE TIMES OF LOOP
        MOV DL,0  
 LAST:  CMP WORD PTR [BX] ,2000
         JC NEXT
        CMP WORD PTR [BX] ,4000
        JA NEXT
        INC DL
 NEXT:  INC BX
        INC BX;NUM IS WORD ,2BYTE
       LOOP LAST
        ADD DL,30H
        MOV AH,2
        INT 21H
        MOV AH,4CH
        INT 21H
CODE ENDS
        END BEG
