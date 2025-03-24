; This code is written for STM32F407VG
; Button on PD11
; LED on PD15

    EXPORT __main

    AREA MYDATA, DATA, READWRITE  

; Define register base addresses
RCC_BASE        EQU     0x40023800
GPIOA_BASE      EQU     0x40020000
GPIOB_BASE      EQU     0x40020400
GPIOC_BASE      EQU     0x40020800
GPIOD_BASE      EQU     0x40020C00
GPIOE_BASE      EQU     0x40021000

; Define register offsets
RCC_AHB1ENR     EQU     0x30
GPIO_MODER      EQU     0x00
GPIO_OTYPER     EQU     0x04
GPIO_OSPEEDR    EQU     0x08
GPIO_PUPDR      EQU     0x0C
GPIO_IDR        EQU     0x10
GPIO_ODR        EQU     0x14

    AREA MYCODE, CODE, READONLY 
        
__main FUNCTION

    ; Enable GPIO-D clock
    LDR     R1, =RCC_BASE + RCC_AHB1ENR
    LDR     R0, [R1]           
    ORR     R0, R0, #(1 << 3)         
    STR     R0, [R1]                

    ; Configure pin 15 as output mode
    ; Configure pin 11 as input mode
    LDR     R1, =GPIOD_BASE +  GPIO_MODER 
    LDR     R0, [R1]  
    LDR     R0, =0x40000000
    STR     R0, [R1]            

    ; Enable pulldown resistor on pin 11(Button)
    LDR     R1, =GPIOD_BASE +  GPIO_PUPDR   
    LDR     R0, [R1]
    LDR     R0, =0x00800000
    STR     R0, [R1]

; Main loop
readInput
    LDR     R1, =GPIOD_BASE + GPIO_IDR   
    LDR     R0, [R1]
    TST     R0, #(1 << 11)  ; Check if button is pressed
    BNE     turnOn  ; Branch if not zero

turnOff
    LDR     R1, =GPIOD_BASE + GPIO_ODR       
    LDR     R0, [R1]
    BIC     R0, R0, #(1 << 15)  ; Clear PB15 (turn LED off)
    STR     R0, [R1]
    B       readInput

turnOn
    LDR     R1, =GPIOD_BASE + GPIO_ODR       
    LDR     R0, [R1]
    ORR     R0, R0, #(1 << 15)  ; Set PB15 HIGH (turn LED on)
    STR     R0, [R1]
    B       readInput
    
    ENDFUNC
    END
