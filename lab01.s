/*
-------------------------------------------------------
lab01.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Keven Iskander
ID:      160634540
Email:   iska4540@mylaurier.ca
Date:    2019-01-18
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11 @ Assign a label to the terminate program code

    MOV R0, #9      @ Store decimal 9 in register R0
    MOV R1, #14     @ Store hex E (decimal 14) in register R1
	MOV R3, #8      @ Store decimal 9 in register R3
	MOV R5, #4      @ Store decimal 4 in register R5
	ADD R3, R3, R3  @ Add the contents of R3 and R3 and put the result in R3
    ADD R2, R1, R0  @ Add the contents of R0 and R1 and put result in R2
	ADD R4, R5, #5  
    SWI SWI_Exit    @ Terminate the program