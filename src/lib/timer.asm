; =============================================================================
; timer.asm - frame timing from the BIOS tick counter
; -----------------------------------------------------------------------------
; Owner: Marc (Input & timing)   Reviewer: JP
;
; The BIOS increments the dword at 0000:BDA_TICKS about 18.2 times a second
; (IRQ0 / INT 08h). Reading the low word is enough for frame pacing; it wraps
; every hour, so compare with "not equal", never "greater than".
; =============================================================================

; -----------------------------------------------------------------------------
; tmr_get_ticks - read the low word of the BIOS tick counter
; In:       none
; Out:      AX = ticks
; Clobbers: none (besides AX)
; Notes:    Read with DS = 0 (or a segment override) from BDA_TICKS.
; -----------------------------------------------------------------------------
tmr_get_ticks:
    ; Read the low word of the BIOS tick counter at 0040:006C.
    push ds
    xor ax, ax
    mov ds, ax
    mov ax, [BDA_TICKS]
    pop ds
    ret

; -----------------------------------------------------------------------------
; tmr_wait_tick - wait until the tick counter changes (one frame, ~55 ms)
; In:       none
; Out:      none
; Clobbers: none
; Notes:    Use hlt inside the wait loop so the emulator does not spin a core.
; -----------------------------------------------------------------------------
tmr_wait_tick:
    ; Halt until the BIOS tick counter changes, then return.
    push ax
    push bx
    call tmr_get_ticks
    mov bx, ax
.wait:
    hlt
    call tmr_get_ticks
    cmp ax, bx
    je .wait
    pop bx
    pop ax
    ret

; -----------------------------------------------------------------------------
; tmr_wait_ticks - wait for a number of ticks
; In:       CX = ticks to wait (18 ~ 1 second)
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
tmr_wait_ticks:
    ; Wait for each requested BIOS tick, while supporting CX = 0.
    push cx
    jcxz .done
.wait:
    call tmr_wait_tick
    loop .wait
.done:
    pop cx
    ret
