TITLE Integer Accumulator     (IntAccu-TuckerLavell.asm)

; Author: Tucker Lavell
; Course / Project ID: Program #3    Date: 02/07/18
; Description: This program will ask the user for their name and store it.
;	It will then ask the user to enter numbers between -1 and -100. 
; 	Any other input is used to end user input, and calculate/display 
;	the sum and average of the users inputs. It will also tell the user
;	if they are quitting without entering any valid numbers
; Afterthoughts: After writing the outline(after not looking at the code for
;	a few days) I see some things I could do better that I will keep in mind
;	for the next program. I could have done the numInputs better, and maybe do
;	more labels instead of inline comments

;***************************** OUTLINE ****************************************
;*	Introduction:
;*		introduction:
;*			-introduce program/creator
;*			-ask users name, and store it
;*		userInstructions:
;*			-tell the user to enter a number between -100 and -1
;*			-tell the user to enter a non negative number to finish input
;*
;*	Input:
;*		getUserData:
;*			-increment the number of inputs (EC1)
;*			-tell the user to enter number #(numInputs)
;*			-jmp to inputValidation
;*				*NOTE: inputValidation is done BEFORE the input is stored
;*		inputValidation:
;*			-check if the input is greater than -1
;*				*NOTE: do this first because there is no need for anything
;*					else if they want to quit
;*				*if it is greater than 1, calculate the average
;*			-check if the input is less than -100
;*				*if it is less than -100 jump to outOfRange
;*			-if it passed both tests store the input
;*				*calculate the summation
;*		outOfRange:
;*			-if the number was less than -100
;*			-decrement numInputs
;*				*NOTE: was not valid input so it wasn't added
;*			-tell the user their input was out of range
;*			-show the user the range again
;*			-call getUserData again
;*
;*	Calculations:
;*		summation:
;*			-move sum to eax
;*				*NOTE: sum is a running total of the users inputs
;*			-add the input to eax
;*			-move the new value in eax back to sum
;*			-jump back to getUserData to get the next number
;*		average:
;*			-decrement number of inputs, because we didn't add one
;*			-prime the edx register to accept the remainder after division
;*			-move sum to eax
;*			-move numInputs to ebx
;*			-check if numInputs is 0
;*				*if it is, jump to emptyDisplay
;*			-if numInputs is greater than 0
;*			-use cdq to allow the eax sign bit to extend into edx
;*				*because we are about to divide signed numbers
;*			-use idiv to divide eax(sum) by ebx(numInputs)
;*			-the new value in eax is moved to avg
;*			-the remainder is moved from edx to rem
;*			-jump to display
;*
;*	Print:
;*		display:
;*			-tell the user the number of valid numbers they entered
;*			-tell the user the sum that was calculated from their inputs
;*			-tell the user the rounded average that was calculated
;*			-call farewell
;*		emptyDisplay:
;*			-tell the user they are exiting without doing anything
;*				*NOTE: this is only seen if the user inputs a number greater
;*					than -1 before adding any valid numbers
;*			-call farewell
;*		farewell:
;*			-tell the user goodBye using the name they entered earlier
;***************************** END OUTLINE ************************************


INCLUDE Irvine32.inc

.const
;constants
LIMIT EQU -100
INPUT_BUFFER EQU 100

.data
prog_name	BYTE "Integer Accumulator	", 0
whoBy		BYTE "by Tucker Lavell", 0
thanks		BYTE "Thank you for playing Integer Accumulator! ", 0
goodBye		BYTE "It's been a pleasure to meet you, ", 0

ask_userName	BYTE "What is your name? ", 0
hello			BYTE "Hello, ", 0
userName		BYTE INPUT_BUFFER + 1 DUP(?) ; leaves room for null

instruction_1	BYTE "Please enter numbers from -100 to -1, inclusive.", 0
instruction_2	BYTE "Enter a non-negative number when you are finished to see results.", 0
enter_Num		BYTE ". Enter number: ", 0
you_Entered		BYTE "You entered ", 0
valid_Nums		BYTE " valid numbers.", 0
entered_Nothing BYTE "You are quitting without doing anything!", 0
numInputs		SDWORD 0
input			SDWORD 0
oOR_input		BYTE "That number is out of range! ", 0
the_Sum			BYTE "The sum is: ", 0
the_Avg			BYTE "The rounded average is: ", 0
sum				SDWORD 0
avg				SDWORD 0
rem				SDWORD 0
UPPER_LIMIT		SDWORD (LIMIT + 99)
LOWER_LIMIT	 	SDWORD LIMIT

EC1		BYTE "**EC1: Number the lines during user input.", 0

.code
main PROC
;**** Introduction ****
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
	
;**** Input ****
; Get terms
getUserData:
	inc		numInputs
	mov		eax, numInputs
	call	WriteDec
	mov		edx, OFFSET enter_Num
	call	WriteString
	call	ReadInt
	jmp		inputValidation

; Input validation
inputValidation:
	cmp		eax, UPPER_LIMIT
	jg		average ; only want the average once the user wants to break
	cmp		eax, LOWER_LIMIT
	jl		outOfRange
	
	mov		input, eax
	jmp		summation

outOfRange:
	dec		numInputs
	mov		edx, OFFSET oOR_input
	call	WriteString
	mov		edx, OFFSET instruction_1
	call	WriteString
	call	CrLf
	call	getUserData

;**** Calculations ****
summation:
	
	mov		eax, sum
	add		eax, input
	mov		sum, eax
	jmp		getUserData

average:
; decrease numInputs because we didn't add one this time
	dec		numInputs
	mov		edx, rem
	mov		eax, sum
	mov		ebx, numInputs		
	
	cmp		ebx, 0
	jle		emptyDisplay
	
	; need to convert double to quad
	cdq
	idiv	ebx
	mov		avg, eax
	mov		rem, edx
	jmp 	display

;**** Print ****
display:
; Display number of valid numbers
	call	CrLf
	mov		edx, OFFSET you_Entered
	call	WriteString
	mov		eax, numInputs
	call 	WriteDec
	mov		edx, OFFSET valid_Nums
	call	WriteString
	call 	CrLf
	
; Display sum
	mov		edx, OFFSET the_Sum
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf
	
; Display avg
	mov		edx, OFFSET the_Avg
	call 	WriteString
	mov 	eax, avg
	call	WriteInt
	call 	CrLf
	call	farewell
	
; prints if the user is ending without entering any valid nums
emptyDisplay:
	call	CrLf
	mov		edx, OFFSET entered_Nothing
	call	WriteString
	call	CrLf
	call 	farewell

farewell:	
	call	CrLf
	mov 	edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf


	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
