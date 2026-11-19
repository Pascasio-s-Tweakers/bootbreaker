; =============================================================================
; stage2_pad.inc - pad a Stage 2 binary to exactly STAGE2_SECTORS sectors
; -----------------------------------------------------------------------------
; Owner: Yuan (Boot)        Reviewer: Eusef
;
; %include this as the LAST line of src/stage2/main.asm and of every test
; harness. Stage 1 always reads STAGE2_SECTORS sectors, so the image must hold
; that many. If Stage 2 grows past the budget, NASM stops with
; "TIMES value is negative": raise STAGE2_SECTORS in config.inc (max 17, see
; the note there) or shrink the code.
; =============================================================================

stage2_end:
    times (STAGE2_SECTORS * 512) - ($ - $$) db 0
