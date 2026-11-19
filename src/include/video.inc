; =============================================================================
; video.inc - VGA mode 13h constants
; -----------------------------------------------------------------------------
; Owner: Eusef (Graphics)   Reviewer: Marc
; Constants only. Used by lib/graphics.asm and by the game modules.
; =============================================================================
%ifndef VIDEO_INC
%define VIDEO_INC

VGA_SEGMENT         equ 0xA000          ; framebuffer segment for mode 13h
SCREEN_W            equ 320             ; pixels per row (also bytes per row)
SCREEN_H            equ 200             ; rows

VIDEO_MODE_GFX      equ 0x13            ; 320x200, 256 colours, 1 byte/pixel
VIDEO_MODE_TEXT     equ 0x03            ; 80x25 colour text

VGA_STATUS_PORT     equ 0x3DA           ; bit 3 set = vertical retrace

; --- Default VGA palette indices (first 16 match the CGA/EGA colours) --------
COLOR_BLACK         equ 0
COLOR_BLUE          equ 1
COLOR_GREEN         equ 2
COLOR_CYAN          equ 3
COLOR_RED           equ 4
COLOR_MAGENTA       equ 5
COLOR_BROWN         equ 6
COLOR_LIGHT_GRAY    equ 7
COLOR_DARK_GRAY     equ 8
COLOR_LIGHT_BLUE    equ 9
COLOR_LIGHT_GREEN   equ 10
COLOR_LIGHT_CYAN    equ 11
COLOR_LIGHT_RED     equ 12
COLOR_LIGHT_MAGENTA equ 13
COLOR_YELLOW        equ 14
COLOR_WHITE         equ 15

%endif
