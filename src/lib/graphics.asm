; =============================================================================
; graphics.asm - VGA mode 13h drawing (direct writes to A000:0000)
; -----------------------------------------------------------------------------
; Owner: Eusef (Graphics)   Reviewer: Marc
;
; Mode 13h: 320x200, one byte per pixel, pixel (x, y) is at offset y*320 + x
; in segment VGA_SEGMENT. Routines that point ES at the framebuffer must put
; ES back to 0 before returning (see the calling convention in the guide).
; Constants live in include/video.inc.
; =============================================================================

; -----------------------------------------------------------------------------
; gfx_init - switch to mode 13h (INT 10h AX=0013h)
; In:       none
; Out:      screen cleared to colour 0
; Clobbers: none
; -----------------------------------------------------------------------------
gfx_init:
    ; TODO(Eusef)
    ret

; -----------------------------------------------------------------------------
; gfx_text_mode - go back to 80x25 text mode (INT 10h AX=0003h)
; In:       none
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
gfx_text_mode:
    ; TODO(Eusef)
    ret

; -----------------------------------------------------------------------------
; gfx_clear - fill the whole screen with one colour
; In:       AL = colour
; Out:      none
; Clobbers: none
; Notes:    rep stosw over 32000 words is the fast way.
; -----------------------------------------------------------------------------
gfx_clear:
    ; TODO(Eusef)
    ret

; -----------------------------------------------------------------------------
; gfx_put_pixel - plot one pixel
; In:       CX = x (0..319), DX = y (0..199), AL = colour
; Out:      none
; Clobbers: none
; Notes:    No bounds check; callers keep coordinates on screen.
;           y*320 = (y << 8) + (y << 6) avoids a slow MUL.
; -----------------------------------------------------------------------------
gfx_put_pixel:
    ; TODO(Eusef)
    ret

; -----------------------------------------------------------------------------
; gfx_fill_rect - draw a filled rectangle
; In:       CX = x, DX = y, SI = width, DI = height, AL = colour
; Out:      none
; Clobbers: none
; Notes:    One rep stosb per row is much faster than gfx_put_pixel per pixel.
; -----------------------------------------------------------------------------
gfx_fill_rect:
    ; TODO(Eusef)
    ret

; -----------------------------------------------------------------------------
; gfx_wait_vsync - wait for the start of the next vertical retrace (~70 Hz)
; In:       none
; Out:      none
; Clobbers: none
; Notes:    Poll VGA_STATUS_PORT bit 3: wait while set, then wait while clear.
;           Drawing right after this reduces flicker.
; -----------------------------------------------------------------------------
gfx_wait_vsync:
    ; TODO(Eusef)
    ret
