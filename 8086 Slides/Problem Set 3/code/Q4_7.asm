org 100h  ; COM file format (DOS)

    ; Set video mode to 320x200 with 256 colors
    mov ah, 0x00  ; Set video mode function
    mov al, 0x13  ; 320x200 resolution, 256-color mode
    int 0x10      ; BIOS interrupt

    ; Draw a vertical line in the middle of the screen
    mov cx, 160   ; X coordinate (middle of 320)
    mov dx, 0     ; Start at Y = 0

vline_loop:
    mov ah, 0x0C  ; Set pixel function
    mov al, 0x0F  ; Color (white)
    mov bh, 0x00  ; Page number
    int 0x10      ; BIOS interrupt

    inc dx        ; Move down one pixel
    cmp dx, 200   ; If Y reaches 200, stop
    jl vline_loop

    ; Draw a horizontal line in the middle of the screen
    mov dx, 100   ; Y coordinate (middle of 200)
    mov cx, 0     ; Start at X = 0

hline_loop:
    mov ah, 0x0C  ; Set pixel function
    mov al, 0x0F  ; Color (white)
    mov bh, 0x00  ; Page number
    int 0x10      ; BIOS interrupt

    inc cx        ; Move right one pixel
    cmp cx, 320   ; If X reaches 320, stop
    jl hline_loop

    ; Wait for a key press before exiting
    mov ah, 0x00
    int 0x16      ; BIOS keyboard interrupt
