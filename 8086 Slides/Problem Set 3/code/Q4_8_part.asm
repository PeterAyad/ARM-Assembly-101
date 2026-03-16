org 100h  

; Macro to draw a filled rectangle on the screen
RECTANGLE_DRAW MACRO COLOR, X_START, X_END, Y_START, Y_END
    LOCAL DRAW_PIXEL, DRAW_ROW

    MOV   AL, COLOR    ; Set the rectangle color
    MOV   CX, X_START  ; X1 coordinate (left boundary)
    MOV   DI, X_START  ; Store copy of X1
    MOV   BX, X_END    ; X2 coordinate (right boundary)
    MOV   DX, Y_START  ; Y1 coordinate (top boundary)
    MOV   BP, Y_END    ; Y2 coordinate (bottom boundary)

    ; WARNING: If X_START == X_END or Y_START == Y_END, this may cause an infinite loop.
    ; The macro draws a filled rectangle by iterating through pixels row by row.

DRAW_ROW:
DRAW_PIXEL:    
    MOV   AH, 0CH      ; Set pixel function
    INT   10H          ; Draw the pixel
    INC   CX           ; Move right by one pixel
    CMP   CX, BX       ; Check if reached the right boundary
    JNE   DRAW_PIXEL   ; If not, continue drawing the row
    
    MOV   CX, DI       ; Reset X to the start of the row
    INC   DX           ; Move down by one row
    CMP   DX, BP       ; Check if reached the bottom boundary
    JNE   DRAW_ROW     ; If not, continue drawing
ENDM

code:
    ; Set video mode to 320x200 with 256 colors
    mov ah, 0x00
    mov al, 0x13
    int 0x10

    ; Draw a rectangle at (100,60) to (180,100) with color 0x04 (red)
    RECTANGLE_DRAW  0x04, 100, 180, 60, 100

    ; Wait for a key press before exiting
    mov ah, 0x00
    int 0x16  ; BIOS keyboard interrupt
