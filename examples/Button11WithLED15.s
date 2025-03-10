; This code is written for STM32F407VG
; Button on PD11
; LED on PD15

    EXPORT __main

    AREA MYDATA, DATA, READWRITE  
DELAY_INTERVAL   EQU  0x186004

RCC_AHB1ENR      EQU  0x40023830
GPIOD_MODER      EQU  0x40020C00
GPIOD_OTYPER     EQU  0x40020C04
GPIOD_OSPEEDR    EQU  0x40020C08
GPIOD_PUPDR      EQU  0x40020C0C
GPIOD_ODR        EQU  0x40020C14
GPIOD_IDR        EQU  0x40020C10

    AREA MYCODE, CODE, READONLY 
        
__main FUNCTION

    ; Enable GPIO clock
    LDR     R1, =RCC_AHB1ENR    
    LDR     R0, [R1]            
    ORR     R0, R0, #0x08
    STR     R0, [R1]            

    ; Configure pin 15 as output mode
    LDR     R1, =GPIOD_MODER    
    LDR     R0, [R1]                 
    BFC     R0, #30, #2
    BFI     R0, R0, #30, #1
    STR     R0, [R1]            

    ; Configure pin 11 as input mode
    LDR     R1, =GPIOD_MODER    
    LDR     R0, [R1]            
    BFC     R0, #22, #2          
    STR     R0, [R1]            

    ; Enable pulldown resistor on pin 11(Button)
    LDR     R1, =GPIOD_PUPDR    
    LDR     R0, [R1]
    BFC     R0, #22, #2   
    STR     R0, [R1]

; Loop

    ;Read Button from Input Port
readInput
    LDR     R1, =GPIOD_IDR     
    LDR     R0, [R1]
    LSR     R0, R0, #11
    AND     R0, R0, #1
    CMP     R0, #1             
    BNE     turnOff

    ;Turn On LED using output port
turnOn
    LDR     R1, =GPIOD_ODR      
    LDR     R0, [R1]
    BFI     R0, R0, #15, #1 
    STR     R0, [R1]
    B       readInput

    ;Turn Off LED using output port
turnOff
    LDR     R1, =GPIOD_ODR      
    LDR     R0, [R1]
    BFC     R0, #15, #1  
    STR     R0, [R1]
    B       readInput
    
    ENDFUNC
    END
