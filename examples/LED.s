; This code is written for STM32F104VG
; LEDs on PD11-PD15

    EXPORT __main

    AREA MYDATA, DATA, READWRITE  

DELAY_INTERVAL   EQU  0x186004
RCC_AHB1ENR      EQU  0x40023830

GPIOD_MODER      EQU  0x40020C00  
GPIOD_OTYPER     EQU  0x40020C04  
GPIOD_OSPEEDR    EQU  0x40020C08  
GPIOD_PUPDR      EQU  0x40020C0C  
GPIOD_ODR        EQU  0x40020C14  

    AREA MYCODE, CODE, READONLY
        
__main FUNCTION

    ; Enable GPIO-D clock
    LDR     R1, =RCC_AHB1ENR   
    LDR     R0, [R1]           
    ORR.W   R0, #0x08          
    STR     R0, [R1]           

    ; Configure pins 12-15 as output mode
    LDR     R1, =GPIOD_MODER   
    LDR     R0, [R1]          
    ORR.W   R0, #0x55000000   
    AND.W   R0, #0x55FFFFFF   
    STR     R0, [R1]           

    ; Configure pins as push-pull (default setting)
    LDR     R1, =GPIOD_OTYPER  
    LDR     R0, [R1]
    AND.W   R0, #0xFFFF0FFF    
    STR     R0, [R1]

    ; Set pin speed to low
    LDR     R1, =GPIOD_OSPEEDR 
    LDR     R0, [R1]
    AND.W   R0, #0x00FFFFFF    
    STR     R0, [R1]    

    ; Disable pull-up/pull-down resistors
    LDR     R1, =GPIOD_PUPDR   
    LDR     R0, [R1]
    AND.W   R0, #0x00FFFFFF    
    STR     R0, [R1]

    ; Turn off using Output port
turnON
    LDR     R1, =GPIOD_ODR     
    LDR     R0, [R1]
    ORR.W   R0, #0xF000        
    STR     R0, [R1]

    LDR     R2, =DELAY_INTERVAL 

    ; Delay
delay1
    CBZ     R2, turnOFF         
    SUBS    R2, R2, #1          
    B       delay1              

    ; Turn off using Output port
turnOFF
    LDR     R1, =GPIOD_ODR      
    LDR     R0, [R1]
    AND.W   R0, #0xFFFF0FFF     
    STR     R0, [R1]    

    LDR     R2, =DELAY_INTERVAL 

    ; Delay
delay2
    CBZ     R2, delayDone       
    SUBS    R2, R2, #1          
    B       delay2   

delayDone
    B       turnON              

    ENDFUNC
    
    END
