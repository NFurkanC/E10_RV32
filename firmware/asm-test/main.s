    li x10, 0       # i
    li x11, 3       # range
loop:
    addi x10, x10, 1
    blt x10, x11, loop
end:
    j end