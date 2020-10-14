;对微机系统的串行口进行自发自收内环测试，
;需要发送的信息存储在数据段中，屏幕显示接收数据。
; 由于缺乏外环环境，因此本实验采用内环方式。
; 本代码使用查询方式发送、查询方式接受字符
.386
DATA	SEGMENT USE16
TEXT	DB    'THE tie tied the tired tiger,THE CANNER CAN CAN A CAN '
        DB      0DH,0AH
LLL	EQU     $-TEXT
DATA 	ENDS
CODE	SEGMENT USE16
    ASSUME  CS:CODE,DS:DATA
BEG: 	MOV     AX,DATA
        MOV     DS,AX
        CALL    I8250;主串口初始化
        ;循环准备
        MOV     CL,LLL 	;字符串长度送CL
        MOV     BX,OFFSET TEXT  ;字符串地址
        ;开始循环
SCAN:	MOV     DX,3FDH         ;访问通信线状态寄存器，检查是否可以发送
        IN      AL,DX
        TEST    AL,20H
        JZ      SCAN
SEND:   MOV     AL,[BX]  	;取字符
 	MOV     DX,3F8H         ;发送保持寄存器
        OUT     DX,AL 		;发送到主串口
RSCAN:	MOV     DX,3FDH         ;访问通信线状态寄存器，检查是否可以接受
        IN      AL,DX
        TEST    AL,01H
        JZ      RSCAN
GET:    MOV     DX,3F8H          ;读接收缓冲寄存器
        IN      AL,DX
        AND     AL,7FH
DISP:	MOV     AH, 2            ;显示字符
        MOV     DL, AL
        INT     21H
        INC     BX
        DEC     CL
        JNZ     SCAN
        ;循环体结束
        MOV     AH,4CH
        INT     21H   		;返回 DOS
;----------------------------------
I8250     PROC           		;主串口初始化子程序
        MOV     DX,3FBH
        MOV     AL,80H
        OUT     DX,AL                 ;寻址位置1
        MOV     DX,3F9H
        MOV     AL,00H
        OUT     DX,AL                 ;写除数高8位
        MOV     DX,3F8H
        MOV     AL,60H
        OUT     DX,AL                 ;写除数低8位
        MOV     DX,3FBH
        MOV     AL,03H
        OUT     DX,AL		;无校验传送,8位数据
        MOV     DX,3F9H
        MOV     AL,00H
        OUT     DX,AL 		;禁止8250内部中断
        MOV     DX,3FCH
        MOV     AL,10H;D4为1内环自检
        OUT     DX,AL 		;8250内环收发方式,禁止中断
    RET
    I8250     ENDP
CODE      ENDS
END     BEG
