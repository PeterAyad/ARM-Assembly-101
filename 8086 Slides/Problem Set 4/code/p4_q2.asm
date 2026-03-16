; No Enter Needed For Input

.MODEL SMALL
.STACK 100h

.DATA
    	
	x db ?
	y db ?
	color db 06h
        d1 db ?
        d2 db ?
        d3 db ?
	EnterMsg db "Please Enter two Characters: ",10,13,"$"
        Msg1 db ?
	Msg2 db ?
        c_Msg1 db ?
        c_Msg2 db ?
	
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
	mov dl,c_Msg1
	Cmp dl,Msg1
	Jnz No
	mov dl,c_Msg2
	Cmp dl, Msg2
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
	and al,0DFh
        mov Msg1, al
        mov ah,01
  	int 21h      ; hundreds number in ascii in al
	and al,0DFh
        mov Msg2, al
ENDM ReadMessage 

Display2Char Proc
	mov al,c_Msg1
	mov ah,09
        mov bh,00
	mov bl,color
	mov cx,01
	INT 10h

        mov cl,x
        add cl,1
        mov x,cl
        call SetCursor
 	
	mov al,c_Msg2
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
    mov al,'A'
    mov c_Msg1,al
    Outer_loop:
    mov ah, 'A'
    mov c_Msg2,ah
    Inner_loop:
    
    mov bh, c_Msg2
    sub bh,'A'
    shl bh,1
    add bh, c_Msg2
    sub bh,'A'
    mov x,bh
    mov bh, c_Msg1
    sub bh, 'A'
    add bh,1
    mov y, bh
    call SetCursor
    call SetColor
    call Display2Char
    mov ah, c_Msg2
    inc ah
    mov c_Msg2,ah
    Cmp ah,'Z'+1
    Jnz Inner_loop
    mov al, c_Msg1
    inc al
    mov c_Msg1, al
    Cmp al, 'Y'+1
    Jnz Outer_loop

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
