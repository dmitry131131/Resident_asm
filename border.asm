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

; Shift to the next line function
; Entry             BX - memory adress
; Destr             BX
; Return            BX position of the next line
Shift_to_next_line  proc
    sub bx, (Border_width + 2) * 2d ; go to start of line
    add bx, 160d                    ; go to next line
    ret
                    endp

; Write border in the midle on the monitor
; Assumes           ES = 0b800h
DisplayBorder       proc
    push ax bx cx di dx si              ; save registers
    
    mov di, offset Border_1             ; set default border settings
    mov ah, White_back_black_front
    ;------------------------------------------
    ; Write first line
    mov bx, (1*80 + 65)*2
    mov cx, Border_width                ; write first line to the monitor
    call Write_line
    ;------------------------------------------

    mov si, offset Register_buffer      ; set SI on the start of the register buffer
    mov dx, Border_height
    @@next:
        dec dx

        mov cx, Border_width
        call Shift_to_next_line
        call Write_line                 ; write line
        
        sub bx, 20d
        call Write_register_value       ; write register string
        add bx, 8d 

        sub di, 3d
    cmp dx, 0
    jne @@next

    add di, 3d
    mov cx, Border_width
    call Shift_to_next_line                   ; write last line
    call Write_line

    pop si dx di cx bx ax                     ; repair registers
    ret
                    endp
