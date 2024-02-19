; Copy VRAM segment into the buffer
Save_page       proc
    push cx di si dx es ds              ; save registers

    push cs         
    pop es
    push 0b800h
    pop ds

    mov di, offset Page_buffer
    mov si, (1*80 + 65)*2

    mov dl, Border_height + 2d
    @@next:
        dec dl
        mov cx, Border_width + 2d
        rep movsw
        call Shift_to_next_line_si

    cmp dl, 0
    jne @@next

    pop ds es dx si di cx              ; repair registers
    ret
                endp

; Shift to next line di
Shift_to_next_line_di proc
    push ax                 ; save ax

    mov ax, di
    sub ax, (Border_width + 2) * 2
    add ax, 160d
    mov di, ax

    pop ax                  ; repair ax
    ret
                endp
    
; Shift to next line si 
Shift_to_next_line_si proc
push ax                 ; save ax

mov ax, si
sub ax, (Border_width + 2) * 2
add ax, 160d
mov si, ax

pop ax                  ; repair ax
ret
                endp

; Repair segment of page
Repair_page     proc
    push cx di si dx es ds              ; save registers

    push cs         
    pop ds
    push 0b800h
    pop es

    mov si, offset Page_buffer
    mov di, (1*80 + 65)*2

    mov dl, Border_height + 2d
    @@next:
        dec dl
        mov cx, Border_width + 2d
        rep movsw
        call Shift_to_next_line_di

    cmp dl, 0
    jne @@next

    pop ds es dx si di cx              ; repair registers
    ret
                endp