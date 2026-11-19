; =============================================================================
; main.asm - Stage 2 entry point and build root
; -----------------------------------------------------------------------------
; Owner: Yuan (Boot)        Reviewer: Eusef
;
; This is the only file NASM assembles for Stage 2. Every other Stage 2 source
; is pulled in with %include below, so the whole stage is one flat binary that
; starts executing at its first byte (0000:STAGE2_ADDR).
;
; Rules for this file:
;   - stage2_entry must stay the FIRST thing that emits bytes.
;   - Add new modules to the include list, code first, then data.
;   - stage2_pad.inc stays the LAST include.
; =============================================================================

%include "include/config.inc"
%include "include/stage2_env.inc"
%include "include/video.inc"
%include "include/keys.inc"
%include "include/game.inc"

[bits 16]
[org STAGE2_ADDR]

; -----------------------------------------------------------------------------
; stage2_entry - Stage 1 jumps here
; In:       DL = boot drive, CS = 0
; Out:      does not return
; Notes:    Establishes the Stage 2 environment every module relies on:
;           DS = ES = SS = 0, SP = STACK_TOP, DF = 0, interrupts on.
; -----------------------------------------------------------------------------
stage2_entry:
    STAGE2_ENV_SETUP                    ; see include/stage2_env.inc
    ; TODO(Yuan): save DL into [boot_drive2]
    ; TODO(Yuan) week 1: SI = msg_hello, call print_str  (milestone: "Hello")
    ; TODO(JP)   week 3: call game_main instead of the hello message

.hang:
    cli
    hlt
    jmp .hang

; --- Libraries (week 2) ------------------------------------------------------
%include "lib/print.asm"
%include "lib/keyboard.asm"
%include "lib/timer.asm"
%include "lib/graphics.asm"

; --- Game (week 3) -----------------------------------------------------------
%include "game/game.asm"
%include "game/paddle.asm"
%include "game/ball.asm"
%include "game/bricks.asm"
%include "game/collision.asm"
%include "game/score.asm"

; --- Data --------------------------------------------------------------------
boot_drive2     db 0
msg_hello       db "Hello from Stage 2!", 13, 10, 0

%include "game/state.asm"

; --- Must be last ------------------------------------------------------------
%include "include/stage2_pad.inc"
