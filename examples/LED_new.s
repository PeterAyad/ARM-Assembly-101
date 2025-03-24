; This code is written for STM32F407VG
; LEDs on PD12-PD15

    EXPORT __main

    AREA MYDATA, DATA, READWRITE  

DELAY_INTERVAL   EQU  0x186004

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

    ; Configure pins 12-15 as output mode
    LDR     R1, =GPIOD_BASE +  GPIO_MODER  
    LDR     R0, [R1]          
    LDR     R0, =(0x55 << 12)  
    STR     R0, [R1]           

    ; Turn off using Output port
turnON
    LDR     R1, =GPIOD_BASE +  GPIO_ODR
    LDR     R0, [R1]
    ORR     R0, R0, #(0xF << 12)
    STR     R0, [R1]

    ; Delay
    LDR     R2, =DELAY_INTERVAL 
delay1
    CBZ     R2, turnOFF         
    SUBS    R2, R2, #1          
    B       delay1              

    ; Turn off using Output port
turnOFF
    LDR     R1, =GPIOD_BASE +  GPIO_ODR     
    LDR     R0, [R1]
    BIC     R0, R0, #(0xF << 12)   
    STR     R0, [R1]    

    ; Delay
    LDR     R2, =DELAY_INTERVAL 
delay2
    CBZ     R2, delayDone       
    SUBS    R2, R2, #1          
    B       delay2   

delayDone
    B       turnON              

    ENDFUNC
    END
