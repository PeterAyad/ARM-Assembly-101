; BCD Operations

; DAA (Decimal Adjust AL after Addition): Adjusts the value in the AL register 
; after an addition operation to ensure a correct BCD result.

mov al, 38H   
add al, 45H   ; Works only if a nibble is greater than 1001
daa           

; DAS (Decimal Adjust AL after Subtraction): Adjusts the value in the AL register 
; after a subtraction operation to ensure a correct BCD result.

mov al, 95H   
sub al, 47H   ; Works only if a nibble is greater than 1001
das           

; ASCII-coded BCD Operations (similar to BCD but with one digit per byte, not per nibble)

; AAA (ASCII Adjust after Addition): Adjusts the value in the AL register
; after adding two BCDs, ensuring the result is two valid ASCII-coded BCDs in AX.

mov al, 9     
add al, 2     
aaa           ; AH = 01H, AL = 01H

; AAS (ASCII Adjust after Subtraction): Adjusts the value in the AL register 
; after subtracting two BCDs, ensuring the result is two valid ASCII-coded BCDs in AX.

mov al, 15H   
sub al, 5     
aas           ; AH = 01H, AL = 00H

; AAM (ASCII Adjust AX after Multiply): Adjusts the result of multiplying two  
; BCD numbers to produce a valid ASCII-coded BCD result in the AX register.

mov al, 9     
mov bl, 9     
mul bl        
aam           ; AH = 08H, AL = 01H
                           
                           
;;;;;;;; Before, not After (opposite to all the above)

; AAD (ASCII Adjust AX before Division): Prepares two BCDs in AX for 
; division by converting them into a single binary number.

mov ax, 0504H ; AX = 0504H (unpacked BCD for 50 and 4)
aad           ; AX = 0032H (decimal 50 + 4 = 54)
