; Input Numbers Must Be 2 Places: To Input 4 Type 04
; No Enter Needed For Input

.MODEL SMALL
.STACK 100h

.DATA
    	A db ?
	B db ?
	e_A db ?
	e_B db ?
	result db ?
	x db ?
	y db ?
	color db 06h
        d1 db ?
        d2 db ?
        d3 db ?
	FirstNumberMSg db "Please enter the first number: ",10,13,"$"
	SecondNumberMSg db 10,13,"Please enter the second number: ",10,13,"$"

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
        mov al,e_A
        mov bl,e_B
        mul bl
	Cmp al, result
	Jnz No
	mov color, 04
	Jmp endColor
	No:
	mov color, 07
	endColor:
	ret
SetColor ENDP

ReadNumber MACRO
    mov ah,01
    int 21h
    sub al,30h
    mov ah,00
    mov cl,10
    mul cl       ; AL * 10, result in AX
    mov bl, al   ; store tens place in BL

    mov ah,01
    int 21h
    sub al,30h
    add bl, al   ; BL now has full result (tens + units)
    mov al, bl   ; move final result to AL
ENDM ReadNumber



DisplayNumber Proc; Display the number saved in AX

	mov AX,00
	mov al, result
	mov dl, 100        ; Set DL to 5 (divisor)
	div dl           ; AX / DL -> AL = 10, AH = 0
	; Quotient 10 is in AL, remainder 0 is in AH
	mov d1,ah
	mov dl,al
	add dl,30h ; to convert to ASCII
	mov al,dl
	mov ah,09
        mov bh,00
	mov bl,color
	mov cx,01
	INT 10h
	
	mov cl,x
        add cl,1
        mov x,cl
        call SetCursor

	
	mov ah,00
	mov al,d1
	mov dl, 10
	div dl
	mov d1,ah
	mov dl,al
	add dl,30h ; to convert to ASCII
	mov al,dl
	mov ah,09
	mov bl,color
        mov bh,00
	mov cx,01	
	INT 10h


        mov cl,x
        add cl,1
        mov x,cl
        call SetCursor

	
	mov al,d1
	mov dl,al
	add dl,30h ; to convert to ASCII
	mov al,dl
	mov ah,09
	mov bl,color
        mov bh, 00
	mov cx,01	
	INT 10h

        ;mov cl,x
        ;add cl,1
        ;mov x,cl
        ;call SetCursor

	ret
DisplayNumber ENDP

DisplayString MACRO STR
        MOV AH, 09h          ; DOS interrupt to display string
        LEA DX, STR          ; Load address of the STR into DX
        INT 21h              ; Call DOS interrupt
ENDM DisplayString 

ReadString MACRO STR
        MOV AH,0Ah
        LEA DX, STR
        INT 21h
ENDM ReadString

Multiply PROC near
	MOV Ax, 00h
	Mov al, B
        Mov cl, A
        mul cl
	mov result,al
	ret
Multiply ENDP

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
    DisplayMessage FirstNumberMSg 
    ReadNumber 
    mov e_A, al
    DisplayMessage SecondNumberMSg 
    ReadNumber
    mov e_B,al
    mov cx,12
    Outer_loop:
    mov A, cl
    push cx
    mov cx, 12
    Inner_loop:
    mov B,cl
    
    mov bl,10
    add bl,A
    mov y,bl
    
    mov bl,cl
    shl bl, 1
    shl bl,1  
    add bl,cl  
    mov x,bl
    call SetCursor
    push cx
    call Multiply
    call SetColor
    call DisplayNumber
    pop cx
    loop Inner_loop
    pop cx
    Loop Outer_loop
    mov al,23
    mov y, al
    mov al, 0
    mov x, al
    call SetCursor 
    ; Exit program
    MOV AH, 4Ch          ; DOS interrupt to exit
    INT 21h              ; Call DOS interrupt

MAIN ENDP


END MAIN
