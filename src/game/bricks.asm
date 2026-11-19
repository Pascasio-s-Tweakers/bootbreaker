; =============================================================================
; bricks.asm - the brick wall
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
; State: brick_map and [bricks_left] in game/state.asm.
; Brick i is at row = i / BRICK_COLS, col = i % BRICK_COLS:
;   x = BRICK_LEFT + col * (BRICK_W + BRICK_GAP)
;   y = BRICK_TOP  + row * (BRICK_H + BRICK_GAP)
; =============================================================================

; -----------------------------------------------------------------------------
; bricks_init - fill brick_map with one colour per row, set bricks_left
; In:       none
; Out:      every brick alive, [bricks_left] = BRICK_COUNT
; Clobbers: none
; -----------------------------------------------------------------------------
bricks_init:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; bricks_rect - screen rectangle of one brick
; In:       BX = brick index (0..BRICK_COUNT-1)
; Out:      CX = x, DX = y, SI = BRICK_W, DI = BRICK_H
; Clobbers: none (besides the outputs)
; -----------------------------------------------------------------------------
bricks_rect:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; bricks_draw_all - draw every live brick
; In:       none
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
bricks_draw_all:
    ; TODO(JP): for each index, if brick_map[i] != 0, bricks_rect + gfx_fill_rect
    ret

; -----------------------------------------------------------------------------
; bricks_break - destroy one brick
; In:       BX = brick index (must be alive)
; Out:      brick_map[BX] = 0, brick erased, [bricks_left] -= 1,
;           score += POINTS_PER_BRICK
; Clobbers: none
; -----------------------------------------------------------------------------
bricks_break:
    ; TODO(JP)
    ret
