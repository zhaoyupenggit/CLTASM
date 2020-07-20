;从键盘键入一个1位加数，一个1位被加数，并将他们的和显示在屏幕上
.386             
        CODE SEGMENT USE16
        BEG:
        MOV     AH,1     
        INT     21H     ;input the first number
        SUB     AL,30H  ;change the ASCII to its value
        MOV     DL,AL   ;save to Register DL

        MOV     AH,1         
        INT 21H         ;input the second number;
        SUB AL,30H      

        ADD     DL,AL   ;do the sum operation
        ADD    DL, 30H  ;change the value to ASCII
        MOV     AH,2    ;
        INT     21H     ;output the ascii code 显示结果

        MOV AH,4CH
        INT 21H         ;exit 
 CODE ENDS           
 END BEG
