/*
-------------------------------------------------------
sub_task.s
Complete the given subroutines.
-------------------------------------------------------
Author: Keven Iskander
ID:     160634540
Email:  iska4540@mylaurier.ca
Date:    2019-03-01
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11     @ Terminate program code
.equ SWI_Open, 0x66     @ Open a file
                        @ inputs - R0: address of file name, R1: mode (0: input, 1: write, 2: append)
                        @ outputs - R0: file handle, -1 if open fails
.equ SWI_Close, 0x68    @ Close a file
                        @ inputs - R0: file handle
.equ SWI_RdInt, 0x6c    @ Read integer from a file
                        @ inputs - R0: file handle
                        @ outputs - R0: integer
.equ SWI_PrInt, 0x6b    @ Write integer to a file
                        @ inputs - R0: file handle, R1: integer
.equ SWI_RdStr, 0x6a    @ Read string from a file
                        @ inputs - R0: file handle, R1: buffer address, R2: buffer size
                        @ outputs - R0: number of bytes stored
.equ SWI_PrStr, 0x69    @ Write string to a file
                        @ inputs- R0: file handle, R1: address of string
.equ SWI_PrChr, 0x00    @ Write a character to Stdout
                        @ inputs - R0: character
.equ SWI_Timer, 0x6d    @ Read current time
                        @ output - R0: current time

.equ InputMode, 0       @ Set file mode to input
.equ OutputMode, 1      @ Set file mode to output
.equ AppendMode, 2      @ Set file mode to append
.equ Stdout, 1          @ Set output target to be Stdout
.equ Stdin, 0           @ Set input source to be STDIN

.text
    LDR    R2, =Data1   @ Store address of start of list
    LDR    R3, =_Data1  @ Store address of end of list
    BL     PrintList
    BL     PrintLF
    
    BL     SumList
    MOV    R4, R0       @ Store sum

    @ Print sum
    MOV    R0, #Stdout
    LDR    R1, =SumMsg
    SWI    SWI_PrStr
    MOV    R1, R4
    SWI    SWI_PrInt
    BL     PrintLF    
    
    @ Add two lists into a third
    LDR    R4, =Data2
    LDR    R5, =_Data2
    LDR    R6, =Data3
    BL     AddLists
    
    @ Print contents of third list
    LDR    R2, =Data3
    LDR    R3, =_Data3
    BL     PrintList

    SWI    SWI_Exit

PrintLF:
    /*
    -------------------------------------------------------
    Prints the end-of-line character (\n)
    -------------------------------------------------------
    Uses:
    R0    - set output to Stdout
    R1    - address of string to print
    -------------------------------------------------------
    */
    STMFD  SP!, {R0-R1, LR}
    MOV    R0, #Stdout   @ Set output to Stdout
    LDR    R1, =LF       @ Load line feed character
    SWI    SWI_PrStr
    LDMFD  SP!, {R0-R1, PC}
    
PrintList:    
    /*
    -------------------------------------------------------
    Prints all integers in a list to Stdout - prints each number
    on a new line.
    -------------------------------------------------------
    Uses:
    -------------------------------------------------------
    */
    STMFD    SP!, {R0-R3,LR}
	MOV    R0, #Stdout
	Top:
		LDR R1,[R2],#4
		SWI SWI_PrInt
		BL PrintLF
		CMP R2,R3
		BNE Top
		
    LDMFD   SP!, {R0-R3, PC}
        
SumList:    
    /*
    -------------------------------------------------------
    Sums all integers in a list.
    -------------------------------------------------------
    Uses:
    R0 - returned sum
    -------------------------------------------------------
    */
    STMFD    SP!,{R1,R2,R3,LR}
	MOV R0,#0
	SumLoop:
		LDR R1,[R2],#4
		ADD R0,R0,R1
		CMP R2,R3
		BNE SumLoop
	
    
    LDMFD    SP!,{R1-R3, PC}

AddLists:    
    /*
    -------------------------------------------------------
    Sums integers 1 by 1 in two lists and stores results in third list.
    -------------------------------------------------------
    Uses:
    -------------------------------------------------------
    */
    STMFD    SP!,{R0,R2-R5,R6,LR}
	addLoop:
		LDR R0,[R2],#4
		LDR R1,[R4],#4
		ADD R7,R0,R1
		STR R7,[R6],#4
		CMP R2,R3
		BNE addLoop
    
    LDMFD    SP!, {R0,R2-R5,R6,PC}

.data
    LF:       .asciz  "\n"
    SumMsg:   .asciz    "Sum: "
              .align
    Data1:    .word    4,5,-9,0,3,0,8,-7,0       @ A list of data
    _Data1:    @ End of list address
    Data2:    .word    12,9,-9,5,3,10,8,-7,11    @ A list of data
    _Data2:    @ End of list address
    Data3:    .space   (_Data1 - Data1)          @ Size based upon first list (bytes)
    _Data3:
.end