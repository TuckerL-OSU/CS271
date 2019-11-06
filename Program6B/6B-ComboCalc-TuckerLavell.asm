TITLE Combinations Calculator     (6B-ComboCalc-TuckerLavell.asm)

; Author: Tucker Lavell
; Course / Project ID: Program #6B    Date: 03/14/18
; Description: This program plays a math game with the user. It will randomly generate a number for the
;	"set" and based off that set randomly generate a number of combinations the user should try to
;	make from the set. The user then inputs their guess, and the game will tell them if they were
;	right or wrong, as well as the correct answer. It will also keep track of the number of questions they 
;	have done and how many they have gotten right and wrong. It will ask the user after each question if 
;	they want to continue or not. If they choose not, the game will display their final score and end.
; Resources:
; https://stackoverflow.com/questions/13664778/converting-string-to-integer-in-masm-esi-difficulty
; https://stackoverflow.com/questions/37351591/compare-char-to-user-input-char-masm
; https://stackoverflow.com/questions/13657007/unhandled-exception-recursive-factorial-in-assembly-masm

INCLUDE Irvine32.inc

mPrintStr MACRO stringToPrint
	push	edx
	mov		edx, OFFSET stringToPrint
	call	WriteString
	pop		edx
ENDM

mPrintDec MACRO	decToPrint
	push	eax
	mov		eax, decToPrint
	call	WriteDec
	pop		eax	
ENDM
	
.const
LIMIT EQU 12 ;
INPUT_BUFFER EQU 12

.data
prog_name	BYTE "Combinations Calculator ", 0
whoBy		BYTE "by Tucker Lavell.", 0
goodBye		BYTE "OK...Have a nice day!" , 0

instruction_1	BYTE "Ill give you a combinations problem. ", 0
instruction_2	BYTE "You will enter an answer, and I will tell you if you are correct. ", 0

print_Problem	BYTE "Problem #", 0
problemNum		DWORD 0
print_numInSet	BYTE "Number of elements in the set: ", 0
numInSet		DWORD 0		; n
print_numChoose	BYTE "Number of elements to choose from the set: ", 0
numChoose		DWORD 0		; r
ask_Answer		BYTE "How many ways can you choose? ", 0
read_userAnswer	BYTE INPUT_BUFFER + 1 DUP(0) ;"string" used to read user input
user_Answer		DWORD 0
invalid_Answer	BYTE "Invalid. Try again! ", 0

display_Actual_1	BYTE "There are ", 0
actual_Answer	DWORD 0
divisor			DWORD 0
display_Actual_user	BYTE "(", 0
display_Actual_2	BYTE ") combinations of ", 0
display_Actual_3	BYTE " items from a set of ", 0
wrong_Answer	BYTE "Incorrect! You need more practice.", 0
numWrong		DWORD 0
correct_Answer	BYTE "You are correct!" , 0
numCorrect		DWORD 0
ask_Another		BYTE "Another problem? (y/n): ", 0
another_Input	BYTE INPUT_BUFFER + 1 DUP(0)

final_1		BYTE "You answered ", 0
final_2		BYTE " questions. You got ", 0
final_3		BYTE " correct, and ", 0
final_4		BYTE " wrong.", 0

N_MAX	DWORD LIMIT
N_MIN	DWORD (LIMIT - 9)
R_MAX	DWORD numInSet
R_MIN	DWORD (LIMIT - 11)

EC1		BYTE "**EC1: Number each problem and keep score.", 0

.code
main PROC
	call 	Randomize
	
	call 	introduction
	call	play
	
	exit	; exit to operating system
main ENDP

;**** Intro ****
introduction PROC
prog:
	mov		edx, OFFSET prog_name
	call	WriteString

author:
	mov 	edx, OFFSET whoBy
	call 	WriteString
	call 	CrLf

ec:
	mov		edx, OFFSET EC1
	call	WriteString
	call 	CrLf

instructions:
	mov		edx, OFFSET instruction_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruction_2
	call	WriteString
	call	CrLf

	ret
introduction ENDP

play PROC
game:
	push	OFFSET numChoose		;r,12
	push	OFFSET numInSet			;n,8
	call	showProblem
	
	push 	OFFSET read_userAnswer	;16
	push	OFFSET user_Answer		;12
	push	INPUT_BUFFER			;8
	call 	getData
	
	push	OFFSET divisor			;20
	push	OFFSET actual_Answer 	;16
	push	numChoose				;r,12
	push	numInSet				;n,8
	call	combinations
	
	push	actual_Answer			;20
	push	user_Answer				;16
	push	numChoose				;12
	push	numInSet				;8
	call	showResults

playAgain:
	mPrintStr ask_Another
	mov		edx, OFFSET another_Input
	mov		ecx, INPUT_BUFFER
	call	ReadString
	mov     al, [edx]      ;1st character from user
	or		al, 20h        ;make LCase
	cmp     al, "y"     ;compare to "y"
	je      clear
	cmp     al, "n"      ;compare to "n"
	je      displayFinalScore
	jmp		playAgain
	
displayFinalScore:
	mPrintStr 	final_1
	mPrintDec 	problemNum
	mPrintStr	final_2
	mPrintDec	numCorrect
	mPrintStr	final_3
	mPrintDec	numWrong
	mPrintStr	final_4
	call		CrLf
	mPrintStr	goodBye
	call 		CrLf

	ret
clear:
	; reset the values of everyone
	mov		numChoose, 0h
	mov		numInSet, 0h
	mov		read_userAnswer, 0h
	mov		user_Answer, 0h
	mov		another_Input, 0h
	mov 	eax, 0h
	mov 	ebx, 0h
	mov		ecx, 0h
	mov		edx, 0h
	mov		N_MAX, LIMIT
	jmp 	game
	
