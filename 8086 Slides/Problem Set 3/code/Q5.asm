jmp code

; Macro to display a string using DOS INT 21h (AH=09h)
DisplayString MACRO STR       
                   pusha
                   MOV DX, OFFSET STR
                   MOV AH, 09H
                   INT 21H 
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

originalMode DB ?         ; Stores original video mode
clickCount   DW 0         ; Stores number of left button clicks
promptStr    DB 'Click the left mouse button. Press any key to stop.$'
resultStr    DB 'Total Clicks: $'
newline      DB 0DH, 0AH, '$'  ; Newline

code:

    ; Save the current video mode
    MOV AH, 0Fh
    INT 10H
    MOV originalMode, AL

    ; Set graphics mode (320x200, 256 colors)
    MOV AH, 0
    MOV AL, 13H
    INT 10H

    ; Display prompt in graphics mode
    MOV AH, 09H
    LEA DX, promptStr
    INT 21H

mouseLoop:
    ; Check mouse status
    MOV AX, 0003H      ; Get mouse button status
    INT 33H
    TEST BX, 1         ; Check if left button is pressed
    JZ checkKeyPress   ; If not, check for key press

    INC clickCount     ; Increment count if button was pressed

    ; Wait until button is released
waitRelease:
    MOV AX, 0003H
    INT 33H
    TEST BX, 1         ; Check if button is still pressed
    JNZ waitRelease    ; Wait for release

checkKeyPress:
    ; Check if a key is pressed
    MOV AH, 01H
    INT 16H
    JZ mouseLoop       ; If no key, continue loop

restoreMode:
    ; Restore original video mode
    MOV AH, 00H
    MOV AL, originalMode
    INT 10H

    ; Display result in text mode
    DisplayString newline
    DisplayString resultStr

    ; Load click count into AX before displaying
    MOV AX, clickCount
    DisplayNumber
    DisplayString newline

    HLT


