; Function converts number to HEX
; Entry             AL - Number (0-15)
; Return            AL - Number ('0'-'F')
; Destroy           AL
number_to_hex_digit       proc
    add al,'0'              ;(0x30)
    cmp al,'9'              ;(код 0x39)
    jle @@end             
    add al,7                ;'A'-'F' Add 7 for 'A' - 'F' symbols
    @@end:

    ret
                    endp

; Function convert byte to HEX number text
; Entry             AL - byte
; Return            DI - buffer for string (2 symbols)
; Destroy           DI
byte_to_hex_str    proc
    push ax                 ; save ax

    mov ah, al               ;save al in ah
    shr al, 4                ; get hi digit
    call number_to_hex_digit      
    mov cs:[di], al             ;add to string
    inc di                 

    mov al,ah               ;repair al
    and al, 0Fh              ;get low digit
    call number_to_hex_digit       
    mov cs:[di], al             ;add to string
    inc di                 

    pop ax                  ; repair ax
    ret
                    endp

; Function convert word into HEX string
; Entry             AX - word
; Return            DI - buffer for string (4 symbols)
; Destroy           DI
word_to_hex_str    proc
    xchg ah,al              ;exchange ah and al
    call byte_to_hex_str    
    xchg ah,al              ;exchange ah and al
    call byte_to_hex_str    
    ret
                    endp

; Function save all register values into register buffer
Save_registers      proc

    call Save_CS_IP                              ; save cs and ip

    push ax cx di                                ; save ax and di registers
    push ss es ds bp sp di si dx cx bx ax        ; push all registers to stack

    mov di, offset Register_buffer
    mov cx, 11d
    @@next:
        pop ax
        add di, 2d
        call word_to_hex_str
    loop @@next

    pop di cx ax                                 ; repair ax, cx and di registers
    ret
                    endp

; Save cs and ip registers
Save_CS_IP          proc
    push di bp ax
    ;------------------------------------------------------------------
    mov bp, sp                          ; get real cs position in stack         //BUG могут быть проблемы с cs и ip 
    add bp, 14d

    mov ax, word ptr [bp]               ; save cs value in ax register

    mov di, offset Register_buffer      ; set di on cs position in buffer
    add di, CS_adress

    call word_to_hex_str                ; save cs in buffer

    add di, 2d                          ; go to ip position in buffer
    sub bp, 2d                          ; get real ip position in stack

    mov ax, word ptr [bp]               ; save ip value in ax register

    call word_to_hex_str                ; save ip in in buffer

    pop ax bp di
    ;------------------------------------------------------------------
    ret
                    endp

; Function that outs register value
; Entry                 SI - position of 6 symbols
;                       BX - pisition on monitor
;
; Destroy               SI -> SI + 6
Write_register_value    proc
    push cx

    mov cx, 6d
    @@next:
        mov al, cs:[si]
        mov es:[bx], al
        inc si
        add bx, 2d
    loop @@next

    pop cx
    ret
                        endp

                    