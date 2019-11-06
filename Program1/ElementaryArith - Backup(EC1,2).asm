TITLE Elementary Arithmatic     (ElementaryArith.asm)

; Author: Tucker Lavell
; Course / Project ID: Program #1    Date: 01/17/18
; Description: This program will take a users input of 2 numbers,
;	and print out the sum, difference, product, quotient, and remainder

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
; First Test
; Introduction
prog_name	BYTE "Elementary Arithmatic	", 0
whoBy		BYTE "by Tucker Lavell", 0
; forgot ", 0" at first which was causing prompt_1 to print at the end as well
goodBye		BYTE "Impressed? Bye!", 0

; Second Test
; Get input
; to fit 80 chars
prompt_1	BYTE "Enter 2 numbers, and I'll show you ", 0
prompt_1_cont BYTE "the sum, difference, product, quotient, and remainder.", 0
firstNum	DWORD ?
secondNum	DWORD ?
; Where input is stored
first	BYTE "First Number: ", 0
second	BYTE "Second Number: ", 0

; Third Test
; Print equations
plus	BYTE " + ", 0
minus	BYTE " - ", 0
multi	BYTE " * ", 0
divi	BYTE " / ", 0
remainder	BYTE " remainder ", 0
equal	BYTE " = ", 0

; Fourth Test
; Do math
sum		DWORD 0 ; +
diff	DWORD 0 ; -
prod	DWORD 0 ; *
quot 	DWORD 0 ; /
rem 	DWORD 0 ; remainder

; EC 1
yes		BYTE "1. Yes", 0
no		BYTE "2. No", 0
play_again BYTE "Press 1 to re-calulate differnt numbers ", 0
play_again_cont BYTE "or any button to continue...", 0
play_choice	DWORD ?
EC1		BYTE "**EC1: Program repeats until user wants to quit.", 0

; EC 2
EC2 	BYTE "**EC2: Input Validation.", 0
EC2_lessThan BYTE "The second number must be less than the first!", 0
EC2_divByZero BYTE "You can't divide by 0, are you crazy?!", 0

; EC 3
EC3		BYTE "", 0
EC3_fquot QWORD ?

.code
main PROC

; 1.Introduce program
intro:
	mov		edx, OFFSET prog_name
	call	WriteString

; 1. Introduce author
	mov 	edx, OFFSET whoBy
	call 	WriteString
	call 	CrLf
	
	mov		edx, OFFSET EC1
	call	WriteString
	call 	CrLf
	mov		edx, OFFSET EC2
	call	WriteString
	call 	CrLf

	call	CrLf
	
instructions:
; 2. Tell user what to do
	mov 	edx, OFFSET prompt_1
	call 	WriteString
	mov		edx, OFFSET prompt_1_cont
	call	WriteString
	call 	CrLf

input:
; 2. Get First Number
	mov 	edx, OFFSET first
	call 	WriteString
	call	ReadInt
	mov		firstNum, eax
	
; 2. Get Second Number
	mov 	edx, OFFSET second
	call	WriteString
	call	ReadInt
	;mov		secondNum, eax
	
; EC 2. Input Validation
inputValidation:
	; check if secondNum is larger than firstNum
	cmp		eax, firstNum
	jg		secondIsGreater
	cmp		eax, 0
	je		divByZero
	mov		secondNum, eax
	jmp 	math
	
secondIsGreater:
	mov		edx, OFFSET EC2_lessThan
	call 	WriteString
	call	CrLf
	jmp		redo
	
divByZero:
	mov		edx, OFFSET EC2_divByZero
	call 	WriteString
	call	CrLf
	jmp		redo

math:
; 4. Calculations
	; add
	mov		eax, firstNum
	add		eax, secondNum
	mov		sum, eax
	
	; sub
	mov		eax, firstNum
	sub		eax, secondNum
	mov		diff, eax
	
	; multi
	mov		eax, firstNum
	mov		ebx, secondNum
	mul		ebx
	mov		prod, eax
	
	; div
	mov		edx, rem
	mov		eax, firstNum
	mov		ebx, secondNum
	div 	ebx
	mov 	quot, eax
	mov 	rem, edx
	
; 2. Print user input
; 3. Print
print:
	;mov 	edx, OFFSET firstTest
	;call	WriteString
	
	; +
	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET plus
	call 	WriteString
	;call	CrLf	
	;mov		edx, OFFSET secondTest
	;call 	WriteString
	mov		eax, secondNum
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call 	CrLf
	
	; -
	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET minus
	call 	WriteString
	mov		eax, secondNum
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, diff
	call	WriteDec
	call 	CrLf

	; *
	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET multi
	call 	WriteString
	mov		eax, secondNum
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, prod
	call	WriteDec
	call 	CrLf

	; /
	mov		eax, firstNum
	call	WriteDec
	mov		edx, OFFSET divi
	call 	WriteString
	mov		eax, secondNum
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, quot
	call	WriteDec
	mov		edx, OFFSET remainder
	call 	WriteString
	mov		eax, rem
	call 	WriteDec
	call 	CrLf

; EC 1 Loop until user wants to quit
redo:
	mov 	edx, OFFSET play_again
	call 	WriteString
	mov 	edx, OFFSET play_again_cont
	call 	WriteString
	call	CrLf
	call	ReadInt
	mov		play_choice, eax
	cmp		eax, 1
	je		again
	jmp		bye

again:
	; clear memory
	mov 	eax, 0h
	mov 	ebx, 0h
	mov		edx, 0h
	mov		quot, 0h
	mov		rem, 0h
	call	instructions
	
bye:	
; 1. Before exiting program say bye
	mov 	edx, OFFSET goodBye
	call	WriteString
	call	CrLf
	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
