; =============================================================================
; print.asm - text output through BIOS INT 10h
; -----------------------------------------------------------------------------
; Owner: Marc (Text output)  Reviewer: JP
;
; Works in text mode 03h and in graphics mode 13h (the BIOS draws 8x8 glyphs
; into the framebuffer; in mode 13h BL picks the colour). In mode 13h the
; screen is 40 columns x 25 rows of text.
;
; Calling convention: see docs/MODULE_GUIDE.md section 5. Every routine keeps
; all registers it does not list under Out/Clobbers.
; =============================================================================

; -----------------------------------------------------------------------------
; print_char - print one character at the cursor (INT 10h AH=0Eh)
; In:       AL = character, BL = colour (used in graphics modes)
; Out:      cursor advances
; Clobbers: none
; -----------------------------------------------------------------------------
print_char:
    ; TODO(Marc)
    ret

; -----------------------------------------------------------------------------
; print_str - print a zero-terminated string at the cursor
; In:       DS:SI = string, BL = colour
; Out:      none
; Clobbers: none (SI is restored)
; -----------------------------------------------------------------------------
print_str:
    ; TODO(Marc): loop over print_char until the 0 byte
    ret

; -----------------------------------------------------------------------------
; print_newline - move the cursor to the start of the next line (CR, LF)
; In:       none
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
print_newline:
    ; TODO(Marc)
    ret

; -----------------------------------------------------------------------------
; print_u16 - print an unsigned 16-bit number in decimal
; In:       AX = value (0..65535), BL = colour
; Out:      none
; Clobbers: none
; Notes:    Divide by 10 repeatedly, push the digits, pop and print.
; -----------------------------------------------------------------------------
print_u16:
    ; TODO(Marc)
    ret

; -----------------------------------------------------------------------------
; print_set_cursor - move the text cursor (INT 10h AH=02h, page 0)
; In:       DH = row, DL = column
; Out:      none
; Clobbers: none
; -----------------------------------------------------------------------------
print_set_cursor:
    ; TODO(Marc)
    ret
