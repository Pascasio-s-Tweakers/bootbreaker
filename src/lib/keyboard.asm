; =============================================================================
; keyboard.asm - keyboard input through BIOS INT 16h
; -----------------------------------------------------------------------------
; Owner: Marc (Input & timing)   Reviewer: JP
;
; The game loop must never block on input, so it uses kbd_poll. kbd_wait is
; for title and game-over screens only. Scan codes live in include/keys.inc.
; =============================================================================

; -----------------------------------------------------------------------------
; kbd_poll - read a key if one is waiting, without blocking
; In:       none
; Out:      AX = key (AH = scan code, AL = ASCII), or AX = 0 if no key
; Clobbers: none (besides AX)
; Notes:    INT 16h AH=01h sets ZF when the buffer is empty; if a key is
;           there, consume it with AH=00h so it is not seen twice.
; -----------------------------------------------------------------------------
kbd_poll:
    ; TODO(Marc)
    xor ax, ax
    ret

; -----------------------------------------------------------------------------
; kbd_wait - block until a key is pressed (INT 16h AH=00h)
; In:       none
; Out:      AX = key (AH = scan code, AL = ASCII)
; Clobbers: none (besides AX)
; -----------------------------------------------------------------------------
kbd_wait:
    ; TODO(Marc)
    xor ax, ax
    ret

; -----------------------------------------------------------------------------
; kbd_flush - discard every key waiting in the BIOS buffer
; In:       none
; Out:      none
; Clobbers: none
; Notes:    Call before a "press any key" screen so old presses do not skip it.
; -----------------------------------------------------------------------------
kbd_flush:
    ; TODO(Marc)
    ret
