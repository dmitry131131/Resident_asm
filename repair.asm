; Copy VRAM segment into the buffer
Save_page               proc

                        push cx di si dx es ds              ; save registers

                        push cs                             ; set es to current segment 
                        pop es
                        push 0b800h                         ; set ds to monitor segment
                        pop ds

                        mov di, offset Page_buffer          ; set di to Page buffer position
                        mov si, (1*80 + 65)*2               ; set si to left top corner of border

                        mov dl, Border_height + 2d          ; set cout of lines
@@next:                                                     ; save display rectangle to the page buffer
                        dec dl
                        mov cx, Border_width + 2d
                        rep movsw
                        call Shift_to_next_line_si

                        cmp dl, 0
                        jne @@next

                        pop ds es dx si di cx               ; repair registers
                    
                        ret

                        endp

; Shift to next line di
Shift_to_next_line_di   proc

                        push ax                             ; save ax

                        mov ax, di
                        sub ax, (Border_width + 2) * 2
                        add ax, 160d
                        mov di, ax

                        pop ax                              ; repair ax
                        
                        ret

                        endp
    
; Shift to next line si 
Shift_to_next_line_si   proc

                        push ax                 ; save ax

                        mov ax, si
                        sub ax, (Border_width + 2) * 2
                        add ax, 160d
                        mov si, ax

                        pop ax                  ; repair ax
                        
                        ret

                        endp

; Repair segment of page
Repair_page             proc

                        push cx di si dx es ds              ; save registers

                        push cs                             ; set ds to current segment 
                        pop ds
                        push 0b800h                         ; set es to monitor segment
                        pop es

                        mov si, offset Page_buffer          ; set si to Page buffer position
                        mov di, (1*80 + 65)*2               ; set di to left top corner of border

                        mov dl, Border_height + 2d          ; set cout of lines
@@next:                                                     ; repair all border rectangle from page buffer
                        dec dl
                        mov cx, Border_width + 2d
                        rep movsw
                        call Shift_to_next_line_di

                        cmp dl, 0
                        jne @@next

                        pop ds es dx si di cx              ; repair registers
                        
                        ret

                        endp