; =============================================================================
; game.asm - top-level game flow: title, main loop, win/lose screens
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
;
; Flow:
;   game_main
;     gfx_init
;     loop:
;       game_title_screen        (wait for ENTER, ESC quits)
;       game_reset               (score, lives, bricks, paddle, ball)
;       repeat game_frame until [game_state] != GS_PLAYING
;       game_end_screen          (win or lose message, wait for a key)
;
; One frame (game_frame), in this order so nothing flickers or skips:
;   1. tmr_wait_tick (or gfx_wait_vsync)  pace the loop
;   2. kbd_poll -> paddle_update          ESC sets GS_QUIT
;   3. erase paddle and ball at old spots
;   4. ball_update                        move by (dx, dy)
;   5. collision_check                    walls, paddle, bricks, floor
;   6. draw paddle, ball, HUD
; =============================================================================

; -----------------------------------------------------------------------------
; game_main - run the game forever
; In:       none (Stage 2 environment set up by stage2_entry)
; Out:      does not return (halts after GS_QUIT)
; -----------------------------------------------------------------------------
game_main:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; game_title_screen - draw the title and wait for the player
; In:       none
; Out:      [game_state] = GS_PLAYING (ENTER) or GS_QUIT (ESC)
; Clobbers: none
; -----------------------------------------------------------------------------
game_title_screen:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; game_reset - start a new game
; In:       none
; Out:      score = 0, lives = START_LIVES, bricks rebuilt, paddle and ball
;           reset, screen redrawn, [game_state] = GS_PLAYING
; Clobbers: none
; -----------------------------------------------------------------------------
game_reset:
    ; TODO(JP): score_reset, bricks_init, paddle_reset, ball_reset, draw all
    ret

; -----------------------------------------------------------------------------
; game_frame - advance the game by one frame (see the order above)
; In:       none
; Out:      [game_state] may change to GS_WON, GS_LOST or GS_QUIT
; Clobbers: none
; -----------------------------------------------------------------------------
game_frame:
    ; TODO(JP)
    ret

; -----------------------------------------------------------------------------
; game_end_screen - show "YOU WIN" or "GAME OVER" with the final score
; In:       [game_state] = GS_WON or GS_LOST
; Out:      waits for a key; ESC sets GS_QUIT, anything else GS_TITLE
; Clobbers: none
; -----------------------------------------------------------------------------
game_end_screen:
    ; TODO(JP)
    ret
