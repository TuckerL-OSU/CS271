TITLE Composite Numbers     (CompNums-TuckerLavell.asm)

; Author: Tucker Lavell
; Course / Project ID: Program #3    Date: 02/16/18
; Description: This program will ask the user for their name and store it.

INCLUDE Irvine32.inc

.const
;constants
LIMIT EQU 400
COLS_PER_LINE EQU 10
INPUT_BUFFER EQU 100

.data
prog_name	BYTE "Composite Numbers ", 0
whoBy		BYTE "by Tucker Lavell.", 0
cert		BYTE "Results certified ", 0
goodBye		BYTE "Goodbye.", 0

instruction_1	BYTE "Enter the number of composite numbers you would like to see", 0
instruction_2	BYTE "I'll accpet orders for up to 400 composites", 0
ask_numTerms	BYTE "How many composites would you like to see? [1-400]: ", 0
numTerms		DWORD 0
oOR_numTerms	BYTE "Out of range! Try again. ", 0
UPPER_LIMIT		SDWORD LIMIT
LOWER_LIMIT	 	SDWORD (LIMIT - 399)
printAlign		BYTE "   ", 0
numCols			DWORD 0
numRows 		DWORD 0
currentNum		DWORD 4
divisor			DWORD 2
isComp			DWORD ?

;primes		DWORD LIMIT * 2 DUP(0)

; EC1		BYTE "**EC1: Format output.", 0

.code
main PROC
	call introduction
	call getUserData
	call showComposites
	call farewell

	exit	; exit to operating system
main ENDP

introduction PROC
	prog:
		mov		edx, OFFSET prog_name
		call	WriteString

	author:
		mov 	edx, OFFSET whoBy
		call 	WriteString
		call 	CrLf

	;ec:
	instructions:
		mov		edx, OFFSET instruction_1
		call	WriteString
		call	CrLf
		mov		edx, OFFSET instruction_2
		call	WriteString
		call	CrLf

	ret
introduction ENDP

getUserData PROC
	askComposites:
		mov		edx, OFFSET ask_numTerms
		call	WriteString
		call	ReadInt
		jmp		validate

	validate:
		cmp		eax, UPPER_LIMIT
		jg		outOfRange 
		cmp		eax, LOWER_LIMIT
		jl		outOfRange
		
		mov		numTerms, eax
		; return if the input was valid
		ret

	outOfRange:
		mov		edx, OFFSET oOR_numTerms
		call	WriteString
		call	CrLf
		jmp 	askComposites

	
	ret
getUserData ENDP

showComposites PROC
	mov		ecx, numTerms
	mov		eax, currentNum
	mov		ebx, divisor
	
	mov		edx, 0
	div		ebx
	
	cmp		edx, 0
	je		isComposite
		
	isComposite:
		
	
	
	ret
showComposites ENDP


farewell PROC
	call	CrLf
	mov 	edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	ret
farewell ENDP


END main
