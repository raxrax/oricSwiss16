;====================================
; WOZ'S QUOTES
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
    BS      (SW16_WOSQUOTES_RANDOMIMAGE)    ;GET RANDOM IMAGE OFFSET

    ;; DECOMPRESS IMAGE
    SET     (R1, $A000)
    BS      (SW16_LZ4DECOMPRESSER)

;====================================
;RETURN R2-RANDOM IMAGE OFFSET
SW16_WOSQUOTES_RANDOMIMAGE
    RTN
    ;ASM
    lda     $304
    and     #$07
    asl
    tay
    lda     _pics,y
    sta     PICOFF
    lda     _pics+1,y
    sta     PICOFF+1
    ;SWEET16
    jsr     SWEET16
    SET     (R1,PICOFF)
    LDDat   R1
    ST      R2
    RS
PICOFF  .word 0
;====================================

; SW16_WOSQUOTES_LINES
;     SET     (R1,LINE1)
;     SET     (R2,LINE2)
;     SET     (R3,LENEHEIGHT*40)

; SW16_WOSQUOTES_LINES_LOOP
;     SET     (R0,127)
;     STat    R1
;     STat    R2
;     DCR     R3
;     BNZ     (SW16_WOSQUOTES_LINES_LOOP)

;     RS

;====================================

; QUOTES1
;     .byte   "Wherever smart",13
;     .byte   "     people work,",13
;     .byte   "doors are ",13
;     .byte   "        unlocked.",0

; QUOTES2
;     .byte   "The easier it is",13
;     .byte   "to do something,",13
;     .byte   "the harder it is",13
;     .byte   "to change the way",13
;     .byte   "        you do it.",0

; QUOTES3
;     .byte "I learned not to",13
;     .byte "worry so much",13
;     .byte "about the outcome,",13
;     .byte "but to concentrate",13
;     .byte "on the step I was",13
;     .byte "on and to try to",13
;     .byte "do it as perfectly",13
;     .byte "as I could when I",13
;     .byte "was doing it.",0

; QUOTES4
;     .byte "If you love what",13
;     .byte "you do and are",13
;     .byte "willing to do",13
;     .byte "what it takes,",13
;     .byte "it's within",13
;     .byte "your reach.",0

; QUOTES5
;     .byte "Everything we did",13
;     .byte "we were setting",13
;     .byte "the tone for",13
;     .byte "the world.",0

; QUOTES6
;     .byte "Creative things",13
;     .byte "have to sell to",13
;     .byte "get acknowledged",13
;     .byte "         as such.",0

; QUOTES7
;     .byte "My goal wasn't to",13
;     .byte "make a ton of",13
;     .byte "           money.",13
;     .byte "It was to build",13
;     .byte "good computers.",0


; ; 1)  "Wherever smart people work, doors are unlocked."

; ; 2)  "The easier it is to do something, the harder it is to change the way you do it."

; ; 3)  "I hope you're as lucky as I am. The world needs inventors--great ones. You can be one. If you love what you do and are willing to do what it really takes, it's within your reach. And it'll be worth every minute you spend alone at night, thinking and thinking about what it is you want to design or build. It'll be worth it, I promise."

; ; 4)  "I learned not to worry so much about the outcome, but to concentrate on the step I was on and to try to do it as perfectly as I could when I was doing it."

; ; 5)  "If you love what you do and are willing to do what it takes, it's within your reach."

; ; 6)  "Everything we did we were setting the tone for the world."

; ; 7)  "Creative things have to sell to get acknowledged as such."

; ; 8)  "My goal wasn't to make a ton of money. It was to build good computers."
