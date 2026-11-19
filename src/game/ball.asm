; =============================================================================
; ball.asm - ball position and movement
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
; State: [ball_x], [ball_y], [ball_dx], [ball_dy] in game/state.asm.
; Bouncing is decided in collision.asm; this file only moves and draws.
; =============================================================================

; -----------------------------------------------------------------------------
; ball_reset - place the ball just above the paddle centre, moving up
; In:       [paddle_x]
; Out:      ball position and velocity set (BALL_START_DX, BALL_START_DY)
; Clobbers: none
; Notes:    Optional: pick the sign of dx from the low bit of tmr_get_ticks.
; -----------------------------------------------------------------------------
ball_reset:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; ball_update - add velocity to position
; In:       none
; Out:      [ball_x] += [ball_dx], [ball_y] += [ball_dy]
; Clobbers: none
; -----------------------------------------------------------------------------
ball_update:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; ball_draw - draw the ball (BALL_SIZE square, BALL_COLOR)
; ball_erase - same square in BG_COLOR
; In:       none
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
ball_draw:
    ; TODO(JP): gfx_fill_rect
    ret

ball_erase:
    ; TODO(JP): gfx_fill_rect with BG_COLOR
    ret
