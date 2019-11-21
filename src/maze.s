SW16_MAZE

    ; RS

    BS  (SW16_CLS)

    SET     (R3,$bba8)
    SET     (R4,40*26)

SW16_LAB_LOOP
    ; SET     (R1,1)
    ; BS      (SW16_WAIT)

    BS      (SW16_LAB_RAND)
    LD      R9
    BNZ     (SW16_LAB_CH1)
    SET     (R0, 92)
    BR      (SW16_LAB_PRINT)
SW16_LAB_CH1
    SET     (R0, 47)
SW16_LAB_PRINT
    STat    R3
    DCR     R4
    BNZ     (SW16_LAB_LOOP)


    ;; PRESS ANY KEY
    BS      (SW16_PRINT_PRESS_A_KEY)
    BS      (SW16_GET)

    RS


;RETURN R9-IMAGE NUMBER
SW16_LAB_RAND
    RTN
    ;ASM
    ldx #$ff
    jsr $E355
    ldx $D2
    lda $D1
    and     #$01
    sta     lab_rand
    ;SWEET16
    jsr     SWEET16
    SET     (R1,lab_rand)
    LDat    R1
    ST      R9

    RS
lab_rand  .byte 0
