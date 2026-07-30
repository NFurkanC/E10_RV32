TARGET = e10

CC = clang
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = llvm-objdump

ARCH_FLAGS = --target=riscv32 -march=rv32i -mabi=ilp32 -nostdlib
CFLAGS = -ffreestanding -O0
OBJFLAGS = --verilog-data-width=4 -O verilog 

ASM_DIR = asm-test
C_DIR = c-test

.PHONY: all asm c clean

all: asm c

asm:
	@echo "Assembling ASM test firmware"
	@mkdir -p $(ASM_DIR)/build
	$(CC) $(ARCH_FLAGS) -Wl,-T,$(ASM_DIR)/linker.ld $(ASM_DIR)/main.s -o $(ASM_DIR)/build/main.elf
	$(OBJCOPY) $(OBJFLAGS) $(ASM_DIR)/build/main.elf $(ASM_DIR)/build/firmware.mem
	$(OBJDUMP) -d $(ASM_DIR)/build/main.elf > $(ASM_DIR)/build/disassembly.txt
	@echo "Artifacts are generated in $(ASM_DIR)/build"

c:
	@echo "Compiling C test firmware"
	@mkdir -p $(C_DIR)/build
	$(CC) $(ARCH_FLAGS) $(CFLAGS) -Wl,-T,$(C_DIR)/linker.ld $(C_DIR)/boot.s $(C_DIR)/main.c -o $(C_DIR)/build/main.elf
	$(OBJCOPY) $(OBJFLAGS) $(C_DIR)/build/main.elf $(C_DIR)/build/firmware.mem
	$(OBJDUMP) -d $(C_DIR)/build/main.elf > $(C_DIR)/build/disassembly.txt
	@echo "Artifacts are generated in $(C_DIR)/build"

clean: 
	rm -rf $(ASM_DIR)/build
	rm -rf $(C_DIR)/build
	@echo "Clean complete."