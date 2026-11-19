; =============================================================================
; test_graphics.asm - standalone check for lib/graphics.asm
; -----------------------------------------------------------------------------
; Owner: Eusef   Reviewer: Marc         Run: make test T=graphics
; =============================================================================

%include "include/config.inc"
%include "include/stage2_env.inc"
%include "include/video.inc"

[bits 16]
[org STAGE2_ADDR]

test_entry:
    STAGE2_ENV_SETUP
    ; TODO(Eusef):
    ;   1. gfx_init, gfx_clear COLOR_BLUE           Expect: solid blue screen
    ;   2. gfx_put_pixel at (0,0), (319,0), (0,199), (319,199) in white
    ;                                               Expect: 4 corner dots
    ;   3. gfx_fill_rect 16 bars, one per colour 0..15, across the screen
    ;                                               Expect: palette strip
    ;   4. Animate a 10x10 square left to right with gfx_wait_vsync,
    ;      erase + redraw each frame                Expect: smooth, no tearing
    ;   5. Check: no pixel appears outside the rectangles (off-by-one test)
.hang:
    cli
    hlt
    jmp .hang

%include "lib/graphics.asm"

%include "include/stage2_pad.inc"
