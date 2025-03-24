; This code is written for STM32F103C6


; Pin Connection
; RD    =   PB9		Read pin	    Read from touch screen input 
; WR    =   PB8		Write pin	    Write data/command to display
; RS    =   PB7		Command pin	    Choose command or data to write
; CS    =   PB6		Chip Select	    Enable the TFT,(active low)
; RST   =   PB15	Reset		    Reset the TFT (active low)
; D0-7  =   PA0-7	Data BUS	    Put your command or data on this bus

 
    AREA RESET, CODE, READONLY

    EXPORT __main

;Colors
Red     EQU 0x001F  ; 00000 000000 11111
Green   EQU 0x07E0  ; 00000 111111 00000
Blue    EQU 0xF800  ; 11111 000000 00000
Yellow  EQU 0x06FF	; 11111 111111 00000
White   EQU 0xFFFF  ; 11111 111111 11111
Black   EQU 0x0000  ; 00000 000000 00000

; Define register base addresses
RCC_BASE        EQU     0x40021000
GPIOA_BASE      EQU     0x40010800
GPIOB_BASE      EQU     0x40010C00

; Define register offsets
RCC_APB2ENR     EQU     0x18
GPIO_CRL        EQU     0x00
GPIO_CRH        EQU     0x04
GPIO_ODR        EQU     0x0C

; Control Pins on Port B
TFT_RST         EQU     (1 << 15)    ; Reset (PB15)
TFT_RD          EQU     (1 << 9)     ; Read  (PB9)
TFT_WR          EQU     (1 << 8)     ; Write (PB8)
TFT_DC          EQU     (1 << 7)     ; Data/Command (PB7)
TFT_CS          EQU     (1 << 6)     ; Chip Select (PB6)

__main FUNCTION
    ; Enable clocks for GPIOA and GPIOB
    LDR R0, =RCC_BASE + RCC_APB2ENR
    LDR R1, [R0]
    ORR R1, R1, #(1 << 2)  ; Enable GPIOA
    ORR R1, R1, #(1 << 3)  ; Enable GPIOB
    STR R1, [R0]

    ; Configure PA0 - PA7 as Output at 50MHz speed
    LDR R0, =GPIOA_BASE + GPIO_CRL
    LDR R1, [R0]
    LDR R1, =0x33333333
    STR R1, [R0]

    ; Configure PB6 and PB7 as Output
    LDR R0, =GPIOB_BASE + GPIO_CRL
    LDR R1, [R0]
    LDR R1, =0x33000000
    STR R1, [R0]

    ; Configure PB8, PB9, PB15 as Output
    LDR R0, =GPIOB_BASE + GPIO_CRH
    LDR R1, [R0]
    LDR R1, =0x30000033
    STR R1, [R0]

    ; Initialize TFT
    BL TFT_Init

    ; Fill screen with color 
    MOV R0, #Yellow
    BL TFT_FillScreen


; *************************************************************
; TFT Write Command (R0 = command)
; *************************************************************
TFT_WriteCommand
    PUSH {R1-R12, LR}

    ; Set RS (DC) low for command
    LDR R1, =GPIOB_BASE + GPIO_ODR
    LDR R2, [R1]
    BIC R2, R2, #TFT_DC
    STR R2, [R1]

    ; Set CS low
    BIC R2, R2, #TFT_CS
    STR R2, [R1]

    ; Send command (R0 contains command)
    LDR R1, =GPIOA_BASE + GPIO_ODR
    STR R0, [R1]

    ; Generate WR pulse (low > high)
    LDR R1, =GPIOB_BASE + GPIO_ODR
    LDR R2, [R1]
    BIC R2, R2, #TFT_WR
    STR R2, [R1]
    ORR R2, R2, #TFT_WR
    STR R2, [R1]

    ; Set CS high
    ORR R2, R2, #TFT_CS
    STR R2, [R1]

    POP {R1-R12, LR}
    BX LR

; *************************************************************
; TFT Write Data (R0 = data)
; *************************************************************
TFT_WriteData
    PUSH {R1-R12, LR}

    ; Set RS (DC) high for data
    LDR R1, =GPIOB_BASE + GPIO_ODR
    LDR R2, [R1]
    ORR R2, R2, #TFT_DC
    STR R2, [R1]

    ; Set CS low
    BIC R2, R2, #TFT_CS
    STR R2, [R1]

    ; Send data (R0 contains data)
    LDR R1, =GPIOA_BASE + GPIO_ODR
    STR R0, [R1]

    ; Generate WR pulse
    LDR R1, =GPIOB_BASE + GPIO_ODR
    LDR R2, [R1]
    BIC R2, R2, #TFT_WR
    STR R2, [R1]
    ORR R2, R2, #TFT_WR
    STR R2, [R1]

    ; Set CS high
    ORR R2, R2, #TFT_CS
    STR R2, [R1]

    POP {R1-R12, LR}
    BX LR

; *************************************************************
; TFT Initialization
; *************************************************************
TFT_Init
    PUSH {R0-R12, LR}

    ; Reset TFT (PB15 low > high)
    LDR R1, =GPIOB_BASE + GPIO_ODR
    LDR R2, [R1]
    BIC R2, R2, #TFT_RST
    STR R2, [R1]
    BL delay

    ORR R2, R2, #TFT_RST
    STR R2, [R1]
    BL delay

    ; Software Reset
    MOV R0, #0x01
    BL TFT_WriteCommand
    BL delay

    ; Display OFF
    MOV R0, #0x28
    BL TFT_WriteCommand

    ; Set Pixel Format (16-bit)
    MOV R0, #0x3A
    BL TFT_WriteCommand
    MOV R0, #0x55
    BL TFT_WriteData

    ; Sleep Out
    MOV R0, #0x11
    BL TFT_WriteCommand
    BL delay

    ; Display ON
    MOV R0, #0x29
    BL TFT_WriteCommand

    POP {R0-R12, LR}
    BX LR

; *************************************************************
; TFT Fill Screen (R0 = 16-bit color)
; *************************************************************
TFT_FillScreen
    PUSH {R1-R12, LR}

    ; Extract high and low bytes
    MOV R3, R0
    AND R1, R0, #0xFF ; Get the low byte (lower 8 bits)
    LSR R2, R3, #8   ; Get the high byte (upper 8 bits)

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0xEF  ; Max column (239)
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x01
    BL TFT_WriteData
    MOV R0, #0x3F  ; Max row (319)
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Fill screen with color
    MOV R3, #76800  ; Total pixels (320x240 since 16-bit per pixel)
TFT_Loop
    MOV R0, R2      ; Send high byte
    BL TFT_WriteData
    MOV R0, R1      ; Send low byte
    BL TFT_WriteData

    SUBS R3, R3, #1
    BNE TFT_Loop

    POP {R1-R12, LR}
    BX LR


; *************************************************************
; Delay Function
; *************************************************************
delay
    PUSH {R0-R12, LR}
    MOV R0, #50000
delay_loop
    SUBS R0, R0, #1
    BNE delay_loop
    PUSH {R0-R12, LR}
    BX LR

    ENDFUNC
    END