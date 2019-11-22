
GAME_WINDOW_X       = 8
GAME_WINDOW_Y       = 5
GAME_WINDOWS_WIDTH  = 11
GAME_WINDOWS_HEIGHT = 13
GAME_PLAYER_CHAR1   = '&'
GAME_PLAYER_CHAR2   = ')'
GAME_PLAYER_BOX     = '$'
GAME_PLAYER_START_ADDRESS = $BB80+GAME_WINDOW_X+(GAME_WINDOW_Y+GAME_WINDOWS_HEIGHT)*40
GAME_PLAYER_START_LINE = $BB80+GAME_WINDOW_X+(GAME_WINDOW_Y+1)*40
GAME_PLAYER_KEY_LEFT    = 8
GAME_PLAYER_KEY_RIGHT   = 9
GAME_PLAYER_KEY_SHOT    = 32
GAME_PLAYER_KEY_EXIT    = 27
GAME_STATE_RUNNING      = 1
GAME_STATE_STOP         = 0
GAME_NEWLINE_PRINT_SPEED = 0
GAME_NEWLINE_SPEED_COUNTER = 3

;====================================

SW16_GAME

    BS      (SW16_GAME_SCREEN)
    BS      (SW16_GAME_INIT)

    BS      (SW16_GAME_GAME)

    BS      (SW16_PRINT_PRESS_A_KEY)
    BS      (SW16_GET)

    RS

;====================================

SW16_GAME_SCREEN
    SET     (R1, $b900)
    SET     (R2, GAME_FONT)
    SET     (R3, 88)
    BS      (SW16_MOVE)

    SET     (R1, $bbA8)
    SET     (R2, GAME_SCREEN)
    SET     (R3, 1080)
    BS      (SW16_MOVE)

    RS

;====================================

;; init game
SW16_GAME_INIT
    SET     (R1,game_player_x)      ;SET PLAYER X
    SET     (R0,7)
    STat    R1
    
    SET     (R1,game_state)         ;SET GAME STATE
    SET     (R0,GAME_STATE_RUNNING)
    STat    R1

    SET     (R0,0)                  ;game_lines_counter
    SET     (R1,game_lines_counter)
    STat    R1

    BS      (SW16_GAME_PRINTPLAYER)

    RS

;====================================

SW16_GAME_GAME
    ; BS      (SW16_GAME_PRINTNEWLINE)
    ; BS      (SW16_GAME_PRINTNEWLINE)
    ; BS      (SW16_GAME_PRINTNEWLINE)
    ; BS      (SW16_GAME_PRINTNEWLINE)
    ; BS      (SW16_GAME_PRINTPLAYER)
SW16_GAME_GAME_LOOP
    BS      (SW16_GET)
    BS      (SW16_GAME_ERASEPLAYER)
    BS      (SW16_GAME_PLAYER_MOVE)
    BS      (SW16_GAME_PRINTPLAYER)

    SET     (R1,game_state)
    LDat    R1
    BNZ     (SW16_GAME_GAME_LOOP)
    RS

;====================================
;; player routine
SW16_GAME_PLAYER_MOVE

    SET     (R6,GAME_PLAYER_KEY_LEFT)
    SET     (R7,GAME_PLAYER_KEY_RIGHT)
    SET     (R8,GAME_PLAYER_KEY_SHOT)
    SET     (R5,GAME_PLAYER_KEY_EXIT)

    ;;LEFT
    LD      R9
    CPR     R6
    BNZ     (SW16_GAME_PLAYER_MOVE_NEXT1)
    SET     (R2,game_player_x)              ;BORDER CHECK
    LDat    R2
    BZ      (SW16_GAME_PLAYER_MOVE_NEXT1)

    SET     (R2,game_player_x)              
    LDat    R2
    ST      R1
    DCR     R1
    LD      R1
    SET     (R2,game_player_x)
    STat    R2
    BR      (SW16_GAME_PLAYER_MOVE_END)

SW16_GAME_PLAYER_MOVE_NEXT1
    ;; RIGHT
    LD      R9
    CPR     R7
    BNZ     (SW16_GAME_PLAYER_MOVE_NEXT2)
    SET     (R2,game_player_x)              ;BORDER CHECK
    SET     (R1, GAME_WINDOWS_WIDTH)
    LDat    R2
    CPR     R1
    BZ      (SW16_GAME_PLAYER_MOVE_NEXT2)

    SET     (R2,game_player_x)
    LDat    R2
    ST      R1
    INR     R1
    LD      R1
    SET     (R2,game_player_x)
    STat    R2

    BR      (SW16_GAME_PLAYER_MOVE_END)

