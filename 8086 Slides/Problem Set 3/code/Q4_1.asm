jmp code

    msg db 'What is your name? $'
    buffer db 20,?,19 dup(0)  ; Space for input

code:

    ; Clear the screen
    mov ah, 0x6     ; Scroll up function
    mov al, 0        ; Clear the entire screen
    mov bh, 0x7     ; Normal text attribute
    mov cx, 0        ; Top-left corner (row=0, col=0)
    mov dx, 0x184F   ; Bottom-right corner (row=24, col=79)
    int 10h          ; BIOS interrupt

    ; Move the cursor to row 15, column 20
    mov ah, 0x02     ; Set cursor position
    mov bh, 0        ; Page number
    mov dh, 15       ; Row
    mov dl, 20       ; Column
    int 10h

    ; Print "What is your name?"
    mov ah, 0x9     ; Print string function
    lea dx, msg      ; DS:DX -> String
    int 21h          ; DOS interrupt

    ; Read user input
    mov ah, 0xA     ; Buffered input
    lea dx, buffer   ; DS:DX -> buffer
    int 21h       
    xor bx, bx
    mov bl, buffer[1]
    mov buffer[bx+2], '$'
            
        
    ; Move the cursor to row 17, column 20
    mov ah, 0x2                   
    mov bh, 0        ; Page number
    mov dh, 17
    mov dl, 20
    int 10h

    ; Display entered name
    mov ah, 0x9     ; Print string function
    lea dx, buffer+2 ; Skip the first two bytes (length info)
    int 21h
    
    hlt
