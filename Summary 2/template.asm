TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
result DWORD ?

.code
main PROC
mov    eax,7
    mov    ebx,1
	mov		ecx, 3
    mov    edx,2
     mov edx, eax
mov ebx, ecx
mov ebx, edx
mov ecx, ebx
mov edx, eax
	invoke ExitProcess, 0
	exit	; exit to operating system

main ENDP

; (insert additional procedures here)

END main