SW16_GAME_PLAYER_MOVE_NEXT2
    ;; SHOT
    LD      R9
    CPR     R8
    BNZ     (SW16_GAME_PLAYER_MOVE_NEXT3)

    BS      (SW16_GAME_MOVEBOX)

    BR      (SW16_GAME_PLAYER_MOVE_END)

SW16_GAME_PLAYER_MOVE_NEXT3
    ;; EXIT
    LD      R9
    CPR     R5
    BNZ     (SW16_GAME_PLAYER_MOVE_END)
    SET     (R1, game_state)
    SET     (R0, GAME_STATE_STOP)
    STat    R1

SW16_GAME_PLAYER_MOVE_END
    RS

;====================================
;; print player
SW16_GAME_PRINTPLAYER
    ;; calc addr
    SET     (R1,GAME_PLAYER_START_ADDRESS)
    SET     (R2,game_player_x)
    LDat    R2
    ADD     R1
    ST      R1

    ; ;; char 1
    LD      R1
    ST      R2
    SET     (R0,GAME_PLAYER_CHAR2)
    STat    R2

    ; ; ;; char 2
    ; SET     (R3,40)
    ; LD      R1
    ; SUB     R3
    ; ST      R1
    ; SET     (R0,GAME_PLAYER_CHAR2)
    ; STat    R1

    RS

SW16_GAME_ERASEPLAYER
    ;; calc addr
    SET     (R1,GAME_PLAYER_START_ADDRESS)
    SET     (R2,game_player_x)
    LDat    R2
    ADD     R1
    ST      R1

    ;; char 1
    LD      R1
    ST      R2
    SET     (R0,32)
    STat    R2

    ; ;; char 2
    ; SET     (R3,40)
    ; LD      R1
    ; SUB     R3
    ; ST      R1
    ; SET     (R0,32)
    ; STat    R1

    RS

;====================================

SW16_GAME_MOVEBOX

    ;; SFX
    SET     (R1,sfx_table_shot)
    BS      (SW16_SFX)

    ;; GET WINDOWS HEIGHT - R5
    SET     (R5, GAME_WINDOWS_HEIGHT)

    ;; GET PLAYER POSSITION - R6
    SET     (R6,GAME_PLAYER_START_ADDRESS-40)
    SET     (R2,game_player_x)
    LDat    R2
    ADD     R6
    ST      R6                              ;BOX POSITION

SW16_GAME_MOVEBOX_LOOP
    ;;CHECK FOR BOX LEFT
    SET     (R4,1)
    LD      R6
    ST      R3                              ;TEMP BOX POS
    SUB     R4
    ST      R3

    SET     (R4,32)
    LDat    R3
    CPR     R4

    BZ      (SW16_GAME_MOVEBOX_CHECK2)      ;IF SPACE - NEXT
    BR      (SW16_GAME_MOVEBOX_NEW_LINE)    ;IF NO SPACE - EXIT

SW16_GAME_MOVEBOX_CHECK2
    ;;CHECK FOR BOX RIGHT
    SET     (R4,1)
    LD      R6
    ST      R3                              ;TEMP BOX POS
    ADD     R4
    ST      R3

    SET     (R4,32)
    LDat    R3
    CPR     R4
    BZ      (SW16_GAME_MOVEBOX_CHECK3)      ;IF SPACE - NEXT

    BR      (SW16_GAME_MOVEBOX_NEW_LINE)    ;IF NO SPACE - EXIT

SW16_GAME_MOVEBOX_CHECK3
    ;;CHECK FOR BOX END
    LD      R5                              ;LINE COUNTER
    SET     (R0,1)                  
    CPR     R5                              ;IF LAST LINE - SKIP
    BZ      (SW16_GAME_MOVEBOX_CHECK_END)

    SET     (R4,40)
    LD      R6
    ST      R3                              ;TEMP BOX POS
    SUB     R4
    ST      R3

    SET     (R4,32)
    LDat    R3
    CPR     R4

    BZ      (SW16_GAME_MOVEBOX_CHECK_END)  ;IF SPACE - NEXT
    BR      (SW16_GAME_MOVEBOX_NEW_LINE)   ;IF NO SPACE - EXIT


