# =============================================================================
# BootBreaker build
#   make              build build/bootbreaker.img
#   make run          boot it in QEMU
#   make debug        boot in QEMU paused, waiting for GDB on :1234
#   make bochs        boot it in Bochs (uses bochsrc.txt)
#   make check        verify Stage 1 is 512 bytes and ends in 55 AA
#   make test T=name  build and boot tests/test_name.asm in place of Stage 2
#   make clean        delete build/
# Needs: nasm, GNU make, dd, od (Git Bash, MSYS2, WSL, Linux and macOS have them)
# =============================================================================

NASM      ?= nasm
QEMU      ?= qemu-system-i386
BOCHS     ?= bochs
NASMFLAGS := -f bin -i src/ -w+all

BUILD     := build
IMG       := $(BUILD)/bootbreaker.img
STAGE1    := $(BUILD)/stage1.bin
STAGE2    := $(BUILD)/stage2.bin

INCLUDES  := $(wildcard src/include/*.inc)
STAGE2_SRC:= $(wildcard src/stage2/*.asm src/lib/*.asm src/game/*.asm) $(INCLUDES)

QEMU_DRIVE = -drive file=$(1),format=raw,if=floppy -boot a

# $(call make_img,out.img,stage1.bin,stage2.bin)
# 1.44 MB floppy: sector 1 = Stage 1, sectors 2.. = Stage 2
define make_img
	dd if=/dev/zero of=$(1) bs=512 count=2880 2>/dev/null
	dd if=$(2) of=$(1) bs=512 conv=notrunc 2>/dev/null
	dd if=$(3) of=$(1) bs=512 seek=1 conv=notrunc 2>/dev/null
endef

.PHONY: all run debug bochs check test clean

all: $(IMG)

$(BUILD):
	mkdir -p $@

$(STAGE1): src/boot/stage1.asm src/include/config.inc | $(BUILD)
	$(NASM) $(NASMFLAGS) $< -o $@

$(STAGE2): $(STAGE2_SRC) | $(BUILD)
	$(NASM) $(NASMFLAGS) src/stage2/main.asm -o $@

$(IMG): $(STAGE1) $(STAGE2)
	$(call make_img,$@,$(STAGE1),$(STAGE2))

run: $(IMG)
	$(QEMU) $(call QEMU_DRIVE,$(IMG))

# In another terminal: gdb -ex "target remote :1234" -ex "set architecture i8086"
#                          -ex "break *0x7c00" -ex "continue"
debug: $(IMG)
	$(QEMU) $(call QEMU_DRIVE,$(IMG)) -s -S

bochs: $(IMG)
	$(BOCHS) -q -f bochsrc.txt

check: $(STAGE1)
	@size=$$(wc -c < $(STAGE1) | tr -d ' '); \
	sig=$$(od -An -tx1 -j510 -N2 $(STAGE1) | tr -d ' \n'); \
	echo "stage1: $$size bytes, signature $$sig"; \
	test "$$size" = 512 && test "$$sig" = 55aa

# --- Standalone module tests (tests/test_*.asm) ------------------------------
$(BUILD)/test_%.bin: tests/test_%.asm $(STAGE2_SRC) | $(BUILD)
	$(NASM) $(NASMFLAGS) $< -o $@

$(BUILD)/test_%.img: $(STAGE1) $(BUILD)/test_%.bin
	$(call make_img,$@,$(STAGE1),$(BUILD)/test_$*.bin)

test:
ifndef T
	$(error usage: make test T=print|input|graphics)
endif
	$(MAKE) $(BUILD)/test_$(T).img
	$(QEMU) $(call QEMU_DRIVE,$(BUILD)/test_$(T).img)

clean:
	rm -rf $(BUILD)
