;====================================
; INTRO - THE SWEET16 SHORT INTERNALS
;====================================

SW16_INTRO

    ;; SCREEN 1
    BS      (SW16_CLS)

    SET     (R1,$BB80+0+2*40)
    SET     (R2,TEXT_INTRO)
    SET     (R3,3)
    BS      (SW16_PRINT_TEXT)

    BS      (SW16_PRINT_PRESS_A_KEY)
    BS      (SW16_GET)

    ;; SCREEN 2
    BS      (SW16_CLS)

    SET     (R1,$BB80+0+2*40)
    SET     (R2,TEXT_INTRO2)
    SET     (R3,3)
    BS      (SW16_PRINT_TEXT)

    BS      (SW16_PRINT_PRESS_A_KEY)
    BS      (SW16_GET)

    ;; SCREEN 2
    BS      (SW16_CLS)

    SET     (R1,$BB80+0+3*40)
    SET     (R2,TEXT_INTRO3)
    SET     (R3,3)
    BS      (SW16_PRINT_TEXT)

    BS      (SW16_PRINT_PRESS_A_KEY)
    BS      (SW16_GET)

    RS

TEXT_INTRO
            .byte 3,"SWEET-16 is a powerful programming tool"
            .byte 3,"developed by Steve Wozniak in the early"
            .byte 3,"days of Apple.                         "
            .byte 3,"                                       "
            .byte 3,"SWEET-16 is really a language, just    "
            .byte 3,"like 6502 machine language, BASIC,     "
            .byte 3,"Pascal, FORTRAN. It looks a lot like a "
            .byte 3,"machine language for a computer that   "
            .byte 3,"does not really exist, so 'Woz' has    "
            .byte 3,"called it his 'dream machine'.         "
            .byte 3,"                                       "
            .byte 3,"The SWEET-16 'machine' has sixteen     "
            .byte 3,"16-bit registers (R0-R15). R0 is       "
            .byte 3,"actually the two memory bytes. The next"
            .byte 3,"bytes are called R1-R15. Several of    "
            .byte 3,"the registers have special functions:  "
            .byte 3,"                                       "
            .byte 3,"- R0 is used as an accumulator         "
            .byte 3,"- R1-R11 is the registers              "
            .byte 3,"- R12 is the subroutine stack pointer  "
            .byte 3,"- R13 receives the results of compar.  "
            .byte 3,"- R14 is a status register             "
            .byte 3,"- R15 is the program address counter   "
            .byte 0



TEXT_INTRO2
            .byte 3,"The SWEET 16 opcode listing is short   "
            .byte 3,"and uncomplicated. Excepting relative  "
            .byte 3,"branch displacements.                  "
            .byte 3,"                                       "
            .byte 3,"  Register Ops                         "
            .byte 3,"                                       "
            .byte 3,"  1n SET  Rn  Constant (Set)           "
            .byte 3,"  2n LD   Rn  (Load)                   "
            .byte 3,"  3n ST   Rn  (Store)                  "
            .byte 3,"  4n LD   @Rn (Load Indirect)          "
            .byte 3,"  5n ST   @Rn (Store Indirect)         "
            .byte 3,"  6n LDD  @Rn (Load Double Indirect)   "
            .byte 3,"  7n STD  @Rn (Store Double Indirect)  "
            .byte 3,"  8n POP  @Rn (Pop Indirect)           "
            .byte 3,"  9n STP  @Rn (Store POP Indirect)     "
            .byte 3,"  An ADD  Rn  (Add)                    "
            .byte 3,"  Bn SUB  Rn  (Sub)                    "
            .byte 3,"  Cn POPD @Rn (Pop Double Indirect)    "
            .byte 3,"  Dn CPR  Rn  (Compare)                "
            .byte 3,"  En INR  Rn  (Increment)              "
            .byte 3,"  Fn DCR  Rn  (Decrement)              "
            .byte 0

TEXT_INTRO3
            .byte 3,"  Nonregister Ops                      "
            .byte 3,"                                       "
            .byte 3,"  00   RTN       Return to 6502 mode   "
            .byte 3,"  01   BR   ea   Branch always         "
            .byte 3,"  02   BNC  ea   Branch if No Carry    "
            .byte 3,"  03   BC   ea   Branch if Carry       "
            .byte 3,"  04   BP   ea   Branch if Plus        "
            .byte 3,"  05   BM   ea   Branch if Minus       "
            .byte 3,"  06   BZ   ea   Branch if Zero        "
            .byte 3,"  07   BNZ  ea   Branch if NonZero     "
            .byte 3,"  08   BM1  ea   Branch if Minus 1     "
            .byte 3,"  09   BNM1 ea   Branch if Not Minus 1 "
            .byte 3,"  0A   BK        Break                 "
            .byte 3,"  0B   RS        Return from Subroutine"
            .byte 3,"  0C   BS   ea   Branch to Subroutine  "
            .byte 3,"  0D   Unassigned                      "
            .byte 3,"  0E   Unassigned                      "
            .byte 3,"  0F   Unassigned                      "
            .byte 3,"                                       "
            .byte 3,"  Try it yourself !!!                  "
            .byte 0
