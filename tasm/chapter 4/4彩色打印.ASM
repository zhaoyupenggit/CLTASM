;彩色打印
;example of the use of BIOS INT 10H
;from ppt chapter 4
.386
DATA SEGMENT USE16
MESG1   DB 'HELLO$'
MESG2   DB 'I AM A STUDENT'
LL      =  $-MESG2
DATA ENDS

CODE SEGMENT USE16
        ASSUME CS:CODE
        ASSUME DS:DATA
        ASSUME ES:DATA;将数据段与附加段定义在一起
 BEG:   MOV AX,DATA
        MOV DS,AX
        MOV ES,AX

        MOV AX,0003H
        INT 10H ;SET 80x25 colour screen
        MOV AH,9
        MOV DX,OFFSET MESG1
        INT 21H;DOS09H显示字符串，响应ctrl_C
        MOV AX,1301H;AL=0~3,0/1可以实现彩色打印字符
        MOV BH,0;设置打印位置所在页
        MOV BL,01001111B;颜色，背景等代表的属性字
        MOV DH,12
		mov cx,LL
        MOV DL,(80-LL)/2
        MOV BP,OFFSET MESG2
        INT 10H
        MOV AH,4CH
        INT 21H
        CODE ENDS
        END BEG

