TITLE Fibonacci Numbers     (FibonacciSequence-TuckerLavell.asm)

; Author: Tucker Lavell
; Course / Project ID: Program #2    Date: 01/26/18
; Description: This program will ask the user for their name and store it.
;	It will then ask the user how many Fibonacci terms they wish to display.
;	The number must be in the range of 1-46 inclusive. Numbers larger than
;	the 46th number in the sequence are too large for our system. It will
;	then print the Fibonacci Sequence to the number of times the user wanted
;	to calculate.

INCLUDE Irvine32.inc

.const
;constants
LIMIT EQU 46
; http://programming.msjc.edu/asm/help/source/irvinelib/readstring.htm
INPUT_BUFFER EQU 100

.data
prog_name	BYTE "Fibonacci Numbers	", 0
whoBy		BYTE "by Tucker Lavell", 0
cert		BYTE "Results certified ", 0
goodBye		BYTE "Goodbye, ", 0

ask_userName	BYTE "What's your name? ", 0
hello			BYTE "Hello, ", 0
userName		BYTE INPUT_BUFFER + 1 DUP(?) ; leaves room for null

instruction_1	BYTE "Enter the number of Fibonacci terms to be displayed.", 0
instruction_2	BYTE "Must be a number in the range 1-46 inclusive.", 0
ask_numTerms	BYTE "How many Fibonacci terms do you want? ", 0
numTerms		DWORD 0
oOR_numTerms	BYTE "That number is out of range! ", 0
UPPER_LIMIT		DWORD LIMIT
LOWER_LIMIT	 	DWORD (LIMIT - 45)

printAlign	BYTE "	", 0
numCols		DWORD 0
numRows 	DWORD 0

EC1		BYTE "**EC1: Display the numbers in aligned columns.", 0

.code
main PROC

; Introduce program
introduction:
	mov		edx, OFFSET prog_name
	call	WriteString

; Introduce author
	mov 	edx, OFFSET whoBy
	call 	WriteString
	call 	CrLf
	
	mov		edx, OFFSET EC1
	call	WriteString
	call 	CrLf

	call	CrLf
	
; Ask users name
	mov		edx, OFFSET ask_userName
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, INPUT_BUFFER
	call	ReadString
	mov		edx, OFFSET	hello
	call	WriteString
	mov		edx, OFFSET userName
	call 	WriteString
	call	CrLf

; Instructions
userInstructions:
	mov		edx, OFFSET instruction_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruction_2
	call	WriteString
	call	CrLf
	
; Get number of terms
getUserData:
	mov		edx, OFFSET ask_numTerms
	call	WriteString
	call	ReadInt
	mov		numTerms, eax
	call	inputValidation
	
; Input validation
inputValidation:
	mov		ecx, numTerms
	cmp		ecx, UPPER_LIMIT
	jg		outOfRange
	cmp		ecx, LOWER_LIMIT
	jl		outOfRange
	; if input is not out of range prime eax and ebx with 0 and 1
	; first step of fib is 0+1 then increments from there
	mov		eax, 0
	mov		ebx, 1
	jmp		calcFib

outOfRange:
	mov		edx, OFFSET oOR_numTerms
	call	WriteString
	mov		edx, OFFSET instruction_2
	call	WriteString
	call	CrLf
	call	getUserData

; Calculations
calcFib:
	mov		edx, eax 	; edx will essentially hold the sum throughout
	add		edx, ebx
	mov		eax, ebx 	; replace eax with ebx
	mov		ebx, edx	; replace ebx with edx (whichis the sum of eax and ebx)
	call	displayFibs
	
; Print	and go back to calcFib
displayFibs:
	call	WriteDec
	inc		numCols
	mov		edx, OFFSET printAlign
	.IF	(numCols == 5)
		call	CrLf
		mov		numCols, 0 	; reset column tracker every 5 prints
		inc		numRows 	; increase num of rows every 5 prints
	.ELSEIF		(numRows < 7) && (numCols <= 4)
		call	WriteString
		call	WriteString
	.ELSE
		call	WriteString
	.ENDIF
	loop 	calcFib
	
	; when the loop is over
	call	CrLf
	call	CrLf
	mov		edx, OFFSET cert
	call 	WriteString
	mov		edx, OFFSET whoBy
	call	WriteString

; Before exiting program say bye
farewell:	
	call	CrLf
	mov 	edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	
	exit	; exit to operating system
main ENDP

END main
