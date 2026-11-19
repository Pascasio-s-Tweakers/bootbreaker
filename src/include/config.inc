; =============================================================================
; config.inc - memory map and disk layout shared by every stage
; -----------------------------------------------------------------------------
; Owner: Yuan (Boot)        Reviewer: Eusef
;
; Constants only (equ / %define). No code and no data, so this file is safe to
; %include from Stage 1, Stage 2 and the test harnesses.
; Changing a value here changes the image layout: tell the whole team.
; =============================================================================
%ifndef CONFIG_INC
%define CONFIG_INC

; --- Memory map (real mode, segment 0x0000) ----------------------------------
;   0x0000 - 0x03FF   Interrupt vector table (do not touch)
;   0x0400 - 0x04FF   BIOS data area (read the tick counter from here)
;   0x0500 - 0x7BFF   Free; the stack lives at the top and grows down
;   0x7C00 - 0x7DFF   Stage 1 (boot sector, loaded by the BIOS)
;   0x7E00 - ...      Stage 2 (loaded by Stage 1), STAGE2_SECTORS long
;   0xA0000           VGA mode 13h framebuffer (segment 0xA000)
STACK_TOP           equ 0x7C00          ; SS:SP = 0000:7C00
STAGE1_ADDR         equ 0x7C00          ; where the BIOS puts the boot sector
STAGE2_ADDR         equ 0x7E00          ; where Stage 1 puts Stage 2

; --- Disk layout (1.44 MB floppy image, 18 sectors per track) ----------------
;   sector 1 (CHS 0/0/1)          Stage 1
;   sectors 2.. (CHS 0/0/2 ..)    Stage 2, padded to STAGE2_SECTORS
; A single INT 13h AH=02h read cannot cross a track, so keep
; STAGE2_SECTORS <= 17 unless load_stage2 is taught to read track by track.
STAGE2_SECTORS      equ 16              ; 16 * 512 = 8 KiB budget for Stage 2
STAGE2_START_SECTOR equ 2               ; CHS sector number (1-based)

; --- BIOS data area ----------------------------------------------------------
BDA_TICKS           equ 0x046C          ; dword, +1 every ~55 ms (18.2 Hz)

%endif
