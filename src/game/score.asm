; =============================================================================
; score.asm - score, lives and the HUD line
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
; State: [score], [lives] in game/state.asm. Drawn with lib/print.asm in
; text row 0 (above HUD_HEIGHT), e.g. "SCORE 00120      LIVES 3".
; =============================================================================

; -----------------------------------------------------------------------------
; score_reset - score = 0, lives = START_LIVES
; In:       none
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
score_reset:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; score_add - add points
; In:       AX = points
; Out:      [score] += AX
; Clobbers: none
; -----------------------------------------------------------------------------
score_add:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; score_lose_life - take one life away
; In:       none
; Out:      [lives] -= 1; CF = 1 if no lives are left (game over), else CF = 0
; Clobbers: none
; -----------------------------------------------------------------------------
score_lose_life:
    ; TODO(JP)
    clc
    ret

; -----------------------------------------------------------------------------
; score_draw - redraw the HUD (score and lives)
; In:       none
; Out:      none
; Clobbers: none
; Notes:    print_set_cursor to row 0, then print_str / print_u16.
; -----------------------------------------------------------------------------
score_draw:
    ; TODO(JP)
    ret
