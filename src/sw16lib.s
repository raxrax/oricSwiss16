;************************************
;* Simple SWEET16 Function Library  *
;*           For Oric               *
;*          14.11.2019              *
;*            by RAX                *
;************************************

#ifdef USE_SW16_KEY
;RETURN R9 - key
SW16_KEY
        SET     (R1,$2DF)       ;LAST KEY ADDR
        SET     (R2,128)        
        LDat    R1              ;LOAD KEY
        SUB     R2              ;REMOVE BIT 7
        ST      R9              ;SET KEY IN R9 
        SET     (R0,0)
        SET     (R1,$2DF)       ;LAST KEY ADDR
        STat    R1
        RS 
#endif

;===================================

#ifdef USE_SW16_CLS
;none
SW16_CLS
        SET     (R1,$BBA8)
        SET     (R2,32)
        SET     (R3,40*27)
        BS      (SW16_MEMSET)
        RS
#endif

;===================================

#ifdef USE_SW16_COPY_TEXT
;INPUT R1 - DES
;INPUT R2 - SRC
SW16_COPY_TEXT
        LDat    R2
        STat    R1
        BNZ     (SW16_COPY_TEXT)
        RS
#endif

;===================================

#ifdef USE_SW16_PRINT_TEXT
;INPUT R1 - DEST
;INPUT R2 - SRC
;INPUT R3 - SPEED
SW16_PRINT_TEXT
        LD      R1          ;TEMP DEST
        ST      R8          
        LD      R2          ;TEMP SRC
        ST      R9 
        
SW16_PRINT_TEXT_LOOP
        LDat    R9          ;CHECK FOR EXIT
        BZ      (SW16_PRINT_TEXT_END)        
        DCR     (R9)

        SET     (R0,128+32) ;PROMPT
        STat    R8
        DCR     R8

        LD      R3          ;WAIT
        ST      R1
        BS      (SW16_WAIT) ;CALL WAIT

        LDat    R9          ;PRINT
        STat    R8
        BR     (SW16_PRINT_TEXT_LOOP)

SW16_PRINT_TEXT_END
        RS
#endif

;===================================

#ifdef USE_SW16_MOVE
;INPUT R1 - DES
;INPUT R2 - SRC
;INPUT R3 - LEN
SW16_MOVE
        LDat    R2              ;LOAD DATA
        STat    R1              ;SAVE DATA
        DCR     R3              ;DECREMENT LEN COUNTER
        BNZ     (SW16_MOVE)     ;IF LEN NOT ZERO
        RS                      ;RETURN
#endif

;===================================

#ifdef USE_SW16_MEMSET
;INPUT R1 - DES
;INPUT R2 - CHAR
;INPUT R3 - LEN
SW16_MEMSET
        LD      R2
        STat    R1
        DCR     R3
        BNZ     (SW16_MEMSET)
        RS
#endif

;===================================

#ifdef USE_SW16_GET
;RETURN R9 - key
SW16_GET
        SET     (R1,$2DF)       ;LAST KEY ADDR
        SET     (R0,0)
        STat    R1        

SW16_GET_LOOP     
        SET     (R1,$2DF)       ;LAST KEY ADDR
        SET     (R2,128)
        LDat    R1              ;LOAD KEY 
        BZ     (SW16_GET_LOOP)
        SUB     R2              ;REMOVE BIT 7
        ST      R9              ;SET KEY IN R9
        RS 
#endif

;===================================

#ifdef USE_SW16_WAIT
;INPUT R1- WAIT VALUE
;AFFECT RA
SW16_WAIT
        
        SET     (R2,$276)                ;TIMER ADDR
        LD      R1                       ;LOAD VALUE
        BZ      (SW16_WAIT_END)
        STat    R2
SW16_WAIT_LOOP
        SET     (R2,$276)  
        LDat    R2
        BNZ     (SW16_WAIT_LOOP)
SW16_WAIT_END        
        RS
#endif

;===================================

#ifdef USE_SW16_MULTIPLICATION
;INPUT R1- VAR1
;INPUT R2- VAR2
;RETURN R9 - RESULT
SW16_MULTIPLICATION
        SET     (R9,0)                  ;CLEAR RESULT
        SET     (R0,0)                  ;CLEAR ACC
        LD      R1                      ;LOAD VAR1
        BZ      (SW16_MULTIPLICATION_END); IF NULL - END
SW16_MULTIPLICATION_LOOP
        ADD     R1
        DCR     R2
        BNZ     (SW16_MULTIPLICATION_LOOP)
SW16_MULTIPLICATION_END
        RS
#endif

;===================================

#ifdef USE_SW16_CALL6502
;INPUT R1-6502 ROUTINE ADDRESS
SW16_CALL6502
        SET     (R2,SW16_CALL_INST+1)
        LD      R1
        STDat   R2
        RTN
SW16_CALL_INST
        jsr     $1234
        jsr     SWEET16
        RS
#endif

;===================================

#ifdef USE_SW16_SFX
;INPUT R1 - SOUND TABLE ADDR
SW16_SFX
        SET     (R2,SW16_SFX_TABBLE_ADDRESS)
        LD      R1
        STDat   R2
        RTN     
        ;GOTO 6502 
        ldx SW16_SFX_TABBLE_ADDRESS
        ldy SW16_SFX_TABBLE_ADDRESS+1
        jsr $FA86
        jsr SWEET16
        ;RETRN TO SWEET16
        RS
SW16_SFX_TABBLE_ADDRESS
        .byte 0,0
#endif

;===================================

#ifdef USE_SW16_LOADFILE
;INPUT R1 - DESTINATION
;INPUT R2 - FILENAME
SW16_LOADFILE
        SET     (R9, _sed_fname)        ;FILENAME
        LD      R2
        STDat   R9
        SET     (R9, _sed_begin)        ;DESTINATION
        LD      R1
        STDat   R9
        SET     (R1, _sed_loadfile)     ;LOAD
        BS      (SW16_CALL6502)
        RS
#endif

;===================================

#ifdef  USE_SW16_LZ4DECOMPRESSER
;INPUT R1 - DESTINATION
;INPUT R2 - SOURCE
SW16_LZ4DECOMPRESSER
        SET         (R9, _lzfh_src)         ;SOURCE
        LD          R2
        STDat       R9
        SET         (R9, _lzfh_dst)         ;DESTINATION
        LD          R1
        STDat       R9
        SET         (R1, _lzfh_decompress)  ;DECOMPRESS
        BS          (SW16_CALL6502)
        RS
#endif
