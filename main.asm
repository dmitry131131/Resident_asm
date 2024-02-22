model tiny
.386
.code
locals @@

White_back_black_front equ 70h
Black_back_white_front equ 07h

Border_height equ 13d
Border_width  equ 12d

CS_adress equ 6d * 11d + 2d
IP_adress equ 6d * 12d + 2d

End_of_int      macro
    in al, 61h                          ; Blink hi bit of keyboard controller register
    or al, 80h
    out 61h, al
    and al, not 80h
    out 61h, al

    mov al, 20h                         ; send end of interupt signal to interupt controller
    out 20h, al

    pop ax
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
include to_hex.asm
;--------------------------------

main            proc
    ;---------------------------------------
    ; save old interupt 09 function adress
    mov ax, 3509h
    int 21h
    mov cs:Old_int_09_offset, bx
    mov bx, es
    mov cs:Old_int_09_segment, bx
    ;---------------------------------------
    ; save old interupt 08 function adress
    mov ax, 3508h
    int 21h
    mov cs:Old_int_08_offset, bx
    mov bx, es
    mov cs:Old_int_08_segment, bx
    ;---------------------------------------
    ; put new adress of interupt 9 function in interupt table
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
    ; put new adress of interupt 8 function in interupt table
    push 0                    
    pop es
    mov bx, 4 * 08h                         ; place of interupt 09h
    cli
    mov word ptr es:[bx], offset Int_08     ; new adress of int 09h function
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
    push ax                             ; save all registers

    in al, 60h                          ; check key 
    cmp al, 29h
    jne Skip_Border

    cmp cs:Activate_flag, 0d            ; If flag == 1
    jne Skip_save
    call Save_page                      ; saving background

    Skip_save:

    not cs:Activate_flag

    cmp Activate_flag, 0d               ; if flag == 1 
    jne Skip_repair

    Skip_repair:
    call Repair_page

    End_of_int                          ; Blink hi bit of keyboard controller register and send end of interupt signal to interupt controller

    Skip_Border:
    pop ax
    db 0EAh                             ; call default interupt
    Old_int_09_offset  dw 0
    Old_int_09_segment dw 0
                endp

Int_08          proc
    push es                      

    cmp cs:Activate_flag, 0             ; if flag == 0
    je @@Skip_draw

    call Save_registers                 ; save registers in memory

    push 0b800h                         ; Display border       
    pop es
    call DisplayBorder                  ; display border

    @@Skip_draw:
    pop es
    db 0EAh                             ; call default interupt
    Old_int_08_offset  dw 0
    Old_int_08_segment dw 0
                endp

End_of_programm:                        ; Lable in end of programm to solve size of code block
end Start