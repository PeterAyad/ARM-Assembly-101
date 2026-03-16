;AL=AH-BL	using only the following commands (MOV-ADD-DEC-JNZ)
start:
            MOV AX, 0x2354
            MOV BX, 0x6512
DEC_Loop:   DEC AH
            DEC BL
            JNZ DEC_Loop
            MOV AL, AH
    