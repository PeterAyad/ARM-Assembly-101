; INPUT NUMBERS MUST BE 2 PLACES: to input 4 type 04

.MODEL SMALL
.STACK 100h

.DATA
    	
	x db ?
	y db ?
	color db 06h
        d1 db ?
        d2 db ?
        d3 db ?
	EnterMsg db "Please Enter your number: ",10,13,"$"
        num1 db ?
	num2 db ?
        c_num1 db ?
        c_num2 db ?
	
.CODE
ClearScreen MACRO
mov ah,06h	;clear screen instruction
mov al,00h	;number of lines to scroll
mov bh,07h	;display attribute - colors
mov ch,00d	;start row
mov cl,00d	;start col
mov dh,24d	;end of row
mov dl,79d	;end of col
int 10h		;BIOS interrupt
ENDM

DisplayMessage MACRO str
	mov ah, 09
	lea dx, str
	int 21h
ENDM DisplayMessage

SetCursor Proc near
; set cursor
    push AX
    push BX
    push DX
    MOV AH,02
    MOV BH,00
    MOV DL,x  ; col
    MOV DH,y  ; row
    INT 10H
    pop DX
    pop BX
    pop AX
    ret
SetCursor ENDP
    

SetColor PROC near
	mov dl,c_num1
	Cmp dl,num1
	Jnz No
	mov dl,c_num2
	Cmp dl, num2
	Jnz No
	mov color, 04
	Jmp endColor
	No:
	mov color, 07
	endColor:
	ret
SetColor ENDP

ReadMessage MACRO; Read string from usersave it Msg1 and Msg2
	mov ah,01
  	int 21h      ; hundreds number in ascii in al
	mov num1, al
        mov ah,01
  	int 21h      ; hundreds number in ascii in al
	mov num2, al
ENDM ReadMessage 

Display2Char Proc
	mov al,c_num1
	mov ah,09
        mov bh,00
	mov bl,color
	mov cx,01
	INT 10h

        mov cl,x
        add cl,1
        mov x,cl
        call SetCursor
 	
	mov al,c_num2
	mov ah,09
        mov bh,00
	mov bl,color
	mov cx,01
	INT 10h
	ret       
Display2Char ENDP


DisplayString MACRO STR
 MOV AH, 09h          ; DOS interrupt to display string
 LEA DX, STR          ; Load address of the STR into DX
 INT 21h              ; Call DOS interrupt
ENDM DisplayString 

GetXY Proc near
; Assume DI contains the dividend
mov     ax, di         ; Move DI into AX (dividend)
mov     dx, 0         ; Clear DX (high part of dividend)
mov     bx, 22          ; Load divisor (7) into BX
div     bx             ; Divide DX:AX by BX (AX contains quotient, DX contains remainder)
; After division:
; AX = Quotient
; DX = Remainder
mov bl,al
mov cl,3
shl bl,cl
add bl,7
mov x,bl

mov bl,dl
add bl,3
mov y,bl
ret
GetXY ENDP



MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    ClearScreen
    mov al,0
    mov x, al
    mov al,4
    mov y, al
    call SetCursor
    DisplayMessage EnterMsg 
    ReadMessage
    ClearScreen
    mov al,0
    mov x, al
    mov al,0
    mov y, al
    call SetCursor 
    mov al,'0'
    mov c_num1,al
    mov di,0
    mov cx,10
    Outer_loop:
    push cx
    mov ah, '0'
    mov c_num2,ah
    mov cx,10
    Inner_loop:
    push cx
    call GetXY
    inc di
    call SetCursor
    call SetColor
    call Display2Char
    mov al,c_num2
    inc al
    mov c_num2,al
    pop cx
    loop Inner_loop
    mov al,c_num1
    inc al
    mov c_num1,al
    pop cx
    loop Outer_loop

    mov al,24
    mov y, al
    mov al, 0
    mov x, al
    call SetCursor 
    ; Exit program
    MOV AH, 4Ch          ; DOS interrupt to exit
    INT 21h              ; Call DOS interrupt

MAIN ENDP


END MAIN
