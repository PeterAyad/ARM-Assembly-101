DisplayString MACRO STR
                  MOV DX, OFFSET STR
                  MOV AH, 09H
                  INT 21H
ENDM

ReadString MACRO buffer
               MOV AH, 0AH
               MOV DX, OFFSET buffer
               INT 21H
               xor bx, bx
               mov bl, buffer[1]
               mov buffer[bx+2], '$'
ENDM

; Convert an 8-bit binary string to a number in AL
ConvertBinaryToDecimal MACRO   buffer
    local convertLoop               
               MOV SI, OFFSET buffer+2  ; Skip metadata bytes
               XOR AL, AL               ; Clear AL (result)
               MOV CX, 8                 ; Expecting 8-bit binary input

convertLoop:
               MOV DL, [SI]               ; Get next character
               CMP DL, '0'                ; Check if it's '0' or '1'
               Jl  doneConvert            ; If not, stop conversion
               CMP DL, '1'
               Jg  doneConvert

               SHL AL, 1                  ; Multiply AL by 2 (shift left)
               SUB DL, '0'                ; Convert ASCII to number (0 or 1)
               OR  AL, DL                 ; Store bit into AL

               INC SI
               LOOP convertLoop
                    
doneConvert:
ENDM

; Convert AL (8-bit number) to Hex and print it
ConvertAndDisplayHex MACRO input0  
                mov al,input0
               push ax
               
               AND AL, 0F0h                 ; Get upper nibble
               shr al,4
               ConvertAndDisplayDigit al    ; Print upper nibble
                      
               pop ax     
               AND Al, 0Fh                  ; Get lower nibble
               ConvertAndDisplayDigit al    ; Print lower nibble
               hlt
ENDM

; Convert AL (0-15) to hex and display it
ConvertAndDisplayDigit MACRO     input
    local      printChar 
       
                mov al,input
               ADD AL, '0'               ; Convert to ASCII
               CMP AL, '9'
               JBE printChar             ; If 0-9, print directly

               ADD AL, 7                 ; Convert 10-15 (A-F)

printChar:
               MOV DL, AL
               MOV AH, 02H
               
               INT 21H
ENDM

jmp code    

    buffer1 DB 9,?,9 dup(0)  ; Buffer for binary input
    promptBin DB 'Enter an 8-bit binary number: $'
    resultMsg DB 0Dh, 0Ah, 'Hexadecimal: $'
    newline DB 0DH, 0AH, '$' 

code:
    DisplayString promptBin
    ReadString buffer1

    ConvertBinaryToDecimal buffer1 
    push ax

    DisplayString newline
    DisplayString resultMsg
    pop ax
    ConvertAndDisplayHex al   ; Print hexadecimal value
    DisplayString newline

    HLT
