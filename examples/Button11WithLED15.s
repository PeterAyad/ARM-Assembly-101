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
    ORR     R0, R0, #0x08      ; Enable GPIOD clock
    STR     R0, [R1]            

    ; Configure pin 15 as output mode
    LDR     R1, =GPIOD_MODER    
    LDR     R0, [R1]                 
    BIC     R0, R0, #0xC0000000  ; Clear bits 30-31 (pin 15 mode)
    ORR     R0, R0, #0x40000000  ; Set pin 15 as output (01)
    STR     R0, [R1]            

    ; Configure pin 11 as input mode
    LDR     R1, =GPIOD_MODER    
    LDR     R0, [R1]            
    BIC     R0, R0, #0x00C00000  ; Clear bits 22-23 (pin 11 mode)
    STR     R0, [R1]            

    ; Disable pull-up/pull-down resistors for pin 11
    LDR     R1, =GPIOD_PUPDR    
    LDR     R0, [R1]
    BIC     R0, R0, #0x00C00000  ; Clear bits 22-23 (no pull-up/pull-down)
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
    ORR     R0, R0, #0x8000     ; Turn on LED (set bit 15)
    STR     R0, [R1]
    B       readInput

turnOff
    LDR     R1, =GPIOD_ODR      
    LDR     R0, [R1]
    BIC     R0, R0, #0x8000     ; Turn off LED (clear bit 15)
    STR     R0, [R1]
    B       readInput
    
    ENDFUNC
    END
