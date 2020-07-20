;统计符合条件的对象数
;from ppt chapter 4,page 61
;符合分支示例example of the use of complex branchees
.386
DATA SEGMENT USE16
NUM DW 1000,23232,2300,4895,2999,1299,8769,4545,9990
DATA ENDS
CODE SEGMENT USE16
        ASSUME CS:CODE,DS:DATA
 BEG:   MOV AX,DATA
        MOV DS,AX
        MOV BX,OFFSET NUM
        MOV CX,9
        MOV DL,0;DL存放统计人数
 LAST:  CMP WORD PTR [BX] ,2000
         JC NEXT;<2000小于小值时转NEXT指令
        CMP WORD PTR [BX] ,4000
        JA NEXT;>4000大于大值时转NEXT指令
        INC DL;符合条件则计数加一
 NEXT:  INC BX
        INC BX;NUM IS WORD ,2BYTE
       LOOP LAST
        ADD DL,30H;DL=0~9ASCⅡ码
        MOV AH,2
        INT 21H;显示统计结果
        MOV AH,4CH
        INT 21H
CODE ENDS
        END BEG
