TITLE Program Sort Randoms     (SortRandoms-TuckerLavell.asm)

; Author: Tucker Lavell
; Course / Project ID: Program #5    Date: 02/28/18
; Description: This program asks the user to input a number between 10 and 200.
;	The program will then print that many random numbers between 100-999.
;	Next it will sort the array that stored the random numbers, and print the median.
;	Finally it will display the sorted array
; Credits: 
;	Print/Fill array
;		Lectures/demo5.asm from teacher
;	Bubble Sort
;		https://stackoverflow.com/questions/29858871/is-there-an-easier-way-to-write-a-bubble-sort-algorithm-in-masm-modular-style

;***************************** OUTLINE ****************************************
;*	Intro:
;*		introduction:
;*			-introduce program/creator
;*		extra credit
;*		instructions:
;*			-tell the user to enter a number between 100-999, inclusive
;*			-tell the user they will be shown a list of random numbers,
;*				the median, and the list of numbers sorted in descending order
;*
;*	GetData:
;*		askRange:
;*			-tell the user to enter number of terms to see
;*			-jmp to validateInput
;*				*NOTE: validateInput is done BEFORE the input is stored
;*		validateInput:
;*			-check if the input is greater than 200
;*			-check if the input is less than 10
;*				*if it is either, jmp to out of range
;*			-if it passed both tests store the input
;*				*return jumps back to main
;*		outOfRange:
;*			-if the number was less than 10 or greater than 200
;*				*tell the user their input was out of range
;*			-call askRange again
;*
;*	FillArray:
;*		set ecx, based off the count stored for the array size
;*		set edi, to address of the beginning of the array
;*		jmp to fill
;*		fill:
;*			-call generateNum
;*			-mov the value of eax to the next element in the array
;*			-add 4(Bytes) to edi to get the next position in the array
;*			-loop on fill
;*			-pop the array off the stack
;*			-return 8(Bytes) to clear the rest of the stack (12 Bytes total)
;*
;*	DisplayList:
;*		set ecx, based off the count stored for the array size
;*		set esi, to address of the beginning of the array
;*		reset numCols printed back to 0
;*		check if the array has been sorted yet based off the value of isSorted 
;*		sorted:
;*			-if it is sorted print that the array is sorted
;*			-jmp to printList
;*		notSorted:
;*			-if it is not sorted print the array is not sorted
;*			-jmp to printList
;*		printList:
;*			-increment numCols
;*			-set the next element of the array to eax
;*			-print the number
;*			-call nextCol
;*			-add 4(Bytes) to esi to get to the next element in the array (8 total)
;*			-loop back on printList
;*			-pop ebp off the stack
;*			-return 8(Bytes) to clear the stack (12 total)
;*		nextCol:
;*			-check how many columns have already been printed
;*				*if numCols is 10+, jump to nextRow
;*			-print "spacer" for alignment
;*			-returns back in to printList
;*		nextRow:
;*			-reset numCols back to 0
;*			-move the cursor the beginning of the next line
;*			-returns back to printList where nextCol was called from
;*	SortList: (bubble sort)
;*		set ecx to the counter (used to loop internal loop)
;*		set edx to the counter (used to loop outer loop)
;*		set esi to the beginning of the array
;*		compare:
;*			-move the front of the array to eax
;*			-compare the value at eax to the next value in the array
;*				*if the value of eax is less than the value of the next element
;*					jmp to swap
;*				*else add 4(Bytes) to esi to get the address of the next element
;*			-loop on compare
;*			-jmp to checkNext
;*		swap:
;*			-swap the larger value from the next element (esi+4) with eax
;*			-set the "previous" element in the array to eax
;*			-add 4(Bytes) to esi to compare with the next element in the array
;*			-loop on compare
;*			-jmp checkNext
;*		checkNext:
;*			-reset ecx counter since we have fallen out of compare now
;*			-reset esi back to the beginning of the array
;*			-decrement edx (this is the counter for this part of the loop)
;*			-while edx > 0
;*				*jump back to compare and start compare/swap again
;*			-once checkNext falls through on edx = 0
;*				*set isSorted to 1
;*			-pop ebp off the stack
;*			-return jumps back to main
;*
;*	displayMedian:
;*		set esi to the front of the array
;*		calcCenter:
;*			-prime edx for division by setting it to 0
;*			-take the numTerms and set it to eax
;*			-move 2 to ebx so we can divide
;*			-divide eax by 2
;*			-check for a remainder in edx
;*				*if there is no remainder jump to isEven
;*				*if there is a remainder jump to isOdd
;*		isEven:
;*			-move the value in eax to ebx (ebx is the "true center" of the number set)
;*			-decrement eax (eax is now the "true center" of the array (0 count))
;*			-use eax to offset esi to find the value there
;*			-use ebx to offset esi to find the value there
;*			-add eax and ebx
;			-set ebx to 2 now (for division)
;*			-div eax by ebx to get the median of the even set of numbers
;*				*NOTE: since this was even there was no remainder so edx does not need to 
;*					be primed again for the remainder
;*			-jmp printMedian
;*		isOdd:
;*			-use eax to offset esi to find the value there
;*			-jmp printMedian
;*		printMedian:
;*			-print the median value
;*			-pop ebp off the stack
;*			-return jumps back to main
;***************************** END OUTLINE ************************************

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
numbersArr		DWORD LIMIT + 4 DUP(?)
randList		BYTE "The unsorted random numbers: ", 0
sortedList		BYTE "The sorted list: ", 0
isSorted		DWORD 0

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
	mov		edx, OFFSET instruction_3
	call	WriteString
	call	CrLf

	ret
introduction ENDP

;**** Get User Input ****
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

getData ENDP

;**** Fill array with random numbers ****
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

;**** Print Array ****
displayList PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp + 8]	; count
	mov		esi, [ebp + 12]
	mov		numCols, 0
	
	cmp		isSorted, 0
	jnz		sorted
	jz		notSorted

sorted:
	mov		edx, OFFSET sortedList
	call	WriteString
	call	CrLf
	
	jmp		printList
	
notSorted:
	mov		edx, OFFSET randList
	call	WriteString
	call	CrLf
	
	jmp		printList

printList:
	inc 	numCols
	mov		eax, [esi]
	call	WriteDec
	
	call 	nextCol
	
	add		esi, 4
	loop	printList
	
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


;**** Bubble Sort ****
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
	
	mov		isSorted, 1
	pop 	ebp
	ret
sortList ENDP

;**** Print Median ****
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
