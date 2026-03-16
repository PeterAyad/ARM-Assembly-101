; 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 = 55 = 37h
start:
	        MOV AL, 10 ; N
	        MOV AH, 0
SUM_Loop:	ADD AH, AL
	        DEC AL
	        JNZ SUM_Loop
	        MOV BL, AH
	        MOV BH, 0
		  