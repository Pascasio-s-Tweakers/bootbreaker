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
    ; Print a status line and verify decimal output for zero, 1234, and 65535.
    mov bl, 0Fh
    mov si, msg_ok
    call print_str
    call print_newline

    xor ax, ax
    call print_u16
    call print_newline

    mov ax, 1234
    call print_u16
    call print_newline

    mov ax, 65535
    call print_u16

    ; Move the cursor to row 10, column 20, and print a marker there.
    mov dh, 10
    mov dl, 20
    call print_set_cursor
    mov al, 'X'
    call print_char
.hang:
    cli
    hlt
    jmp .hang

%include "lib/print.asm"

msg_ok      db "print_str ok", 0

%include "include/stage2_pad.inc"
