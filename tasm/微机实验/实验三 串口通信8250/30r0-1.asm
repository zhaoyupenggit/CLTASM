;将打印字符改成BIOS的功能调用
.586
DATA	SEGMENT USE16
TEXT	DB    'THE tie tied the tiger'
DB      0DH,0AH
LLL	EQU     $-TEXT
ERROR DB      'COM1 BAD !',0DH,0AH,'$'
DATA 	ENDS
CODE	SEGMENT USE16
    ASSUME  CS:CODE,DS:DATA
BEG: 	MOV     AX,DATA
        MOV     DS,AX
        CALL    I8250;主串口初始化
        ;循环体
AGAIN:  MOV     CL,LLL 	;字符串长度送CL
        MOV     BX,OFFSET TEXT  ;字符串地址
TSCAN:	MOV     DX,3FDH         ;通信线状态寄存器
        IN      AL,DX
        TEST    AL,20H          ;D6为1则表示发送移位寄存器空闲
        JZ      TSCAN  		;不空闲就继续查询
        MOV     AL,[BX]  	;取字符
SEND: 	MOV     DX,3F8H         ;**发送保持寄存器**/接收缓冲寄存器
        OUT     DX,AL 		;发送到主串口

        MOV     SI,0
RSCAN:	MOV     DX,3FDH         ;通信线状态寄存器
        IN      AL,DX           
        TEST    AL,01H 		;D0 接收数据准备好标志位 为1表示已接收到一帧完整数据
        JNZ     REVEICE	;收完转
        DEC     SI		;SI从FFFFH到0000H,共65536
        JNZ     RSCAN  		;延时
        JMP     DISPERR	;超时,转出错处理
REVEICE:MOV     DX,3F8H         ;发送保持寄存器/**接收缓冲寄存器**
        IN      AL,DX		;读数据寄存器
        AND     AL,7FH
DISP:	MOV     AH, 0eh
        INT     10H   		;屏幕显示
        INC     BX
        DEC     CL  		;计数
        JNZ     TSCAN
        ;循环体
        JMP     RETURN
DISPERR:MOV     AH,9
        MOV     DX,OFFSET ERROR
        INT     21H  		;显示出错信息
RETURN:	MOV     AH,4CH
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
        OUT     DX,AL 		;8250收发方式,禁止中断
    RET
    I8250     ENDP
CODE      ENDS
END     BEG
