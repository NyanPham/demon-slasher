    processor 6502 
    include "vcs.h"
    include "macro.h"
    
    seg.u variables

    org $80

    seg code 
    org $F000

Reset:
    CLEAN_START 

    lda #$a8
    sta COLUBK

StartFrame:

    lda #2
    sta VBLANK
    sta VSYNC 

    REPEAT 3
        sta WSYNC 
    REPEND  

    lda #0
    sta VSYNC 

    ldx #37 
VerticalBlanks:
    sta WSYNC
    dex 
    bne VerticalBlanks

    lda #0
    sta VBLANK 

    ldx #192 
VisibleScanlines:
    sta WSYNC 
    dex 
    bne VisibleScanlines

    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan
    
    jmp StartFrame

    org $FFFC 
    .word Reset
    .word Reset



