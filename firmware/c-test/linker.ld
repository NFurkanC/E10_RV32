OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
    rom (rx)  : ORIGIN = 0x00000000, LENGTH = 16K
    ram (rwx) : ORIGIN = 0x20000000, LENGTH = 16K
}

SECTIONS {
    .text : {
        *(.boot)   
        *(.text)   
    } > rom

    .data : {
        *(.data)
        *(.rodata)
    } > ram AT > rom

    .bss : {
        *(.bss)
    } > ram
}