; This code is written for STM32F104VG
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

    ; Enable GPIO-D clock
    LDR     R1, =RCC_AHB1ENR    
    LDR     R0, [R1]            
    ORR     R0, R0, #0x08        ; Enable GPIOD clock
    STR     R0, [R1]            

    ; Configure pin 15 as output mode (bits 30-31 = 01)
    LDR     R1, =GPIOD_MODER    
    LDR     R0, [R1]                 
    BFC     R0, #30, #2          ; Clear bits 30-31
    BFI     R0, R0, #30, #1      ; Insert '01' at bit 30
    STR     R0, [R1]            

    ; Configure pin 11 as input mode (bits 22-23 = 00)
    LDR     R1, =GPIOD_MODER    
    LDR     R0, [R1]            
    BFC     R0, #22, #2          ; Clear bits 22-23 (set to 00)
    STR     R0, [R1]            

    ; Disable pull-up/pull-down resistors for pin 11 (bits 22-23 = 00)
    LDR     R1, =GPIOD_PUPDR    
    LDR     R0, [R1]
    BFC     R0, #22, #2          ; Clear bits 22-23 (set to 00)
    STR     R0, [R1]

readInput
    LDR     R1, =GPIOD_IDR     
    LDR     R0, [R1]
    LSR     R0, R0, #11         ; Move bit 11 to bit 0
    AND     R0, R0, #1          ; Mask bit 0
    CMP     R0, #1             
    BNE     turnOff

turnOn
    LDR     R1, =GPIOD_ODR      
    LDR     R0, [R1]
    BFI     R0, R0, #15, #1     ; Set bit 15 (turn on LED)
    STR     R0, [R1]
    B       readInput

turnOff
    LDR     R1, =GPIOD_ODR      
    LDR     R0, [R1]
    BFC     R0, #15, #1         ; Clear bit 15 (turn off LED)
    STR     R0, [R1]
    B       readInput
    
    ENDFUNC
    END
