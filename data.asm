Border_1:  db 0c9h, 0cdh, 0bbh, 0bah, 0b0h, 0bah, 0c8h, 0cdh, 0bch, '$' ; First border style

Register_buffer db "ax0000bx0000cx0000dx0000si0000di0000sp0000bp0000ds0000es0000ss0000cs0000ip0000", '$'  ; Buffer for registers

Privious_key db 0d                                                      ; The privious key scan-code

Page_buffer dw (Border_height + 2) * (Border_width + 2) dup(?)          ; Buffer for border background
