; =============================================================================
; game.inc - game layout and tuning constants
; -----------------------------------------------------------------------------
; Owner: JP (Game logic)    Reviewer: Eusef
; Constants only. Tweak freely while play-testing; these are starting values.
; All positions are in pixels, origin (0,0) at the top-left of the screen.
; =============================================================================
%ifndef GAME_INC
%define GAME_INC

%include "include/video.inc"

; --- HUD (score and lives, drawn with BIOS text in row 0) --------------------
HUD_HEIGHT          equ 10              ; playfield starts below this line

; --- Paddle ------------------------------------------------------------------
PADDLE_W            equ 40
PADDLE_H            equ 4
PADDLE_Y            equ 185             ; top edge, fixed
PADDLE_SPEED        equ 6               ; pixels per key press / frame
PADDLE_COLOR        equ COLOR_WHITE

; --- Ball --------------------------------------------------------------------
BALL_SIZE           equ 4               ; square ball, BALL_SIZE x BALL_SIZE
BALL_START_DX       equ 2               ; signed pixels per frame
BALL_START_DY       equ -2
BALL_COLOR          equ COLOR_YELLOW

; --- Bricks ------------------------------------------------------------------
BRICK_ROWS          equ 5
BRICK_COLS          equ 10
BRICK_COUNT         equ BRICK_ROWS * BRICK_COLS
BRICK_W             equ 30
BRICK_H             equ 8
BRICK_GAP           equ 2
BRICK_TOP           equ 20              ; y of the first row
BRICK_LEFT          equ (SCREEN_W - (BRICK_COLS * (BRICK_W + BRICK_GAP) - BRICK_GAP)) / 2

; --- Rules -------------------------------------------------------------------
START_LIVES         equ 3
POINTS_PER_BRICK    equ 10
BG_COLOR            equ COLOR_BLACK

; --- Game states (value of [game_state]) -------------------------------------
GS_TITLE            equ 0
GS_PLAYING          equ 1
GS_WON              equ 2
GS_LOST             equ 3
GS_QUIT             equ 4

%endif
