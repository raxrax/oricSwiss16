SW16_HIERS_LINES

;==============================
;   HIRES LINES
;------------------------------
    ; RTN
    ; jsr   _HIRES
    ; JSR   SWEET16

    SET   (R1, _HIRES)
    BS    (SW16_CALL6502)

    SET   (R1,$A000)   ;HIRES
    SET   (R2,16)
    SET   (R3,8000)     ;LEN
    SET   (R4,24)
    
LP1
    LD    R2
    STat  R1

    INR   R2
    LD    R2
    CPR   R4
    BNZ   (SK1)
    SET   (R2,16)

SK1
    DCR  R3
    BNZ (LP1)
    
    BS  (SW16_PRINT_PRESS_A_KEY)
    BS  (SW16_GET)
    
    SET (R1, _TEXT)
    BS  (SW16_CALL6502)
    
    ;; HIDE PROMPT
    SET     (R1,$26A)
    SET     (R0,10)
    STat    R1

    RS