TITLE Program Sort Randoms     (SortRandoms.asm)

; Author: Tucker Lavell
; Course / Project ID: Program #5    Date: 02/28/18
; Description: This program 
; Credits: 
;	Print/Fill array
;		Lectures/demo5.asm from teacher
;	Bubble Sort
;		https://stackoverflow.com/questions/29858871/is-there-an-easier-way-to-write-a-bubble-sort-algorithm-in-masm-modular-style

INCLUDE Irvine32.inc

.const
;constants
LIMIT EQU 200
COLS_PER_LINE EQU 10
INPUT_BUFFER EQU 100
LO EQU 100
HI EQU 999

.data
prog_name	BYTE "Sorting Random Integers ", 0
whoBy		BYTE "by Tucker Lavell.", 0

instruction_1	BYTE "This program generates random numbers in the range 100-999, ", 0
instruction_2	BYTE "displays the original list, sorts the list, and calculates the ", 0
instruction_3	BYTE "median value. Finally, it displays the descending order sorted list.", 0
output_median	BYTE "Median Value: ", 0
median			DWORD 0
ask_numTerms	BYTE "How many numbers should be generated? [10-200]: ", 0
numTerms		DWORD 0
oOR_numTerms	BYTE "Out of range! Try again. ", 0
MAX				SDWORD LIMIT 			; 200
MIN			 	SDWORD (LIMIT - 190)	; 10
printAlign		BYTE "   ", 0
numCols			DWORD 0
numRows 		DWORD 0
numbersArr		DWORD LIMIT DUP(?)

EC1		BYTE "**EC2: Use a recurive sorting algorithm. I used Bubble Sort.", 0


.code
main PROC
	call 	Randomize
	
	call 	introduction
	
	push 	OFFSET numTerms
	call 	getData
	
	push 	OFFSET numbersArr
	push	numTerms
	call 	fillArray
	
	push	OFFSET numbersArr
	push	numTerms
	call 	displayList
	
	push	OFFSET numbersArr
	push	numTerms
	call 	sortList
	
	call	CrLf
	
	push	OFFSET numbersArr
	push	numTerms
	call 	displayMedian
	
	push	OFFSET numbersArr
	push	numTerms
	call 	displayList

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
	mov		edx, OFFSET instruction_3
	call	WriteString
	call	CrLf


	ret
introduction ENDP

getData PROC
	push	ebp
	mov		ebp, esp

askRange:
	mov		edx, OFFSET ask_numTerms
	call	WriteString
	call	ReadInt
	jmp		validateInput

validateInput:
	cmp		eax, MAX
	jg		print_outOfRange 
	cmp		eax, MIN
	jl		print_outOfRange
	
	mov		ebx, [ebp + 8]	; numTerms in ebx
	mov		[ebx], eax		; store input at ebx address
	
	pop		ebp
	; return if the input was valid
	ret		4

print_outOfRange:
	mov		edx, OFFSET oOR_numTerms
	call	WriteString
	call	CrLf
	jmp 	askRange

	
	ret
getData ENDP

fillArray PROC
	
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp + 8]	; numTerms is counter
	mov		edi, [ebp + 12]	; where the array starts
	jmp		fill
	
generateNum:
	mov		eax, HI
	sub		eax, LO
	inc		eax
	call 	RandomRange
	add		eax, LO
	
	ret		

fill:
	call	generateNum
	mov		[edi], eax
	add		edi, 4
	loop 	fill
	
	pop 	ebp
	ret		8

fillArray ENDP

; displayList PROC
	; push	ebp
	; mov		ebp, esp
	; mov		edx, [ebp + 8]	; count
	; mov		esi, [ebp + 12]
	; dec 	edx				; make edx work for count-1...0

; print:
	; mov		eax, [esi] ; maybe +4
	; call	WriteDec
	; call	CrLf
	; dec		edx
	; add		esi, 4
	; cmp		edx, 0
	; jge		print
	
	; pop 	ebp
	; ret		8

	; ret
; displayList ENDP

displayList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp + 8]	; count
	mov		esi, [ebp + 12]
	mov		numCols, 0
	jmp 	printList

printList:
	inc 	numCols
	mov		eax, [esi]
	call	WriteDec
	
	call 	nextCol
	
	dec		edx
	add		esi, 4
	loop	printList
	
	call	CrLf
	pop 	ebp
	ret		8

nextCol:
	cmp		numCols, COLS_PER_LINE
	jge		nextRow

	mov		edx, OFFSET printAlign
	call	WriteString
	
	ret
	
nextRow:
	mov		numCols, 0
	call	CrLf
	
	ret
	
displayList ENDP


; bubble sort
sortList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp + 8]
	mov		edx, [ebp + 8]
	mov		esi, [ebp + 12]
	
compare:
	mov		eax, [esi]
	cmp		eax, [esi + 4]
	jl		swap
	
	add 	esi, 4	
	loop 	compare
	
	jmp		checkNext
	
swap:
	xchg	eax, [esi + 4]
	mov		[esi], eax
	
	add 	esi, 4	
	loop 	compare
	
	jmp 	checkNext
	
checkNext:
	mov		ecx, [ebp + 8] ; reset counter
	mov		esi, [ebp + 12] ; reset esi back to the beginning of the array
	
	dec		edx
	cmp		edx, 0
	jg		compare
	
	pop 	ebp
	ret
sortList ENDP

displayMedian PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 12]

calcCenter:
	mov 	edx, 0 			; prime edx for a possible remainder
	mov		eax, [ebp + 8]
	mov		ebx, 2
	div		ebx 			; divide by 2
	
	cmp		edx, 0			; check for remainder
	je		isEven
	jg		isOdd
	
isEven:
	mov		ebx, eax				; ebx becomes "true center" of the set
	dec		eax						; eax becomes "true center" of the array
	mov		eax, [esi + eax * 4]
	mov		ebx, [esi + ebx * 4]
	add		eax, ebx
	mov		ebx, 2
	div		ebx
	
	jmp		printMedian
	
isOdd:
	mov		eax, [esi + eax * 4]
	jmp		printMedian

printMedian:
	mov		edx, OFFSET output_median
	call	WriteString
	call	WriteDec
	call 	CrLf
	call	CrLf
	
	pop 	ebp	
	ret
	
displayMedian ENDP

END main
