; =============================================================================
; stage2_env.inc - the environment every Stage 2 routine assumes
; -----------------------------------------------------------------------------
; Owner: Yuan (Boot)        Reviewer: Eusef
;
; STAGE2_ENV_SETUP is expanded at the top of stage2_entry and of every test
; harness so they all start from the same state:
;   DS = ES = SS = 0, SP = STACK_TOP, DF = 0 (cld), interrupts enabled.
; Keep it a macro (not a call): the stack is not valid until it has run.
; =============================================================================
%ifndef STAGE2_ENV_INC
%define STAGE2_ENV_INC

%macro STAGE2_ENV_SETUP 0
    ; sets up stage 2 environment by doing the thing the docs says it should do
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, STACK_TOP
    sti
    cld
%endmacro

%endif
