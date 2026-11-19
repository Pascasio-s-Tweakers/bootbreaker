; =============================================================================
; stage1.asm - boot sector (Stage 1)
; -----------------------------------------------------------------------------
; Owner: Yuan (Boot)        Reviewer: Eusef
;
; The BIOS loads this sector (512 bytes) to 0000:7C00 and jumps here with
; DL = boot drive number. Stage 1 must:
;   1. set up segments and a stack,
;   2. load STAGE2_SECTORS sectors from disk to 0000:STAGE2_ADDR (INT 13h),
;   3. jump to Stage 2 with DL still holding the boot drive.
;
; Hard limit: 510 bytes of code + data, then the 0xAA55 signature.
; `make check` fails if the sector is the wrong size or the signature is off.
; Stage 1 does NOT include lib/print.asm (too big); it has its own s1_print.
; =============================================================================

%include "include/config.inc"

[bits 16]
[org STAGE1_ADDR]

; -----------------------------------------------------------------------------
; stage1_entry - first instruction the BIOS runs
; In:       DL = boot drive (set by the BIOS)
; Out:      does not return; jumps to 0000:STAGE2_ADDR with DL = boot drive
; -----------------------------------------------------------------------------
stage1_entry:
    ; TODO(Yuan): far-jump to 0000:.start so CS = 0 (some BIOSes enter at 07C0:0000)
    ; TODO(Yuan): cli, zero DS/ES/SS, SP = STACK_TOP, sti, cld
    ; TODO(Yuan): save DL into [boot_drive]
    ; TODO(Yuan): SI = msg_loading, call s1_print
    ; TODO(Yuan): call load_stage2 (it jumps to disk_error on failure)
    ; TODO(Yuan): DL = [boot_drive], jmp 0x0000:STAGE2_ADDR
    jmp 0x0000:.start   ;far-jump to 0000:.start so CS = 0 (some BIOSes enter at 07C0:0000)
.start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, STACK_TOP
    sti
    cld

    mov [boot_drive], dl

    ; print "BootBreaker: loading..."
    mov si, msg_loading
    call s1_print

    call load_stage2  ; jumps to disk_error on failure

    mov dl, [boot_drive]
    jmp 0x0000:STAGE2_ADDR

.hang:
    cli
    hlt
    jmp .hang

; -----------------------------------------------------------------------------
; s1_print - print a zero-terminated string with BIOS teletype (INT 10h AH=0Eh)
; In:       DS:SI = string
; Out:      none
; Clobbers: AX, SI
; -----------------------------------------------------------------------------
s1_print:
    ; TODO(Yuan): lodsb loop, AH = 0Eh, BH = 0, int 10h, stop at 0
    ret

; -----------------------------------------------------------------------------
; load_stage2 - read Stage 2 into memory with INT 13h AH=02h (CHS)
; In:       [boot_drive] = drive to read from
; Out:      STAGE2_SECTORS sectors at 0000:STAGE2_ADDR; returns on success
;           jumps to disk_error after 3 failed attempts
; Clobbers: AX, BX, CX, DX, ES (ES = 0 on return)
; Notes:    AL = count, CH = cylinder 0, CL = STAGE2_START_SECTOR, DH = head 0,
;           DL = drive, ES:BX = buffer. CF = 1 on error: reset the drive
;           (AH = 00h) and retry. Real floppies often fail the first read.
; -----------------------------------------------------------------------------
load_stage2:
    ; TODO(Yuan): retry loop around int 13h AH=02h, reset with AH=00h between tries
    ret

; -----------------------------------------------------------------------------
; disk_error - print msg_disk_err and halt forever
; In:       none
; Out:      does not return
; -----------------------------------------------------------------------------
disk_error:
    ; TODO(Yuan): SI = msg_disk_err, call s1_print, then halt
    jmp stage1_entry.hang

; --- Data --------------------------------------------------------------------
boot_drive      db 0
msg_loading     db "BootBreaker: loading...", 13, 10, 0
msg_disk_err    db "Disk read error", 0

; --- Boot signature ----------------------------------------------------------
; If this line fails with "TIMES value is negative", Stage 1 is over 510 bytes.
    times 510 - ($ - $$) db 0
    dw 0xAA55
