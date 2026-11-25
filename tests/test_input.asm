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
    mov bl, 0Fh

    ; Measure elapsed BIOS ticks while waiting for about one second.
    mov si, msg_timer
    call print_str
    call print_newline
    call tmr_get_ticks
    mov [ticks_before], ax
    mov cx, 18
    call tmr_wait_ticks
    call tmr_get_ticks
    sub ax, [ticks_before]
    mov si, msg_elapsed
    call print_str
    call print_u16
    mov si, msg_ticks
    call print_str
    call print_newline

    ; Discard stale input, wait for a start key, then poll without blocking.
    call kbd_flush
    mov si, msg_start
    call print_str
    call print_newline
    call kbd_wait

    mov si, msg_polling
    call print_str
    call print_newline
    mov si, msg_keys
    call print_str
    call print_newline
.poll:
    call kbd_poll
    test ax, ax
    jnz .key
    ; Show that polling continues while the keyboard buffer is empty.
    mov al, '.'
    call print_char
    hlt
    jmp .poll
.key:
    call print_newline
    mov dx, ax
    mov si, msg_scan
    call print_str
    mov al, dh
    xor ah, ah
    call print_u16
    call print_newline
    ; Continue polling until ESC is received.
    cmp dh, KEY_ESC
    jne .poll

    mov si, msg_done
    call print_str
.hang:
    cli
    hlt
    jmp .hang

%include "lib/print.asm"
%include "lib/keyboard.asm"
%include "lib/timer.asm"

msg_start   db "Press any key to start polling.", 0
msg_polling db "Polling without blocking; idle dots are printed.", 0
msg_keys    db "Press LEFT, RIGHT, or ESC to finish.", 0
msg_scan    db "Key scan: ", 0
msg_done    db "ESC received; test complete.", 0
msg_timer   db "Waiting 18 BIOS ticks (~1 second)...", 0
msg_elapsed db "Elapsed BIOS ticks: ", 0
msg_ticks   db " (about 18)", 0
ticks_before dw 0

%include "include/stage2_pad.inc"
