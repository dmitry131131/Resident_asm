; Write 3 special symbols
; Entry             AH - background color atribute
;                   DI - special line position
;                   CX - count of central symbols
;                   BX - offset of memory
; Assumes           ES = 0b800h
; Destr             AL, DI, CX
Write_line          proc
    mov al, byte ptr cs:[di]               ; write first symbol
    mov es:[bx], ax
    add bx, 2d
    inc di

    mov al, byte ptr cs:[di]               ; Write second N symbols of line
    @@next:
        mov es:[bx], ax
        add bx, 2d
    loop @@next
    inc di

    mov al, byte ptr cs:[di]               ; write first symbol
    mov es:[bx], ax
    add bx, 2d
    inc di

    ret
                    endp

; Write header on border
Write_text_header   proc
    push di cx ax
    mov di, offset Header_text
    mov cx, [di]
    inc di

    @@next:
        mov al, [di]
        mov es:[bx], al
        inc di
    loop @@next
    add bx, 2d

    pop ax cx di
    ret
                    endp

; Shift to the next line function
; Entry             BX - memory adress
; Destr             BX
; Return            BX position of the next line
Shift_to_next_line  proc
    sub bx, Border_width
    sub bx, Border_width
    sub bx, 4d
    add bx, 160d
    ret
                    endp

; Write border in the midle on the monitor
; Assumes           ES = 0b800h
; Destr             AX, BX, CX, DI
DisplayBorder       proc
    push ax bx cx di dx                    ; save registers

    mov di, offset Border_1             ; set default border settings
    mov ah, White_back_black_front
    mov bx, (1*80 + 65)*2

    mov cx, Border_width
    call Write_line

    mov dx, Border_height
    @@next:
        dec dx

        mov cx, Border_width
        call Shift_to_next_line
        call Write_line

        sub di, 3d
    cmp dx, 0
    jne @@next

    add di, 3d
    mov cx, Border_width
    call Shift_to_next_line
    call Write_line

    pop dx di cx bx ax                     ; repair registers
    ret
                    endp
