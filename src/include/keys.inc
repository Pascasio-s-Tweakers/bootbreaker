; =============================================================================
; keys.inc - keyboard scan codes (the AH value returned by INT 16h)
; -----------------------------------------------------------------------------
; Owner: Marc (Input & timing)   Reviewer: JP
; Compare against AH, not AL: arrow keys have no ASCII code (AL = 0 or 0xE0).
; =============================================================================
%ifndef KEYS_INC
%define KEYS_INC

KEY_NONE            equ 0x00            ; kbd_poll returns AX = 0 when idle
KEY_ESC             equ 0x01
KEY_ENTER           equ 0x1C
KEY_SPACE           equ 0x39
KEY_LEFT            equ 0x4B
KEY_RIGHT           equ 0x4D
KEY_A               equ 0x1E
KEY_D               equ 0x20
KEY_P               equ 0x19            ; pause (optional)
KEY_R               equ 0x13            ; restart

%endif
