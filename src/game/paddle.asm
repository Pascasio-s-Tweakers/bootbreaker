; =============================================================================
; paddle.asm - the player's paddle
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
; State: [paddle_x] in game/state.asm. Size and speed in include/game.inc.
; =============================================================================

; -----------------------------------------------------------------------------
; paddle_reset - centre the paddle
; In:       none
; Out:      [paddle_x] = (SCREEN_W - PADDLE_W) / 2
; Clobbers: none
; -----------------------------------------------------------------------------
paddle_reset:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; paddle_update - move the paddle for one key press
; In:       AX = key from kbd_poll (0 = no key)
; Out:      [paddle_x] moved by PADDLE_SPEED, clamped to 0..SCREEN_W-PADDLE_W
; Clobbers: none
; Notes:    Accept KEY_LEFT/KEY_A and KEY_RIGHT/KEY_D. Compare AH (scan code).
; -----------------------------------------------------------------------------
paddle_update:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; paddle_draw - draw the paddle at [paddle_x], PADDLE_Y in PADDLE_COLOR
; paddle_erase - same rectangle in BG_COLOR
; In:       none
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
paddle_draw:
    ; TODO(JP): gfx_fill_rect
    ret

paddle_erase:
    ; TODO(JP): gfx_fill_rect with BG_COLOR
    ret
