TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
x   DWORD  153461
y   BYTE   37
z   BYTE   90


.code
main PROC
mov   AH, y
mov   AL, z

call writestring

invoke ExitProcess, 0
exit
main ENDP
END MAIN