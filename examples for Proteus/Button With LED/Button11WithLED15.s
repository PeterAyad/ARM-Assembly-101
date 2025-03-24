; This code is written for STM32F103C6
; Button on PB11
; LED on PB15

    EXPORT __main

    AREA MYDATA, DATA, READWRITE  

DELAY_INTERVAL   EQU  0x186004

; Define register base addresses
RCC_BASE        EQU     0x40021000
GPIOB_BASE      EQU     0x40010C00

; Define register offsets
RCC_APB2ENR     EQU     0x18
GPIO_CRL        EQU     0x00
GPIO_CRH        EQU     0x04
GPIO_IDR        EQU     0x08
GPIO_ODR        EQU     0x0C

    AREA MYCODE, CODE, READONLY 
        
__main FUNCTION

    ; Enable GPIOB clock
    LDR     R1, =RCC_BASE + RCC_APB2ENR   
    LDR     R0, [R1]           
    ORR     R0, R0, #(1 << 3)  ; Enable GPIOB clock
    STR     R0, [R1]                  

    ; Configure PB15 as output
    ; Configure PB11 as input with pull-down
    LDR     R1, =GPIOB_BASE + GPIO_CRH   
    LDR     R0, [R1]                 
    BIC     R0, R0, #(0xF << 12)  ; Clear bits for PB11
    ORR     R0, R0, #(0x8 << 12)  ; Set PB11 as Input with Pull-Down (CNF = 10, MODE = 00)
    BIC     R0, R0, #(0xF << 28)  ; Clear bits for PB15
    ORR     R0, R0, #(0x3 << 28)  ; Set PB15 as Output (CNF = 00, MODE = 11)
    STR     R0, [R1]  

    ; Enable pull-down resistor on PB11
    LDR     R1, =GPIOB_BASE + GPIO_ODR    
    LDR     R0, [R1]
    BIC     R0, R0, #(1 << 11)  ; Ensure PB11 is pulled down
    STR     R0, [R1]
	
; Main loop
readInput
    LDR     R1, =GPIOB_BASE + GPIO_IDR   
    LDR     R0, [R1]
    TST     R0, #(1 << 11)  ; Check if button is pressed
    BNE     turnOn  ; Branch if not zero

turnOff
    LDR     R1, =GPIOB_BASE + GPIO_ODR       
    LDR     R0, [R1]
    BIC     R0, R0, #(1 << 15)  ; Clear PB15 (turn LED off)
    STR     R0, [R1]
    B       readInput

turnOn
    LDR     R1, =GPIOB_BASE + GPIO_ODR       
    LDR     R0, [R1]
    ORR     R0, R0, #(1 << 15)  ; Set PB15 HIGH (turn LED on)
    STR     R0, [R1]
    B       readInput
    
    ENDFUNC
    END
