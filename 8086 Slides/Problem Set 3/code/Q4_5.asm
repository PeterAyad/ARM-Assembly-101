jmp code
                                       
; Each day name is 10 characters long
day_names db 'Sunday    ', 'Monday    ', 'Tuesday   ', 'Wednesday ', 'Thursday  ', 'Friday    ', 'Saturday  '

; Macro to display a number
DisplayNumber Macro      
    local convertLoop, printLoop, donePrint
                  PUSH  BX
                  PUSH  CX
                  PUSH  DX
                
                  Push 0xFFFFFFFF   
                  MOV   BX, 10           ; Divisor for decimal conversion

    convertLoop:  
                  MOV   DX, 0            ; Clear DX before division
                  DIV   BX               ; AX = AX / 10, remainder in DX
                  ADD   DL, '0'          ; Convert remainder to ASCII
                  PUSH  DX               ; Store character on the stack
                  TEST  AX, AX           ; Check if AX is 0
                  JNZ   convertLoop

    printLoop:    
                  pop dx
                  cmp  dx,0xFFFFFFFF
                  Je   donePrint         ; If CX is zero, exit loop
                  MOV   AH, 02H          ; DOS print character function
                  INT   21H
                  jmp  printLoop

    donePrint:    
                  POP   DX
                  POP   CX
                  POP   BX
ENDM

code:
    ; Get the system date (to retrieve the day of the week)
                  mov   ah, 2Ah
                  int   21h              ; Returns the day of the week in AL (0 = Sunday, ..., 6 = Saturday)
                                                 
    ; Save the day index
                  mov   bl, al           ; Copy AL (day index) to BL
               
    ; Position the cursor at the upper-right corner
                  mov   ah, 02h
                  mov   bh, 0            ; Page number 0
                  mov   dh, 0            ; Row 0
                  mov   dl, 62           ; Column 62 (near the right edge)
                  int   10h
                        
    ; Display the day of the week
                  lea   si, day_names    ; Point to the day names table
                  mov   cl, bl           ; Get the day index
                  mov   ax, cx
                  mov   cl, 10           ; Multiply the index by 10 (size of each day string)
                  mul   cl
                  add   si, ax           ; Move SI to the correct day string
  
    print_string: 
                  lodsb                  ; Load the next character from SI into AL
                  cmp   al, ' '          ; Check if space (end of the fixed-length name)
                  je    done_print       ; If space, return
                  mov   dl, al
                  mov   ah, 02h
                  int   21h              ; Print the character
                  jmp   print_string

    done_print:   
    ; Print a space separator
                  mov   dl, ' '
                  mov   ah, 02h
                  int   21h
    
    ; Get the system time
                  mov   ah, 2Ch
                  int   21h              ; Returns hours in CH, minutes in CL, seconds in DH
                    
                  xor   ax, ax
                  mov   al, ch
    ; Print the hour
                  DisplayNumber
                  
    ; Print a colon separator
                  mov   dl, ':'
                  mov   ah, 02h
                  int   21h
    
                  xor   ax, ax
                  mov   al, cl
    ; Print the minutes
                  DisplayNumber
    
    ; Print a colon separator
                  mov   dl, ':'
                  mov   ah, 02h
                  int   21h
              
                  xor   ax, ax
                  mov   al, dh
    ; Print the seconds
                  mov   dl, dh
                  mov   dh, 0
                  mov   ax, dx           ; Second value in AX
                  DisplayNumber
    
    ; Terminate the program
                  mov   ah, 4Ch
                  int   21h
                hlt
