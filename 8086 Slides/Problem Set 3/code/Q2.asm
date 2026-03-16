DisplayString MACRO STR
                  MOV DX, OFFSET STR
                  MOV AH, 09H
                  INT 21H
ENDM

; Input a string to DS:DX
; The first byte in the buffer should contain the buffer size.
; The second byte is set to the number of characters actually read.
; This function does not add '$' at the end of the string.
; To print using INT 21h / AH=9, you must set the dollar character at the end of it 
; and start printing from address DS:DX + 2. 
ReadString MACRO buffer
               MOV AH, 0AH
               MOV DX, OFFSET buffer
               INT 21H
               XOR BX, BX
               MOV BL, buffer[1]
               MOV buffer[bx+2], '$'
ENDM

; Assuming the number is in AX
; Convert the number to ASCII digit by digit
DisplayNumber MACRO
                  PUSH BX
                  PUSH CX
                  PUSH DX

                  MOV  CX, 0          ; Digit count
                  MOV  BX, 10         ; Divisor for decimal conversion

    convertLoop:  
                  MOV  DX, 0          ; Clear DX before division
                  DIV  BX             ; AX = AX / 10, remainder in DX
                  ADD  DL, '0'        ; Convert remainder to ASCII
                  PUSH DX             ; Store character on stack
                  INC  CX             ; Increase count
                  TEST AX, AX         ; Check if AX is 0
                  JNZ  convertLoop

    printLoop:    
                  JCXZ donePrint      ; If CX is zero, exit loop
                  POP  DX
                  MOV  AH, 02H        ; DOS print char function
                  INT  21H
                  LOOP printLoop

    donePrint:    
                  POP  DX
                  POP  CX
                  POP  BX
ENDM

; Opposite of DisplayNumber
ReadNum MACRO buffer
                  ReadString buffer                   ; Read string input
                  MOV        SI, OFFSET buffer + 2    ; Skip max and length bytes
                  MOV        AX, 0                    ; Clear AX
                  MOV        CX, 0                    ; CX will store the number
                  MOV        BX, 10                   ; BX = 10 for multiplication

    convertNumber:
                  MOV        AX, 0
                  MOV        AL, [SI]                 ; Get character from buffer
                  CMP        AL, '$'                  ; Check for Enter (carriage return)
                  JE         doneConvert
                  SUB        AL, '0'                  ; Convert ASCII to number
                  MOV        DX, 0                    ; Clear DX before multiplication
                  XCHG       AX, CX                   ; Move previous sum to AX
                  MUL        BX                       ; Multiply by 10
                  ADD        AX, CX                   ; Add the new digit
                  MOV        CX, AX                   ; Store result in CX
                  INC        SI                       ; Move to next character
                  JMP        convertNumber

    doneConvert:  
                  MOV        AX, CX                   ; Store result in AX
ENDM

jmp code    
    
    buffer1 DB 13,?,13 DUP(0)
    buffer2 DB 13,?,13 DUP(0)
    promptStr DB 'Enter a string: $'
    promptNum DB 'Enter a number: $'
    outputStr DB 'You entered: $'
    newline DB 0DH, 0AH, '$'  ; Newline characters

code:
           
    DisplayString promptStr
    ReadString buffer1
    DisplayString newline
    DisplayString outputStr
    DisplayString buffer1+2     
    DisplayString newline
                           
    DisplayString promptNum
    ReadNum buffer2       
    PUSH AX      
    DisplayString newline
    DisplayString outputStr
    POP AX
    DisplayNumber         
    DisplayString newline

    HLT
