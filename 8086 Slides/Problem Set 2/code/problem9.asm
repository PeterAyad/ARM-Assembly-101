toLowerCase macro array 

    ; string ends in $

    ; the difference between ascii small and capital is 32
    ; 'a' is 97, 'A' is 65

    local myLoop, not_letter,my_end

        lea si,array

myLoop: 

        mov al,[si]

        cmp al,'$'
        je end:

        cmp al,'A'
        jl not_letter        ; if not between 'a' and 'A', then not upper case
        cmp al,'Z'
        jg not_letter

        add al,32
        mov [si],al

not_letter:
        inc si  
        jmp myLoop

my_end:
endm toLowerCase


org 100h
jmp code

        string db "THIS IS AN UPPER CASE STRING $"  
        
code:
        toLowerCase string

        mov     dx, offset string  ; load offset of msg into dx.
        mov     ah, 09h            ; print function is 9.
        int     21h                ; do it!
        
        mov     ah, 0 
        int     16h      ; wait for any key....
