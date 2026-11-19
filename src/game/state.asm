; =============================================================================
; state.asm - all mutable game state, in one place
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
;
; Data only, included after the code in main.asm. Every game module reads and
; writes these variables directly (DS = 0, so [paddle_x] just works).
; Positions are pixel coordinates of the top-left corner; velocities are
; signed pixels per frame. Add new fields here, not inside other modules.
; =============================================================================

game_state      db GS_TITLE             ; one of GS_* in include/game.inc
lives           db 0
score           dw 0
bricks_left     dw 0                    ; reaches 0 -> GS_WON

paddle_x        dw 0                    ; y is fixed at PADDLE_Y

ball_x          dw 0
ball_y          dw 0
ball_dx         dw 0                    ; signed
ball_dy         dw 0                    ; signed, negative = up

; One byte per brick, row-major: index = row * BRICK_COLS + col.
; 0 = broken, otherwise the colour to draw it with.
brick_map       times BRICK_COUNT db 0
