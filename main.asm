model tiny
.386
.code
org 100h
Start:
;---------------------------------------
; save old interupt function adress
mov ax, 3509h
int 21h
mov cs:Old_int_offset, bx
mov bx, es
mov cs:Old_int_segment, bx
;---------------------------------------
; put new adress of interupt function in interupt table
push 0                    
pop es
mov bx, 4 * 09h                         ; place of interupt 09h
cli
mov word ptr es:[bx], offset Int_09     ; new adress of int 09h function
push cs
pop ax
mov es:[bx+2], ax
sti
;----------------------------------------
; Exit process on resident mode
mov ax, 3100h
mov dx, offset End_of_programm
shr dx, 4
inc dx
inc dx
int 21h
;----------------------------------------

Int_09         proc
    push ax bx es                       ; save all registers

    push 0b800h                         ; write symbol in the midle of page
    pop es
    mov bx, cs:PrintOfs
    mov ah, 4eh
    in al, 60h
    mov es:[bx], ax
    add bx, 2

    and bx, 0ffh                        ; check that pointer not be bigger than 256d
    mov cs:PrintOfs, bx

    pop es bx ax
    db 0EAh                             ; call default interupt
    Old_int_offset  dw 0
    Old_int_segment dw 0
                endp

.data
    PrintOfs        dw 0
.code

End_of_programm:                        ; Lable in end of programm to solve size of code block
end Start