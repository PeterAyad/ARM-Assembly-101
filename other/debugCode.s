; This code is written for Debugging (run code in Keil without startup script or core) using 
;   keil internal simulator for any board
    
    AREA MYDATA, DATA, READWRITE

    EXPORT __Vectors
    EXPORT Reset_Handler

    AREA RESET, DATA, READONLY

__Vectors
    DCD  0x20001000         ; Stack pointer (adjust based on RAM size)
    DCD  Reset_Handler      ; Reset vector
    DCD  Default_Handler    ; NMI Handler
    DCD  Default_Handler    ; HardFault Handler
    DCD  Default_Handler    ; Memory Management Fault Handler
    DCD  Default_Handler    ; Bus Fault Handler
    DCD  Default_Handler    ; Usage Fault Handler
    DCD  0                  ; Reserved
    DCD  0                  ; Reserved
    DCD  0                  ; Reserved
    DCD  0                  ; Reserved
    DCD  Default_Handler    ; SVCall Handler
    DCD  Default_Handler    ; Debug Monitor Handler
    DCD  0                  ; Reserved
    DCD  Default_Handler    ; PendSV Handler
    DCD  Default_Handler    ; SysTick Handler

    AREA MYCODE, CODE, READONLY
    ENTRY

Reset_Handler

	; Code Here

Default_Handler
    B    Default_Handler    ; Infinite loop in case of an unexpected interrupt

    END