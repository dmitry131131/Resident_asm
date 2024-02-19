model tiny
.386
.code
locals @@

White_back_black_front equ 70h
Black_back_white_front equ 07h

Border_height equ 14d
Border_width  equ 12d

End_of_int      macro
    in al, 61h                          ; Blink hi bit of keyboard controller register
    or al, 80h
    out 61h, al
    and al, not 80h
    out 61h, al

    mov al, 20h                         ; send end of interupt signal to interupt controller
    out 20h, al

    pop es bx ax
    iret
                endm

org 100h
Start:
jmp main

;--------------------------------
include data.asm
;--------------------------------
include border.asm
;--------------------------------
include repair.asm
;--------------------------------

main            proc
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
                endp

Int_09         proc
    push ax bx es                       ; save all registers

    in al, 60h                          ; check key 
    cmp al, 29h
    jne Skip_Border

    push 0b800h                  
    pop es

    cmp al, Privious_key
    je Skip_save

    call Save_page

    Skip_save:
    call DisplayBorder

    mov Privious_key, al
    End_of_int                          ; Blink hi bit of keyboard controller register and send end of interupt signal to interupt controller

    Skip_Border:
    cmp al, 29h + 128d
    jne Skip_clear

    call Repair_page

    mov Privious_key, al
    End_of_int                          ; Blink hi bit of keyboard controller register and send end of interupt signal to interupt controller

    Skip_clear:

    pop es bx ax
    mov Privious_key, al
    db 0EAh                             ; call default interupt
    Old_int_offset  dw 0
    Old_int_segment dw 0
                endp

End_of_programm:                        ; Lable in end of programm to solve size of code block
end Start