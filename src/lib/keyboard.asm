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
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push ds
    push es
    mov ah, 01h
    int 16h
    jz .empty
    mov ah, 00h
    int 16h
    pop es
    pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret
.empty:
    xor ax, ax
    pop es
    pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret

; -----------------------------------------------------------------------------
; kbd_wait - block until a key is pressed (INT 16h AH=00h)
; In:       none
; Out:      AX = key (AH = scan code, AL = ASCII)
; Clobbers: none (besides AX)
; -----------------------------------------------------------------------------
kbd_wait:
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push ds
    push es
    xor ah, ah
    int 16h
    pop es
    pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret

; -----------------------------------------------------------------------------
; kbd_flush - discard every key waiting in the BIOS buffer
; In:       none
; Out:      none
; Clobbers: none
; Notes:    Call before a "press any key" screen so old presses do not skip it.
; -----------------------------------------------------------------------------
kbd_flush:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push ds
    push es
.loop:
    mov ah, 01h
    int 16h
    jz .done
    mov ah, 00h
    int 16h
    jmp .loop
.done:
    pop es
    pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