SW16_GAME_MOVEBOX_CHECK_END
    ;; ERASE_BOX
    SET     (R0, 32)
    STat    R6
    DCR     R6

    DCR     R5                              ;CHECK FOR EXIT
    BNZ     (SW16_GAME_MOVEBOX_NEXT)
    BR      (SW16_GAME_MOVEBOX_NEW_LINE)

SW16_GAME_MOVEBOX_NEXT
    SET     (R2,40)                         ;PREV LINE
    LD      R6
    SUB     R2
    ST      R6      

    ;; PRINT_BOX
    SET     (R0, GAME_PLAYER_CHAR1)
    STat    R6
    DCR     R6

    ;; WAIT
    SET     (R1,3)
    BS      (SW16_WAIT)

    BR      (SW16_GAME_MOVEBOX_LOOP)

SW16_GAME_MOVEBOX_NEW_LINE
    BS      (SW16_GAME_PRINTNEWLINE)
    RS

;====================================

SW16_GAME_PRINTNEWLINE
;INPUT - R6 BOX POS
    ;; ERESE LINE IF FULL
    BS      (SW16_GAME_ERASE_LINES)

    SET     (R1, game_lines_counter)        ;IF TIME FOR NEW LINE
    LDat    R1
    BZ      (SW16_GAME_PRINTNEWLINE_NEW)

    ST      R2
    SET     (R1, game_lines_counter)       ;DEC COUNTER
    DCR     R2
    LD      R2
    STat    R1
    RS                                      ;EXIT

SW16_GAME_PRINTNEWLINE_NEW

    SET     (R1, game_lines_counter)
    SET     (R0, GAME_NEWLINE_SPEED_COUNTER)
    STat    R1

    ;; MOVE LINES
    BS      (SW16_GAME_MOVE_LINES)

    ;; GET LINE
    BS      (SW16_GAME_RAND)
    SET     (R2, game_new_lines)

SW16_GAME_PRINTNEWLINE_CALC_LOOP
    ;CALC LINE ADDRESS
    LD      R9                  
    BZ     (SW16_GAME_PRINTNEWLINE_NEXT)

    SET     (R0,GAME_WINDOWS_WIDTH+2)
    ADD     R2
    ST      R2
    DCR     R9
    BR      (SW16_GAME_PRINTNEWLINE_CALC_LOOP)      

SW16_GAME_PRINTNEWLINE_NEXT
    SET     (R1, GAME_PLAYER_START_LINE)    ;DEST
    SET     (R3, GAME_NEWLINE_PRINT_SPEED)  ;SPEED
    BS      (SW16_PRINT_TEXT)

    BS      (SW16_GAME_GAMEOVER_CHECK)

    RS

;====================================

;RETURN R9-IMAGE NUMBER
SW16_GAME_RAND
    RTN
    ;ASM
    ldx #$ff
    jsr $E355
    ldx $D2
    lda $D1
    and     #$07
    sta     game_rand
    ;SWEET16
    jsr     SWEET16
    SET     (R1,game_rand)
    LDat    R1
    ST      R9
    RS

game_rand  .byte 0

;====================================

SW16_GAME_ERASE_LINES
;INPUT R6 - BOX POS
    SET     (R5,game_player_x)              ;get player pos
    LDat    R5
    ST      R4

    LD      R6                              ;CALC START LINE ADDDR
    SUB     R4
    ST      R1                              ;SET START LINE POS - R1
    ST      R6                              ;SET START LINE POS - R6


    SET     (R2, GAME_WINDOWS_WIDTH+1)      ;LINE LEN

    SET     (R3, 32)                        ;SPACE CHAR

SW16_GAME_ERASE_LINES_LOOP
    LDat    R1                              ;CHECK FOR FULL LINE
    CPR     R3
    BZ      (SW16_GAME_ERASE_LINES_END)
    DCR     R2
    BNZ     (SW16_GAME_ERASE_LINES_LOOP)

SW16_GAME_ERASE_LINES_ERASE
    SET     (R1, sfx_table_line)
    BS      (SW16_SFX)

    ;;ERASE
    LD      R6
    ST      R1
    SET     (R2,32)
    SET     (R3,GAME_WINDOWS_WIDTH+1)    
    BS      (SW16_MEMSET)

SW16_GAME_ERASE_LINES_END
    RS
;====================================

