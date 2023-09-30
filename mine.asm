    processor 6502 
    include "vcs.h"
    include "macro.h"

    seg.u variables
    org $80

PlayerXPos          .byte 
PlayerYPos          .byte 
PlayerSpritePtr     .word 
PlayerColorPtr      .word 

LandHeight = 50
PLAYER_HEIGHT = 8

    seg code 
    org $F000

Reset:
    CLEAN_START 

    lda #$a8
    sta COLUBK

    lda #$f7 
    sta COLUPF 

    lda #20
    sta PlayerYPos

    lda #97
    sta PlayerXPos 

    lda #<PlayerSprite
    sta PlayerSpritePtr
    lda #>PlayerSprite 
    sta PlayerSpritePtr+1 

    lda #<PlayerColor
    sta PlayerColorPtr
    lda #>PlayerColor 
    sta PlayerColorPtr+1 

StartFrame:

    lda #2
    sta VBLANK
    sta VSYNC 

    REPEAT 3
        sta WSYNC 
    REPEND  

    lda #0
    sta VSYNC 

    lda #0
    sta PF0
    sta PF1 
    sta PF2 

    lda #50
    ldx #0
    jsr SetObjectXPos

    ldx #36
VerticalBlanks:
    sta WSYNC
    dex 
    bne VerticalBlanks

    lda #0
    sta VBLANK 

    ldx #96  
VisibleScanlines:

ShouldRenderLand:
    sec  
    cpx #LandHeight  
    lda #0
    bcs .SkipDrawLand 
    lda #%11111111

.SkipDrawLand:
    sta PF0
    sta PF1 
    sta PF2 

ShouldRenderPlayer0:
    sec 
    txa 
    sbc PlayerYPos
    cmp #PLAYER_HEIGHT
    bcc .DrawPlayer0
    lda #0
.DrawPlayer0:
    tay 
    lda (PlayerSpritePtr),y
    sta GRP0 
    sta WSYNC 

    lda (PlayerColorPtr),y 
    sta COLUP0
    sta WSYNC 

    dex         
    bne VisibleScanlines

    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan

    jmp StartFrame

SetObjectXPos subroutine :
    sec 
    sta WSYNC 
.Divide15:
    sbc #15 
    bcs .Divide15

    eor #07
    asl
    asl
    asl
    asl 

    sta HMP0,x 
    sta RESP0,x

    rts 

PlayerSprite:
    .byte #%00000000
    .byte #%00000000;$00
    .byte #%01101100;$16
    .byte #%00101000;$42
    .byte #%00111000;$F4
    .byte #%10111000;$F4
    .byte #%11111110;$F4
    .byte #%00010010;$22
    .byte #%00011000;$00

PlayerColor:
    .byte #%00000000
    .byte #$00;
    .byte #$16;
    .byte #$42;
    .byte #$F4;
    .byte #$F4;
    .byte #$F4;
    .byte #$22;
    .byte #$00;

    org $FFFC 
    .word Reset
    .word Reset



