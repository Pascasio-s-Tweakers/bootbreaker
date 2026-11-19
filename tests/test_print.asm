; =============================================================================
; test_print.asm - standalone check for lib/print.asm
; -----------------------------------------------------------------------------
; Owner: Marc    Reviewer: JP           Run: make test T=print
;
; Replaces Stage 2 in a throwaway image, so it needs a working Stage 1.
; Pass when the screen shows exactly the lines listed under "Expect".
; =============================================================================

%include "include/config.inc"
%include "include/stage2_env.inc"

[bits 16]
[org STAGE2_ADDR]

test_entry:
    STAGE2_ENV_SETUP
    ; TODO(Marc): call each routine below and compare with "Expect"
    ;   print_str        "print_str ok"
    ;   print_u16 0      "0"
    ;   print_u16 1234   "1234"
    ;   print_u16 65535  "65535"
    ;   print_set_cursor row 10, col 20, then print_char 'X'
    ; Expect: the three numbers on their own lines and an X mid-screen.
.hang:
    cli
    hlt
    jmp .hang

%include "lib/print.asm"

msg_ok      db "print_str ok", 0

%include "include/stage2_pad.inc"
