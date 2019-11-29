;==============================
;TEST
;==============================
#include "swiss16.h"
#include "romcalls.h"

#define USE_SW16_PRINT_TEXT
#define USE_SW16_WAIT
#define USE_SW16_MULTIPLICATION
#define USE_SW16_GET
#define USE_SW16_MOVE
#define USE_SW16_CLS
#define USE_SW16_MEMSET
#define USE_SW16_CALL6502
#define USE_SW16_SFX
#define USE_SW16_LZ4DECOMPRESSER
#include "sw16lib.s"
#include "intro.s"
#include "lines.s"
#include "hireslines.s"
#include "beer.s"
#include "maze.s"
#include "wozquotes.s"
#include "game.s"
#include "font.s"

TEXT_WELCOME_LINE   =   11

;==============================
_ENTRY
;------------------------------
    JSR     SWEET16_INIT
;------------------------------
    JSR     SWEET16

    SET     (R1,$26B)
    SET     (R0,1808)       ;PAPER0 INK7
    STDat   R1

    ;; CLEAR SCREEN
    BS      (SW16_CLS)

    ;; HIDE PROMPT
    SET     (R1,$26A)
    SET     (R0,10)
    STat    R1

    ;; SET FONT
    SET     (R1, $B500)
    SET     (R2, _CHARSET)
    SET     (R3, 96*8)
    BS      (SW16_MOVE)

    ;; MENU
    BS      (SW16_MENU)
   
    ;; CLEAR SCREEN
    BS      (SW16_CLS)

    ;; SHOW PROMPT
    SET     (R1,$26A)
    SET     (R0,3)
    STat    R1

    RTN

;------------------------------
    rts
;==============================
SW16_MENU

    BS      (SW16_CLS)

    ;; TOP LINE TEXT
    SET     (R1,$BB80)
    SET     (R2,TEXT_TITLE)
    SET     (R3,0)
    BS      (SW16_PRINT_TEXT)

    ;; CREDITS
    SET     (R1,$BB80+27*40)
    SET     (R2,TEXT_CREDITS)
    SET     (R3,0)
    BS      (SW16_PRINT_TEXT)

    ;; WELCOME TEXT

    SET     (R3,0)
    SET     (R1,$BB80+7+4*40)
    SET     (R2,TEXT_WELCOME1)
    BS      (SW16_PRINT_TEXT)
    SET     (R1,$BB80+7+5*40)
    SET     (R2,TEXT_WELCOME1)
    BS      (SW16_PRINT_TEXT)


    ;;  LOAD TEXT SPEED
    SET     (R1,TEXT_SPEED)
    LDat    (R1)
    ST       R3

    SET     (R1,TEXT_SPEED)
    SET     (R0,0)
    STat    (R1)

    

    ;; PRINT TEXTS
    SET     (R1,$BB80+3+8*40)
    SET     (R2,TEXT_WELCOME2)
    BS      (SW16_PRINT_TEXT)

    SET     (R1,$BB80+10+TEXT_WELCOME_LINE*40)
    SET     (R2,TEXT_WELCOME3)
    BS      (SW16_PRINT_TEXT)

    SET     (R1,$BB80+10+(1+TEXT_WELCOME_LINE)*40)
    SET     (R2,TEXT_WELCOME4)
    BS      (SW16_PRINT_TEXT)

    SET     (R1,$BB80+10+(2+TEXT_WELCOME_LINE)*40)
    SET     (R2,TEXT_WELCOME5)
    BS      (SW16_PRINT_TEXT)
    
    SET     (R1,$BB80+10+(3+TEXT_WELCOME_LINE)*40)
    SET     (R2,TEXT_WELCOME6)
    BS      (SW16_PRINT_TEXT)

    SET     (R1,$BB80+10+(4+TEXT_WELCOME_LINE)*40)
    SET     (R2,TEXT_WELCOME7)
    BS      (SW16_PRINT_TEXT)

    SET     (R1,$BB80+10+(5+TEXT_WELCOME_LINE)*40)
    SET     (R2,TEXT_WELCOME8)
    BS      (SW16_PRINT_TEXT)    

    SET     (R1,$BB80+10+(6+TEXT_WELCOME_LINE)*40)
    SET     (R2,TEXT_WELCOME9)
    BS      (SW16_PRINT_TEXT) 

    SET     (R1,$BB80+10+(8+TEXT_WELCOME_LINE)*40)
    SET     (R2,TEXT_WELCOME10)
    BS      (SW16_PRINT_TEXT)

    BS      (SW16_PRINT_PRESS_A_KEY)


