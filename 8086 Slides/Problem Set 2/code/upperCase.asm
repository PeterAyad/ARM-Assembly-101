toUpperCase macro array 

    ; string ends in $

    ; the difference between ascii small and capital is 32
    ; 'a' is 97, 'A' is 65

    local myLoop, not_letter

        lea si,array

myLoop: 

        mov al,[si]

        cmp al,'$'
        je end:

        cmp al,'a'
        jl not_letter        ; if not between 'a' and 'A', then not lower case
        cmp al,'z'
        jg not_letter

        sub al,32
        mov [si],al

not_letter:
        inc si  
        jmp myLoop

end:
endm toUpperCase


org 100h
jmp code

        string db "this is a lower case string $"  
        
code:
        toUpperCase string

        mov     dx, offset string  ; load offset of msg into dx.
        mov     ah, 09h            ; print function is 9.
        int     21h                ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....