play ENDP

;**** Show Problem **** 
showProblem PROC
	push 	ebp
	mov		ebp, esp
beginProblem:
	inc			problemNum
	mPrintStr	print_Problem
	mPrintDec	problemNum
	call 		CrLf
	
	call		generateN
	mPrintStr	print_numInSet
	mPrintDec	[ebp + 8]
	call		CrLf
	
	call		generateR
	mPrintStr	print_numChoose
	mPrintDec	[ebp + 12]
	call		CrLf
	
	pop 	ebp
	ret 	8
	
generateN:
	mov		eax, N_MAX
	sub		eax, N_MIN
	inc		eax
	call	RandomRange
	add		eax, N_MIN
	mov		[ebp + 8], eax
	mov		numInSet, eax
	ret
	
generateR:
	mov		eax, [ebp + 8]
	sub		eax, R_MIN
	inc		eax
	call 	RandomRange
	add		eax, R_MIN
	mov		[ebp + 12], eax
	mov		numChoose, eax
	ret
showProblem ENDP

getData PROC
	push 	ebp
	mov		ebp, esp
	
askInput:
	mov		edx, [ebp + 16] ;read_userAnswer 
	mov		ecx, [ebp + 8]	;INPUT_BUFFER
	mPrintStr ask_Answer
	call 	ReadString
	cmp		eax, 10 ; check if the input is more digits than a likely answer
	jge		askInput
	
	mov		ecx, eax
	mov		esi, [ebp + 16]

	pushad
validateInput:
	mov     ebx, [ebp + 12]
    mov     eax, [ebx]   ;move address of answer into eax
    mov     ebx, 10d     
    mul     ebx         ;multiply answer by 10
    mov     ebx, [ebp + 12]    ;move address of answer into ebx
    mov     [ebx], eax       ;add product to answer
    mov     al, [esi]        ;move value of char into al register
    inc     esi         ;point to next char
    sub     al, 48d      ;subtract 48 from ASCII value of char to get integer  

    cmp     al, 0            ;error checking to ensure values are digits 0-9
    jl      invalidInput
    cmp     al, 9
    jg      invalidInput

    mov     ebx, [ebp + 12] 	;move address of answer into ebx
    add     [ebx], al        ;add int to value in answer
    loop    validateInput  
	; dereference the answer so we can store its value
	mov		ebx, [ebp + 12]
	mov		ebx, [ebx]
	mov		user_Answer, ebx
	
	popad
	jmp		goodInput
invalidInput:               ;reset registers and variables to 0
    mov     al,0
    mov     eax,0
    mov     ebx,[ebp+12]
    mov     [ebx],eax
    mov     ebx,[ebp+16]
    mov     [ebx],eax       
    mPrintStr   invalid_Answer
	; restore the registers because we are going to push them again anyway
	popad
    jmp     askInput

goodInput:	
	pop 	ebp
	ret 	12
getData ENDP

combinations PROC
	push	ebp
	mov		ebp, esp
	
	; if they are equal, then you can only have 1 combo
	mov		eax, [ebp + 8]
	mov		ebx, [ebp + 12]
	cmp		eax, ebx
	je		one
	
nMinusRFac:						;(n - r)!
	mov		eax, [ebp + 8]		;move n to eax
	sub		eax, [ebp + 12]		;minus r 
	mov		ebx, eax
	push	ebx
	call	factorial			
	mov		edx, [ebp + 20]		;
	mov		[edx], eax

rFac:							;r!
	mov		ebx, [ebp + 12]		;move r to ebx
	push	ebx
	call	factorial			
	
rTimesNMinusR:					;r! * (n - r)!
	mov		edx, [ebp + 20]
	mov		ebx, [edx]
	mul		ebx
	mov		ebx, [ebp + 20]
	mov		[ebx], eax	
	
nFac:							;n!
	mov		ebx, [ebp + 8]
	push 	ebx
	call 	factorial
	mov		edx, [ebp + 20]
	mov		ebx, [edx]
	jmp		combo
	
combo:						;n! / (r! * (n - r)!)
	mov		edx, 0
	div		ebx
	jmp		saveAnswer
	
one:	
	mov		eax, 1
	jmp		saveAnswer
	
saveAnswer:
	mov		ebx, [ebp + 16]
	mov		[ebx], eax
	mov		actual_Answer, eax

	pop ebp
	ret 16
combinations ENDP

factorial PROC
	mov		eax, DWORD ptr [esp + 4]
	cmp 	eax, 1
	jle		baseCase
	dec 	eax
	push 	eax
	call	factorial
	; base case returns to here, to multiply each number in the set
	mov		esi, DWORD ptr [esp + 4]
	mul		esi
	
baseCase:
	ret 	4
	
factorial ENDP

showResults PROC
	push	ebp
	mov		ebp, esp
	
	mPrintStr	display_Actual_1
	mPrintDec	[ebp + 20]				;actual_Answer
	mPrintStr	display_Actual_user
	mPrintDec	[ebp + 16]				;user_Answer
	mPrintStr	display_Actual_2
	mPrintDec	[ebp + 12]				;r numChoose
	mPrintStr	display_Actual_3
	mPrintDec	[ebp + 8]				;n numInSet
	call		CrLf
	
	mov		eax, [ebp + 16]
	cmp		eax, [ebp + 20]
	jne		wrong
	je		correct
	
wrong:
	mPrintStr	wrong_Answer
	call	CrLf
	inc		numWrong
	jmp		moveOn

correct:
	mPrintStr	correct_Answer
	call	CrLf
	inc		numCorrect
	jmp		moveOn

moveOn:
	pop 	ebp
	ret		16
showResults ENDP

END main
