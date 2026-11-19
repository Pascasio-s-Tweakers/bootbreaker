; =============================================================================
; test_input.asm - standalone check for lib/keyboard.asm and lib/timer.asm
; -----------------------------------------------------------------------------
; Owner: Marc    Reviewer: JP           Run: make test T=input
;
; Uses lib/print.asm to show results, so print must work first.
; =============================================================================

%include "include/config.inc"
%include "include/stage2_env.inc"
%include "include/keys.inc"

[bits 16]
[org STAGE2_ADDR]

test_entry:
    STAGE2_ENV_SETUP
    ; TODO(Marc):
    ;   1. Timer: print tmr_get_ticks, tmr_wait_ticks 18, print again.
    ;      Expect: the two numbers differ by 18 (about one second apart).
    ;   2. Keyboard: loop { kbd_poll; if AX != 0 print AH in decimal;
    ;      tmr_wait_tick; print a '.' }
    ;      Expect: dots keep coming while no key is pressed (poll does not
    ;      block); LEFT prints 75, RIGHT 77, ESC 1. ESC leaves the loop.
.hang:
    cli
    hlt
    jmp .hang

%include "lib/print.asm"
%include "lib/keyboard.asm"
%include "lib/timer.asm"

%include "include/stage2_pad.inc"
