/*
-------------------------------------------------------
io_demo.s
A simple file input/output demo program.
-------------------------------------------------------
Author:  David Brown
ID:      999999999
Email:   dbrown@wlu.ca
Date:    2019-02-04
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11     @ Assign a label to the terminate program code
.equ SWI_Open, 0x66     @ Open a file - R0: address of file name, R1: mode 
.equ SWI_Close, 0x68    @ Close a file
.equ SWI_RdInt, 0x6c    @ Read integer from a file
.equ SWI_PrInt, 0x6b    @ Write integer to a file
.equ SWI_RdStr, 0x6a    @ Read string from a file
.equ SWI_PrStr, 0x69    @ Print string to a file
.equ InputMode, 0       @ Set file mode to input
.equ OutputMode, 1      @ Set file mode to output
.equ AppendMode, 2      @ Set file mode to append
.equ Stdout, 1          @ Set output target to be STDOUT
.equ Stdin, 0           @ Set input source to be STDIN

@ Open a file for reading
    LDR    R0, =FILE        @ Load address of file name
	LDR    R5, =SUM
    MOV    R1, #InputMode   @ Set file mode to input
    SWI    SWI_Open         @ Open the file - sets Carry on error

@ Check that file opened
    BCS    Error            @ Branch Carry Set - if error opening file, branch to error message
    LDR    R1, =BUFFER
	LDR    R2, =SIZE
    MOV    R3, R0           @ Save the file handle to R3
    SWI    SWI_RdStr        @ Read first integer from the input file into R0

@ Read all integers from a file
TOP:
    MOV    R6, R0           @ Copy integer to output register R1
	ADD    R4, R6, R4
    MOV    R0, #Stdout      @ Set output file handle to Stdout
    SWI    SWI_PrStr       @ Print the integer to the Output View
    
	Mov    R1, R6
	SWI    SWI_PrInt
    LDR    R1, =LF  
	MOV    R0, #Stdout      @ Set output file handle to Stdout
	SWI    SWI_PrStr
    
    MOV    R0, R3    	@ Move the input file handle to R0
	LDR    R1, =BUFFER
    SWI    SWI_RdStr        @ Read the next integer from the input file into R0
    BCC    TOP              @ Branch Carry Clear - if there was no read error (EOF), loo
	
	LDR    R1, =SUM        
    MOV    R0, #Stdout      @ Set output file handle to Stdout
	SWI    SWI_PrStr
	
	MOV    R1, R4 
	MOV    R0, #Stdout
	SWI    SWI_PrInt
	
@ Close the input file  
    MOV    R0, R3           @ Move the input file handle to R0
    SWI    SWI_Close        @ Close the input file
    BAL    Done             @ Branch ALways - skip over error handling
    
@ Print an error when file open fails
Error:
    LDR    R1, =ERR         @ Load address of error message string into R1
    MOV    R0, #Stdout      @ Set output file handle to Stdout
    SWI    SWI_PrStr        @ Print the string
    LDR    R1, =FILE        @ Load address of file name into R1
    SWI    SWI_PrStr        @ Print the file name

Done:
    SWI    SWI_Exit

.data
.equ SIZE, 80                     @ Size of string buffer storage (bytes)
     FILE:   .asciz "strings.txt" @ Input file name
     SUM:    .asciz "Sum: "       @ Final result title
     ERR:    .asciz "Error - could not open file: "    @ Error message string
     LF:     .asciz "\n"          @ Line Feed
     BUFFER: .space SIZE          @ Set aside SIZE bytes for a string
.end

I can put stuff here with no errors! It's after .end

Keven Iskander