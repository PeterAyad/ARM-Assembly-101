

org 100h

jmp code

    grades db 81, 65, 77, 82, 73, 55, 88, 78, 51, 91, 86, 76
    new_grades db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    num_grades equ 12


code:

    ; We want to find maximum grade and put it in Al

        mov cx,0
        lea si, grades
        
        ; during compare we put in bl the current maximum

        mov bl, [si]
        inc cx
        inc si

myLoop: mov al,[si]
        cmp al,bl
        jng skip
        mov bl,al
skip:   inc si
        inc cx
        cmp cx, num_grades
        jne myLoop

        ; now largest number is in bl

        ; find the value we want to add = 99 - bl and store it in dl

        mov al,99
        sub al,bl

        mov dl, al

        mov cx,0
        lea si, grades
        lea di, new_grades
        
myLoop2: mov al,[si]
        add al,dl
        mov [di],al

        inc si
        inc di

        inc cx
        cmp cx, num_grades
        jne myLoop2