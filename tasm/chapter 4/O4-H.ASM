  .586
DATA  SEGMENT  USE16
NUM    DW   1000,23232,2300,4895,2999,1299,8769,4545,9990
DATA  ENDS
CODE  SEGMENT  USE16
      ASSUME   CS:CODE,DS:DATA
BEG:    MOV   AX,DATA
              MOV   DS,AX
              MOV   BX,OFFSET NUM
              MOV   CX,9
              MOV   DL,0                               ;DL存放统计人数
LAST:  CMP   WORD PTR [BX],2000        
              JC    NEXT                                    ;<2000时转NEXT指令
              CMP  WORD PTR[BX],4000         
 　           JA  　NEXT        ;>4000转NEXT指令              
            　INC   DL            ;DL+1→DL 
NEXT:　INC   BX          ;由于NUM是字单元,BX←BX＋2
            　INC   BX                           
           　 LOOP  LAST
          　  ADD   DL,30H       ;DL=0~9ASCⅡ码 
           　 MOV   AH,2			;显示统计结果
          　  INT   21H                          
           　 MOV   AH,4CH
            　INT   21H
CODE  ENDS
         END    BEG 
