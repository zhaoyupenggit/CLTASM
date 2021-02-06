;prints data from vector into console using graphics
;white bg and yellow symbol if for odd numbers
;white bg and green symbol is for even numbers
;black bg and red symbol is for zero

.model small
.data 
W_BG_Y_SYM Equ 01111110b ; white background, yellow symbol	; odd
W_BG_G_SYM Equ 01110010b ; white background, green symbol ;even
BLACK_BG_R_SYM Equ 0000100b; bkack bg and red foreground	;zero
BLACK_BG_W_SYM	Equ 0000111b;for splitter sign

M    Equ    3 ;colons
Vector    DW    12 ,3, 0
.code
.startup
	mov	ax, 13	; row
	mov	bx, 39	; col

	; calculate offset of the position in the video memory 
	dec	ax	; row-1
	mov	dl, 80	; 
	imul	dl	; (row-1)*80
	dec	bx	; col-1
	add	ax, bx	; (row-1)*80 + (col-1)
	add	ax, ax	; *2

	; set address 
	mov	bx, 0B800h
	mov	es, bx	; segment value for text mode video memory
	mov	di, ax	; calculated offset
 
	; write symbols and attributes
    mov bx,0
    mov cx,M
    ;BE AWARE DI+BX CAN ONLY BE TO INCRASE INDEX REGISTER OTHERWISER ERROR!
loopec:
	mov ax,Vector[bx]	
;--if value is zero
	cmp ax,0
	jne check_on_even
	add ax,48 ;convert into char
	mov	word ptr es:[di+BX], ax
	mov	word ptr es:[di+BX+1], BLACK_BG_R_SYM 

	jmp next
;--if value is even
check_on_even:
	test ax,1
	jnz number_is_odd
	add ax,48 ;convert into char W_BG_G_SYM
	mov	word ptr es:[di+BX], ax
	mov	word ptr es:[di+BX+1], W_BG_G_SYM ; white background, yellow symbol
	jmp next
;-- if val is odd
number_is_odd:
	add ax,48 ;convert into char
    mov	word ptr es:[di+BX], ax
	mov	word ptr es:[di+BX+1], W_BG_Y_SYM ; white background, yellow symbol
next:
	add bx,2
   loop loopec
	xor ax,ax
.exit
end