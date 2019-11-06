TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)
Space MACRO spaces
	call CrLf

ENDM

.data

; (insert variable definitions here)

.code
main PROC
   push 3
   push 12
   call rcrsn
   exit
main ENDP

rcrsn PROC
   push ebp
   mov ebp,esp
   mov eax,[ebp + 12]
   mov ebx,[ebp + 8]
   cmp eax,ebx
   jl recurse
   jmp quit
recurse:
   inc eax
   push eax
   push ebx
   call rcrsn
   mov eax,[ebp + 12]
   call WriteDec
   Space 2
quit:
   pop ebp
   ret 8
rcrsn ENDP

; (insert additional procedures here)

END main
