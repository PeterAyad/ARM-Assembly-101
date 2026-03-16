org 100h
                 
jmp code

    msg1 db "Enter the first number: $"
    msg2 db 0Dh, 0Ah, "Enter the second number: $"
    msg3 db 0Dh, 0Ah, "The total sum is: $"
    
    num1 db 8, ? ,7 dup('0')
    num2 db 8, ? ,7 dup('0')
    result db 8 dup(" "),"$"  ; Result buffer


code:
    ; Display prompt for the first number
    lea dx, msg1
    mov ah, 09h
    int 21h
    
    ; Read the first number
    lea dx, num1
    mov ah, 0Ah
    int 21h

    ; Display prompt for the second number
    lea dx, msg2
    mov ah, 09h
    int 21h

    ; Read the second number
    lea dx, num2
    mov ah, 0Ah
    int 21h               
    

    lea si, num1+8     
    lea di, num2+8
    lea bx, result+7
    
         
    mov cx,7     
    xor ax,ax
    xor dx,dx
    
    ; No need for conversion
    ; Loop through the bytes         
    addition_loop:                   
         xor ax,ax
    ;   Convert from ASCII to decimal
        mov al,[si]
        sub al,'0'   
        
    ;   Add carry
        add al,dh
        
        mov dl,[di] 
        sub dl,'0'
    
    ;   Add
        add al,dl
    
    ;   Adjust result      
        aaa
    ;   Convert to ASCII and store AL in the buffer
                   
        ; Save carry
        mov dh,ah  
        
        ; Convert to ASCII
        add al,'0'
        
        ; Write to Result
        mov [bx],al

    
        dec si
        dec di
        dec bx
    loop addition_loop
    
    ; Check if there is an extra carry
    cmp ah,1
    jne no_carry   
    add ah,'0'              
    mov [bx],ah
    jmp print
    
no_carry:     
               mov [bx]," "   

print:
    ; Display the result message
    lea dx, msg3
    mov ah, 09h
    int 21h

    ; Display the sum
    lea dx, result
    mov ah, 09h
    int 21h


    hlt
