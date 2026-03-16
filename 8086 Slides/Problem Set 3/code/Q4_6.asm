org 100h   ; COM file format

; Macro to print a string
macro printString input
    mov ah, 0x9      ; Print string function
    lea dx, input    ; DS:DX -> String
    int 21h          ; DOS interrupt
endm

; Macro to wait for a key press
macro waitKey 
    mov ah, 00h
    int 16h          ; Wait for key press
endm    

; Macro to change the active display page
macro changePage input
    mov  al, input   ; Select display page
    mov  ah, 05h     ; Function 05h: select active display page
    int  10h 
endm

jmp code

; Screen messages
screen1 db 'This is the main screen. Press any key to save this screen and display a new one.', '$'
screen2 db 'This is another screen. Press any key to go back to the main screen.', '$'

code:
    ; Display the main screen on page 0
    changePage 0
    printString screen1
    waitKey

    ; Switch to page 1 and display the second screen
    changePage 1                   
    printString screen2
    waitKey  

    ; Switch back to the main screen
    changePage 0
    waitKey   
