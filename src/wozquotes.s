;====================================
; WOZ`S QUOTES
;====================================

SW16_WOSQUOTES

LINE1       = $A000+40*40
LINE2       = $A000+160*40
LENEHEIGHT  = 2


TEXT_START_ADDR_HIRES   = ($A000+ 20+ 5*8*40)-1
TEXT_START_ADDR_TEXT    = ($BB80+ 20+ 20*8*40)-1
TEXT_HEIGHT             = 10

;============================================

    SET     (R1, _HIRES)
    BS      (SW16_CALL6502)

    ;; HIDE PROMPT
    SET     (R1,$26A)
    SET     (R0,10)
    STat    R1

    ;; LOAD IMAGE
    BS      (SW16_WOSQUOTES_LOADIMAGE)

    ;; PRESS ANY KEY
    BS      (SW16_PRINT_PRESS_A_KEY)
    BS      (SW16_GET)

    ;; TEXT
    SET     (R1, _TEXT)
    BS      (SW16_CALL6502)

    ;; HIDE PROMPT
    SET     (R1,$26A)
    SET     (R0,10)
    STat    R1

    RS

;====================================
SW16_WOSQUOTES_LOADIMAGE
    BS      (SW16_WOSQUOTES_NEXTIMAGE)    ;GET RANDOM IMAGE OFFSET

    ;; DECOMPRESS IMAGE
    SET     (R1, $A000)
    BS      (SW16_LZ4DECOMPRESSER)
    RS

;====================================
;RETURN R2-RANDOM IMAGE OFFSET
SW16_WOSQUOTES_RANDOMIMAGE
    RTN
    ;ASM
    lda     $304
    and     #$07
    asl
    tay
    lda     PICS,y
    sta     PICOFF
    lda     PICS+1,y
    sta     PICOFF+1
    ;SWEET16
    jsr     SWEET16
    SET     (R1,PICOFF)
    LDDat   R1
    ST      R2
    RS

;====================================
;RETURN R2-NEXT IMAGE OFFSET
SW16_WOSQUOTES_NEXTIMAGE

    SET     (R1,PICNO)
    LDat    R1
    INR     R0
    DCR     R1
    STat    R1

    SET     (R2,9)
    SET     (R1,PICNO)
    LDat    R1
    CPR     R2
    BNZ (SW16_GAME_PLAYER_MOVE_NEXT)
    SET (R0,0)
    SET (R1,PICNO)
    STat R1

SW16_GAME_PLAYER_MOVE_NEXT
    RTN
    ;ASM
    lda PICNO
    asl
    tay
    lda PICS,y
    sta PICOFF
    lda PICS+1,y
    sta PICOFF+1
    ;SWEET16
    jsr SWEET16

    SET   (R1,PICOFF)
    LDDat R1
    ST    R2
    RS

PICOFF  .word 0
PICNO   .byte 0
PICS    .word _pic_0
        .word _pic_1
        .word _pic_2
        .word _pic_3
        .word _pic_4
        .word _pic_5
        .word _pic_6
        .word _pic_7
        .word _pic_8
