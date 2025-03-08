
;the following are pins connected from the TFT to our TFT
;RD = PB9		Read pin	--> to read from touch screen input 
;WR = PB8		Write pin	--> to write data/command to display
;RS = PB7		Command pin	--> to choose command or data to write
;CS = PB6		Chip Select	--> to enable the TFT,(active low)
;RST= PB15		Reset		--> to reset the TFT (active low)
;D0-7 = PA0-7	Data BUS	--> Put your command or data on this bus

 
    AREA RESET, CODE, READONLY
    EXPORT __main
    ENTRY

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

__main
    ; Enable clocks for GPIOA and GPIOB
    LDR R0, =RCC_BASE + RCC_APB2ENR
    LDR R1, [R0]
    ORR R1, R1, #(1 << 2)  ; Enable GPIOA
    ORR R1, R1, #(1 << 3)  ; Enable GPIOB
    STR R1, [R0]

    ; Configure PA0 - PA7 as Output (Data Bus) at 50MHz push-pull
    LDR R0, =GPIOA_BASE + GPIO_CRL
    LDR R1, =0x33333333
    STR R1, [R0]

    ; Configure PB0 - PB7 as Output (Control Signals)
    LDR R0, =GPIOB_BASE + GPIO_CRL
    LDR R1, =0x33333333
    STR R1, [R0]

    ; Configure PB8 - PB15 as Output
    LDR R0, =GPIOB_BASE + GPIO_CRH
    LDR R1, =0x33333333
    STR R1, [R0]

    ; Initialize TFT
    BL TFT_Init

    ; Fill screen with color 0x0FF0 (light green)
    LDR R0, =0x0FF0
    BL TFT_FillScreen

    B .

; *************************************************************
; TFT Write Command (R0 = command)
; *************************************************************
TFT_WriteCommand
    STMFD SP!, {LR}

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

    ; Generate WR pulse (low ? high)
    LDR R1, =GPIOB_BASE + GPIO_ODR
    LDR R2, [R1]
    BIC R2, R2, #TFT_WR
    STR R2, [R1]
    ORR R2, R2, #TFT_WR
    STR R2, [R1]

    ; Set CS high
    ORR R2, R2, #TFT_CS
    STR R2, [R1]

    LDMFD SP!, {LR}
    BX LR

; *************************************************************
; TFT Write Data (R0 = data)
; *************************************************************
TFT_WriteData
    STMFD SP!, {LR}

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

    LDMFD SP!, {LR}
    BX LR

; *************************************************************
; TFT Initialization
; *************************************************************
TFT_Init
    STMFD SP!, {LR}

    ; Reset TFT (PB15 low ? high)
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

    LDMFD SP!, {LR}
    BX LR

; *************************************************************
; TFT Fill Screen (R0 = 16-bit color)
; *************************************************************
TFT_FillScreen
    STMFD SP!, {R1-R3, LR}

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, #0x00
    BL TFT_WriteData
    BL TFT_WriteData
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0xEF
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, #0x00
    BL TFT_WriteData
    BL TFT_WriteData
    MOV R0, #0x01
    BL TFT_WriteData
    MOV R0, #0x3F
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Fill screen with color
    MOV R3, #76800  ; 320x240 pixels / 2 (since 16-bit color)
TFT_Loop
    LSR R1, R0, #8  ; High byte
    BL TFT_WriteData
    AND R1, R0, #0xFF  ; Low byte
    BL TFT_WriteData

    SUBS R3, R3, #1
    BNE TFT_Loop

    LDMFD SP!, {R1-R3, LR}
    BX LR

; *************************************************************
; Delay Function
; *************************************************************
delay
    STMFD SP!, {R0, LR}
    MOV R0, #50000
delay_loop
    SUBS R0, R0, #1
    BNE delay_loop
    LDMFD SP!, {R0, LR}
    BX LR

