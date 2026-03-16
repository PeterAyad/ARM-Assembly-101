jmp code

; Macro to display a string using DOS interrupt 21h (AH = 09h)
DisplayString MACRO STR       
                   pusha
                   MOV DX, OFFSET STR
                   MOV AH, 09H
                   INT 21H 
                   popa
ENDM

; Reads a string from user input into a buffer.
; - The first byte of the buffer should contain the buffer size.
; - The second byte is updated with the number of characters actually read.
; - This function does not add a '$' at the end of the string automatically.
; - To print using INT 21h / AH = 09h, a '$' must be manually appended at buffer[buffer[1]+2].
ReadString MACRO buffer   
                pusha
                MOV AH, 0AH
                MOV DX, OFFSET buffer
                INT 21H
                xor bx, bx
                mov bl, buffer[1]        ; Get the length of input
                mov buffer[bx+2], '$'    ; Append '$' at the end for printing
                popa
ENDM

; Displays a number stored in AX as ASCII digits.
DisplayNumber MACRO
                  PUSH BX
                  PUSH CX
                  PUSH DX       
                  MOV CX, AX
                  PUSH CX

                  MOV CX, 0          ; Digit count
                  MOV BX, 10         ; Divisor for decimal conversion

    convertLoop:  
                  MOV DX, 0          ; Clear DX before division
                  DIV BX             ; AX = AX / 10, remainder in DX
                  ADD DL, '0'        ; Convert remainder to ASCII
                  PUSH DX            ; Store character on stack
                  INC CX             ; Increase count
                  TEST AX, AX        ; Check if AX is 0
                  JNZ convertLoop

    printLoop:    
                  JCXZ donePrint     ; If CX is zero, exit loop
                  POP DX
                  MOV AH, 02H        ; DOS print char function
                  INT 21H
                  LOOP printLoop

    donePrint:                
                  POP AX
                  POP DX
                  POP CX
                  POP BX
ENDM

; Reads an integer from user input and converts it from ASCII to a number.
ReadNum MACRO buffer          
                  ReadString buffer                   ; Read user input
                  MOV SI, OFFSET buffer + 2          ; Skip metadata (max size & actual length)
                  MOV AX, 0                          ; Clear AX
                  MOV CX, 0                          ; CX will store the numeric result
                  MOV BX, 10                         ; BX = 10 for multiplication

    convertNumber:
                  MOV AL, [SI]                       ; Get character from buffer
                  CMP AL, '$'                        ; Check for termination character
                  JE  doneConvert
                  SUB AL, '0'                        ; Convert ASCII to numerical value
                  MOV DX, 0                          ; Clear DX before multiplication
                  XCHG AX, CX                        ; Move previous sum to AX
                  MUL BX                             ; Multiply by 10
                  ADD AX, CX                         ; Add the new digit
                  MOV CX, AX                         ; Store result in CX
                  INC SI                             ; Move to next character
                  JMP convertNumber

    doneConvert:  
                  MOV AX, CX                         ; Store result in AX
ENDM

; Data Section
buffer     DB 13, ?, 13 DUP(0)  ; Buffer for user input
promptNum  DB 'Enter a starting number: $'
outputStr  DB 'Count: $'
newline    DB 0DH, 0AH, '$'     ; Newline characters

code:

    ; Prompt user for a number
    DisplayString promptNum
    ReadNum buffer 
    PUSH AX               
    
    DisplayString newline

countLoop:
    DisplayString outputStr   

    POP AX 
    DisplayNumber AX       
    PUSH AX
    DisplayString newline

    ; 1-second delay using BIOS wait function
    MOV AH, 86H                   ; BIOS wait function (INT 15h, AH=86h)
    MOV CX, 0                     ; High word of delay counter
    MOV DX, 0FFFFH                ; Low word of delay counter (1 second)
    INT 15H                       

    ; Check for key press
    MOV AH, 01H                   ; BIOS keyboard check (INT 16h, AH=01h)
    INT 16H
    JNZ stopCounting              ; If a key is pressed, exit loop

    POP AX
    INC AX                        ; Increment counter
    PUSH AX
    JMP countLoop

stopCounting:
    HLT                           ; Halt execution
