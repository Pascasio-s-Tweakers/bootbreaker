; =============================================================================
; collision.asm - ball against walls, paddle, bricks and the floor
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
;
; Everything is axis-aligned rectangles (AABB): two rectangles overlap when
;   ax < bx + bw  and  bx < ax + aw  and  ay < by + bh  and  by < ay + ah
; Bounce = negate dx (side hit) or dy (top/bottom hit). Watch signed compares:
; use jl/jg for positions that can go negative, not jb/ja.
; =============================================================================

; -----------------------------------------------------------------------------
; collision_check - run every collision test for this frame
; In:       ball and paddle state after ball_update
; Out:      velocities flipped as needed, bricks broken, and on a floor hit
;           a life lost (GS_LOST when none left); GS_WON when bricks_left = 0
; Clobbers: none
; -----------------------------------------------------------------------------
collision_check:
    ; TODO(JP): col_walls, col_paddle, col_bricks, then win/lose checks
    ret

; -----------------------------------------------------------------------------
; col_ball_vs_rect - does the ball overlap a rectangle?
; In:       CX = x, DX = y, SI = width, DI = height
; Out:      CF = 1 if the ball overlaps, CF = 0 if not
; Clobbers: none
; -----------------------------------------------------------------------------
col_ball_vs_rect:
    ; TODO(JP)
    clc
    ret

; -----------------------------------------------------------------------------
; col_walls - bounce off the left, right and top walls (top = HUD_HEIGHT)
; In:       none
; Out:      CF = 1 if the ball went below the paddle (floor), else CF = 0
; Clobbers: none
; -----------------------------------------------------------------------------
col_walls:
    ; TODO(JP)
    clc
    ret

; -----------------------------------------------------------------------------
; col_paddle - bounce off the paddle (force dy negative)
; In:       none
; Out:      none
; Clobbers: none
; Notes:    Optional polish: change dx by where the ball hit the paddle.
; -----------------------------------------------------------------------------
col_paddle:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; col_bricks - break at most one brick the ball touches and bounce
; In:       none
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
col_bricks:
    ; TODO(JP): loop live bricks, bricks_rect + col_ball_vs_rect, bricks_break
    ret
