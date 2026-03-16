.MODEL SMALL
.STACK 100h

.DATA
    	
	Days 		db 'SAT','SUN','MON','TUS','WED','THU'
	Sessions	db '1ST','2ND','3RD' ,'4TH' ,'5TH' ,'6TH' ,'7TH'
	Lectures	db 'GENN001',0,0,0,'CMPN201',0,0,'GENN001',0,0,0,'CMPN201',0,'MICN202','GENN001',0,0,0,'CMPN201',0,0,'GENN001',0,0,'AINN403','CMPN201',0,0,'GENN001',0,'NTWN303',0,'CMPN201','OOPN102',0,'GENN001',0,0,0,'CMPN201',0,0
	color db 06h
        pchar  db ?
	x db ?
        y db ?

	
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

PrintCharacter PROC near
	mov al,pchar
	mov ah,09
	mov bh,00
	mov bl,color
	mov cx,01
	INT 10h
	ret
PrintCharacter  ENDP

DisplayDays PROC near
	mov cx, 06
	mov si,17
	PrintDays:
	
	
	mov ah,cl
push cx
	mov cl,3
	shl ah, cl
	add ah,2
	mov x,ah
	mov ah,2
	mov y,ah
	call SetCursor
	
	mov al,Days[si]
	mov pchar,al
	mov al,02
	mov color, al
	call PrintCharacter   
	dec si
pop cx
	mov ah,cl
push cx
	mov cl,3
	shl ah, cl
	add ah,1
	mov x,ah
	mov ah,2
	mov y,ah
	call SetCursor

	mov al,Days[si]
	mov pchar,al
	mov al,02
	mov color, al
	call PrintCharacter  	
	dec si
pop cx
	mov ah,cl
push cx
	mov cl,3
	shl ah, cl
	mov x,ah
	mov ah,2
	mov y,ah
	call SetCursor

	mov al,Days[si]
	mov pchar,al
	mov al,02
	mov color, al
	call PrintCharacter
pop cx
	dec si

	loop PrintDays
	ret
DisplayDays ENDP



DisplaySessions PROC
mov cx, 07
mov si,0
PrintSessions:

mov ah,0
mov x,ah
mov ah, 10
sub ah,cl
mov y,ah
call SetCursor

push cx


	mov al,Sessions[si]
	mov pchar,al
	mov al,04
	mov color, al
	call PrintCharacter
	inc si
pop cx


	mov ah,1
	mov x,ah
	mov ah, 10
	sub ah,cl
	mov y,ah
	call SetCursor

push cx
	mov al,Sessions[si]
	mov pchar,al
	mov al,04
	mov color, al
	call PrintCharacter
	inc si
pop cx

	mov ah,2
	mov x,ah
	mov ah, 10
	sub ah,cl
	mov y,ah
	call SetCursor

push cx
	mov al,Sessions[si]
	mov pchar,al
	mov al,04
	mov color, al
	call PrintCharacter
	inc si
pop cx


loop PrintSessions
ret
DisplaySessions ENDP

PrintBlank Proc near
push cx
mov cx, 8
printB:
	call SetCursor
	mov al," "
	mov pchar,al
	mov al,77h
	mov color, al
	push cx
	call PrintCharacter
	pop cx
	mov ah,x
	add ah,1
	mov x,ah
LOOP printB
ret
PrintBlank ENDP

PrintLecture Proc near
push cx
mov cx, 7
printL:
	call SetCursor
	mov al,Lectures[si]
	mov pchar,al
	mov al,07h
	mov color, al
	push cx
	call PrintCharacter
	pop cx
	mov ah,x
	add ah,1
	mov x,ah
	inc si
LOOP printL

pop cx
ret
PrintLecture ENDP

GetXY Proc near
; Assume DI contains the dividend
mov     ax, di         ; Move DI into AX (dividend)
mov     dx, 0         ; Clear DX (high part of dividend)
mov     bx, 7          ; Load divisor (7) into BX
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

DisplayLectures Proc near
	mov di,0 ; index relative to all
	mov si,0 ; index of byte in Lecture
	mov cx,42
	PrintLectures:
	;Set Start Location
	push cx
	call GetXY
	
	inc di
	mov ah, Lectures[si]
	cmp ah,0
	JNZ printLL
	call PrintBlank
	inc si
	Jmp endthis
	printLL:
	call PrintLecture
	endthis:
	pop cx
Loop PrintLectures
ret
DisplayLectures ENDP


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

MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    ClearScreen
    call DisplayDays
    call DisplaySessions 
    CALL DisplayLectures 
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
