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
    ; TODO(Marc)
    xor ax, ax
    ret

; -----------------------------------------------------------------------------
; tmr_wait_tick - wait until the tick counter changes (one frame, ~55 ms)
; In:       none
; Out:      none
; Clobbers: none
; Notes:    Use hlt inside the wait loop so the emulator does not spin a core.
; -----------------------------------------------------------------------------
tmr_wait_tick:
    ; TODO(Marc)
    ret

; -----------------------------------------------------------------------------
; tmr_wait_ticks - wait for a number of ticks
; In:       CX = ticks to wait (18 ~ 1 second)
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
tmr_wait_ticks:
    ; TODO(Marc): call tmr_wait_tick CX times
    ret
