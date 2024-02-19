Border_1:  db 0c9h, 0cdh, 0bbh, 0bah, 0b0h, 0bah, 0c8h, 0cdh, 0bch, '$'
Border_2:  db "/-\| |\-/", '$'
Border_3:  db "+-+| |+-+" 
Header_text db 10d,"Registers!", '$'

Privious_key db 0d

Page_buffer dw (Border_height + 2) * (Border_width + 2) dup(?)

Error_message db "Error!", '$'
Clean_monitor db 80*24 dup(' '), '$'