SW16_GAME_MOVE_LINES

    SET     (R6,GAME_PLAYER_START_LINE-80+GAME_WINDOWS_HEIGHT*40)     ;LINE FROM
    SET     (R7,GAME_PLAYER_START_LINE-80+GAME_WINDOWS_HEIGHT*40+40)  ;LINE to
    SET     (R8,GAME_WINDOWS_HEIGHT-1)      ;LOOPS
    SET     (R9,40)                         ;LINE LEN

SW16_GAME_MOVE_LINES_LOOP
    ;;MOVE LINE
    LD      R6              
    ST      R2
    LD      R7
    ST      R1
    SET     (R3, GAME_WINDOWS_WIDTH+1)
    BS      (SW16_MOVE)

    ;;CALC NEXT LINE ADDR
    LD      R6              ;DEST
    SUB     R9
    ST      R6

    LD      R7              ;SRC
    SUB     R9
    ST      R7
    
    DCR     R8              ;INDEX -1
    BNZ     (SW16_GAME_MOVE_LINES_LOOP)    

    RS

;====================================

SW16_GAME_GAMEOVER_CHECK
    SET     (R3, GAME_WINDOWS_WIDTH)
    SET     (R1, GAME_PLAYER_START_ADDRESS-40)

SW16_GAME_GAMEOVER_CHECK_LOOP
    LDat    R1
    SET     (R2,32)
    CPR     R2
    BNZ     (SW16_GAME_GAMEOVER_CHECK_TRUE)

    DCR     (R3)
    BNZ     (SW16_GAME_GAMEOVER_CHECK_LOOP)
    BR      (SW16_GAME_GAMEOVER_CHECK_FALSE)

SW16_GAME_GAMEOVER_CHECK_TRUE
    SET     (R1, sfx_table_die)
    BS      (SW16_SFX)

    SET     (R2,game_state)
    SET     (R0,GAME_STATE_STOP)
    STat    R2
    RS

SW16_GAME_GAMEOVER_CHECK_FALSE
    RS

;====================================
GAME_SCREEN
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((                  (( ",8,3,"        ",4,9,"(("
    .byte   9,4,"(((",6,160," $% %$  $% %$ ",160,4,"((",10,3,"- Boxes -",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",10,3,"- Boxes -",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,3,"         ",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,1," SWEET16 ",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,1,"Demo game",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,3,"         ",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((((((((((((((((("
    .byte   9,4,"(((",6,160,"              ",160,4,"((((((((((((((((("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,3,"         ",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,3,"KEYS     ",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,2,": Left   ",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,2,": Right  ",4,9,"(("
    .byte   9,4,"(((",6,160,"              ",160,4,"((",8,2,": Space  ",4,9,"(("
    .byte   9,4,"(((",6,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,4,"((",8,2,": ESC    ",4,9,"(("
    .byte   9,4,"(((                  ((             (("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"((((((((((((((((((((((((((((",8,1,"2019",4,9,"(("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("
    .byte   9,4,"(((((((((((((((((((((((((((((((((((((("


GAME_FONT
    .byt 0,0,0,0,0,0,0,0
    .byt 0,0,18,12,12,18,0,0
    .byt 0,0,18,12,12,18,0,0
    .byt 21,42,21,42,21,42,21,42
    .byt 0,31,33,41,37,33,62,0
    .byt 0,62,33,37,41,33,31,0
    .byt 0,30,33,44,13,33,30,0
    .byt 0,0,18,12,12,18,0,0
    .byt 18,49,14,22,26,28,35,18
    .byt 0,12,30,63,45,12,30,63
    .byt 50,33,14,22,26,28,33,19
    .byt 0,0,0,0,0,0,0,0

game_new_lines
    .byte "$$%$$$%$$ %$",0     ;1
    .byte "$$%$ $$%$%$$",0     ;2
    .byte "$ $% $$ %$ $",0     ;3
    .byte " $ $% %$ $$ ",0     ;4
    .byte "$$$%%$$     ",0     ;5
    .byte "$%$  $%$  $$",0     ;6
    .byte "$$%%$   $$$$",0     ;7
    .byte "$   $%$$   $",0     ;8


game_player_x   .byte 0
game_state      .byte 0
game_lines_counter  .byte 0


sfx_table_shot  .byte 0,0,0,2,0,3,15,73,0,16,16,0,4,0
sfx_table_line  .byte 0,0,0,2,0,3,0,121,0,16,16,0,10,0
sfx_table_die   .byte 0,0,0,10,0,15,0,73,0,16,16,0,20,0
