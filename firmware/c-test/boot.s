# boot.S
.section .boot, "ax"
.global _start

_start:
    li sp, 0x20004000
    
    jal main

end_loop:
    j end_loop