SW16_MENU_CHOICE
    BS      (SW16_GET)
    ;; SOUND FX    
    SET     (R1,SFX_TABLE_CHOICE)
    BS      (SW16_SFX)

    SET     (R1,'2')
    LD      R9
    CPR     R1                      ;LINES
    BNZ     (SW16_MENU_CHOICE_NEXT) 
    BS      (SW16_LINES)
    BR      (SW16_MENU)

SW16_MENU_CHOICE_NEXT
    SET     (R1,'3')
    LD      R9
    CPR     R1                      ;HIRES LINES
    BNZ     (SW16_MENU_CHOICE_NEXT2) 
    BS      (SW16_HIERS_LINES)
    BR      (SW16_MENU)

SW16_MENU_CHOICE_NEXT2
    SET     (R1,'4')
    LD      R9
    CPR     R1                      ;BEER
    BNZ     (SW16_MENU_CHOICE_NEXT3) 
    BS      (SW16_BEER)
    BR      (SW16_MENU)

SW16_MENU_CHOICE_NEXT3
    SET     (R1,'5')
    LD      R9
    CPR     R1                      ;MAZE
    BNZ     (SW16_MENU_CHOICE_NEXT4) 
    BS      (SW16_MAZE)
    BR      (SW16_MENU)

SW16_MENU_CHOICE_NEXT4
    SET     (R1,'6')
    LD      R9
    CPR     R1                      ;GAME
    BNZ     (SW16_MENU_CHOICE_NEXT5) 
    BS      (SW16_GAME)
    BR      (SW16_MENU)    

SW16_MENU_CHOICE_NEXT5
    SET     (R1,'7')
    LD      R9
    CPR     R1                      ;WOS`S QUOTES
    BNZ     (SW16_MENU_CHOICE_NEXT6) 
    BS      (SW16_WOSQUOTES)
    BR      (SW16_MENU)   

SW16_MENU_CHOICE_NEXT6
    SET     (R1,'1')
    LD      R9
    CPR     R1                      ;INTRO
    BNZ     (SW16_MENU_CHOICE_END) 
    BS      (SW16_INTRO)
    BR      (SW16_MENU)


SW16_MENU_CHOICE_END
    SET     (R1,'0')
    LD      R9
    CPR     R1                    ;EXIT
    BZ      (SW16_MENU_CHOICE_EXIT)

    BR      (SW16_MENU_CHOICE)
SW16_MENU_CHOICE_EXIT
    RS
;==============================
SW16_PRINT_PRESS_A_KEY
    ;; PRESS ANY KEY
    SET     (R1,$BB80+21+27*40)
    SET     (R2,TEXT_PAK)
    SET     (R3,0)
    BS      (SW16_PRINT_TEXT)
    RS
;==============================


    TEXT_CREDITS    .byte 4,"[ISS/RAX]",0

    TEXT_TITLE      .byte 5,"  Hello world! Here is Woz's Sweet-16. ",0

    TEXT_WELCOME1   .byte 3,10,"--- SWEET16 DEMO PAGE ---",0
    TEXT_WELCOME2   .byte 2,"This demo was made with the SWEET16",0
    TEXT_WELCOME3   .byte 6,"1..     Intro",0
    TEXT_WELCOME4   .byte 6,"2..     Text Lines",0
    TEXT_WELCOME5   .byte 6,"3..     Hires Lines",0
    TEXT_WELCOME6   .byte 6,"4..     99 Bottles of Beer",0
    TEXT_WELCOME7   .byte 6,"5..     Maze Generator",0
    TEXT_WELCOME8   .byte 6,"6..     Boxes Game",0
    TEXT_WELCOME9   .byte 6,"7..     Woz's Quotes (random)",0
    TEXT_WELCOME10  .byte 6,"0..     Exit",0

    TEXT_PAK        .byte 16,12,1,"Press any key...",0

    TEXT_SPEED      .byte 5

    SFX_TABLE_CHOICE .byte 0,0,160,0,0,0,0,61,0,16,0,100,0,0

    
