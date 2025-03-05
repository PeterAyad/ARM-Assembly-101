    EXPORT __main

    AREA MYDATA, DATA, READWRITE  ; Read-Write data section (written to RAM)

; Delay size
DELAY_INTERVAL   EQU  0x186004

; Bus clock enable register
RCC_AHB1ENR      EQU  0x40023830

; GPIO-D control registers
GPIOD_MODER      EQU  0x40020C00  ; Configures GPIO pin mode as Input, Output, or Analog
GPIOD_OTYPER     EQU  0x40020C04  ; Configures GPIO pin output type (Push-Pull or Open-Drain)
GPIOD_OSPEEDR    EQU  0x40020C08  ; Configures GPIO pin speed
GPIOD_PUPDR      EQU  0x40020C0C  ; Configures GPIO pin pull-up/pull-down resistors
GPIOD_ODR        EQU  0x40020C14  ; GPIO output data register


    AREA MYCODE, CODE, READONLY ; Read-only data section (written to flash or ROM)
        
__main FUNCTION

    ; Enable GPIO-D clock
    LDR     R1, =RCC_AHB1ENR    ; Load address of RCC_AHB1ENR into R1
    LDR     R0, [R1]            ; Load current register value into R0
    ORR.W   R0, #0x08           ; Set bit 3 (Enable clock for GPIOD)
    STR     R0, [R1]            ; Store updated value back to RCC_AHB1ENR

    ; Configure pins 12-15 as output mode
    LDR     R1, =GPIOD_MODER    ; Load address of MODER register
    LDR     R0, [R1]            
    ORR.W   R0, #0x55000000     ; Set bits [24-31] to '01' for output mode
    AND.W   R0, #0x55FFFFFF     ; Ensure only relevant bits are modified
    STR     R0, [R1]            ; Store updated value back to MODER register

    ; Configure pins as push-pull (default setting)
    LDR     R1, =GPIOD_OTYPER   ; Load address of OTYPER register
    LDR     R0, [R1]
    AND.W   R0, #0xFFFF0FFF     ; Clear bits [12-15] (set to push-pull mode)
    STR     R0, [R1]

    ; Set pin speed to low
    LDR     R1, =GPIOD_OSPEEDR  ; Load address of OSPEEDR register
    LDR     R0, [R1]
    AND.W   R0, #0x00FFFFFF     ; Clear bits [24-31] (set speed to low)
    STR     R0, [R1]    

    ; Disable pull-up/pull-down resistors
    LDR     R1, =GPIOD_PUPDR    ; Load address of PUPDR register
    LDR     R0, [R1]
    AND.W   R0, #0x00FFFFFF     ; Clear bits [24-31] (disable pull-up/pull-down)
    STR     R0, [R1]

turnON
    ; Set GPIO pins 12-15 high
    LDR     R1, =GPIOD_ODR      ; Load address of ODR register
    LDR     R0, [R1]
    ORR.W   R0, #0xF000         ; Set bits [12-15] to '1' (turn on LEDs)
    STR     R0, [R1]

    LDR     R2, =DELAY_INTERVAL ; Load delay value

delay1
    CBZ     R2, turnOFF         ; If R2 == 0, branch to turnOFF
    SUBS    R2, R2, #1          ; Decrement R2
    B       delay1              ; Repeat until R2 == 0

turnOFF
    ; Set GPIO pins 12-15 low
    LDR     R1, =GPIOD_ODR      ; Load address of ODR register
    LDR     R0, [R1]
    AND.W   R0, #0xFFFF0FFF     ; Clear bits [12-15] (turn off LEDs)
    STR     R0, [R1]    

    LDR     R2, =DELAY_INTERVAL ; Load delay value

delay2
    CBZ     R2, delayDone       ; If R2 == 0, branch to delayDone
    SUBS    R2, R2, #1          ; Decrement R2
    B       delay2              ; Repeat until R2 == 0

delayDone
    B       turnON              ; Loop back to turnON

    ENDFUNC
    
    END
