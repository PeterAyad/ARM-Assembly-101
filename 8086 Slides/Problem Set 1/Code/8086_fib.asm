; 0, 1,  1,  2,  3,  5,  8,  13, 21,  34,  55
; 0, 1h, 1h, 2h, 3h, 5h, 8h, Dh, 15h, 22h, 37h
start:
			MOV CX, 8
			MOV AX, 0
			MOV BX, 1
FIB_Loop:	MOV DX, AX
			ADD DX, BX
			MOV AX, BX
			MOV BX, DX
			DEC CX
			JNZ FIB_Loop

			MOV AX, BX
