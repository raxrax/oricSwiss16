;==============================
;BEER
;==============================

;-----------------------------------------------------;
; BEER SONG FOR THE SWEET16 PSEUDO-PROCESSOR          ;
;    BY BARRYM 2011-05-21                             ;
;-----------------------------------------------------;
; THE SWEET16 PSUEDO-PROCESSOR WAS CREATED BY STEVE   ;
;    WOZNIAK IN 1977 TO HELP HIM WRITE COMPACT (BUT   ;
;    SLOWER 16-BIT CODE ON HIS NEW BABY, THE APPLE    ;
;    II.  HE NEVER BUILT IT IN HARDWARE, BUT INSTEAD  ;
;    CREATED A NIFTY LITTLE 372-BYTE INTERPRETER AND  ;
;    BURNED IT INTO THE ROM OF THE ORIGINAL INTEGER   ;
;    BASIC APPLE II.                                  ;
; SWEET16 CODE AND 6502 CODE CAN CO-EXIST PEACEFULLY  ;
;    IN AN APPLE II MACHINE LANGUAGE PROGRAM; A 6502  ;
;    `JSR $F689` IMMEDIATELY PRECEDES A BLOCK OF IN-  ;
;    LINE SWEET16 INSTRUCTIONS AND A SWEET16 `RTN`    ;
;    SWITCHES BACK TO 6502 MODE, WHICH MUST BE DONE   ;
;    AT OR BEFORE PROGRAM COMPLETION.  THE ORIGINAL   ;
;    APPLE II HAD AN UPPER-CASE 40-COLUMN DISPLAY AS  ;
;    STANDARD EQUIPMENT, SO THE OFFICIAL SONG LYRICS  ;
;    ARE ADJUSTED ACCORDINGLY.                        ;
; THANKS TO SBPROJECTS.COM FOR LOTS OF VALUABLE INFO  ;
;    AND A VERY NICE ASSEMBLER!!                      ;
;-----------------------------------------------------;
; CONSTANT EQUATES                                    ;
;-----------------------------------------------------;
; SWEET16  =   $F689        ROM: WOZ` INTERPRETER
; _BIN2ASC  =   $E51B        ; ROM: PRINT UNSIGNED16
; _PUTCHAR  =   $FDED        ; ROM: PRINT CHARACTER
MAXB     =   99              ; MUST BE IN [1..65535]
;-----------------------------------------------------;
; REGISTER EQUATES                                    ;
;-----------------------------------------------------;
      
#ifndef SWISS16
ACU      =   R0           ; SWEET16 MAIN ACCUM.
STK      =   RC           ; SWEET16 STACK POINTER
#endif

BEER     =   R1           ; BEER COUNTER
TYPE     =   R2           ; SUBPHRASE TYPE
PTR      =   R3           ; TEXT POINTER

;-----------------------------------------------------;
; MAIN PROGRAM                                        ;
;-----------------------------------------------------;
SW16_BEER
        BS  (SW16_CLS)
        ; SET (STK,$0110)   ; INIT STACK POINTER
        SET (BEER,MAXB)   ; BEER = MAXB
        SUB  R0           ; (SUB ACU) TYPE = 0
        BS  (PRSONG)      ; PRINT ENTIRE SONG
        BS  (SW16_PRINT_PRESS_A_KEY)
        BS  (SW16_GET)
        RS
;-----------------------------------------------------;
; MAIN LOOP:  PRINT ALL EXCEPT THE LAST SENTENCE      ;
;-----------------------------------------------------;
BEERME  
        SET (PTR,TAKE)    ; PRINT "TAKE ONE ... AROUND,"
        BS  (PRBOB)       ; PRINT " ... ON THE WALL."
PRSONG  
        SET (PTR,CR)      ; PRINT BLANK LINE
        BS  (PRBOB)       ; PRINT " ... ON THE WALL";
        DCR  ACU          ; TYPE = -1
        SET (PTR,COMCR)   ; PRINT ","
        BS  (PRBOB)       ; PRINT " ... OF BEER."
        INR  ACU          ; TYPE = +1
        DCR  BEER         ; BEER = BEER - 1
        BNM1(BEERME)      ; IF BEER <> -1 THEN BEERME
;-----------------------------------------------------;
; SETUP LAST SENTENCE AND FALL THRU                  ;
;-----------------------------------------------------;
        SET (BEER,MAXB)   ; BEER = MAXB
                          ; PRINT "GO TO ... SOME MORE,"
;-----------------------------------------------------;
; SUBROUTINES FOLLOW                                  ;
;-----------------------------------------------------;
; PRINT A PROPERLY PUNCTUATED BOTTLE SUB-PHRASE       ;
; (ENTRY): PTR CONTAINS PRE-STRING POINTER, ACU       ;
;    CONTAINS SUB-PHRASE TYPE (0 = " ... THE WALL",   ;
;    -1 = " ... OF BEER.", +1 = " ... THE WALL.")     ;
; (EXIT):  ACU IS CLEARED                             ;
;-----------------------------------------------------;
PRBOB   
        ST   TYPE
        BS  (PUTS)        ; PRINT PRE-STRING
        LD   BEER         ; IF BEER = 0 THEN
        BZ  (PRBOTT)      ;    PRINT "NO MORE";
        RTN               ; IF BEER > 0 THEN
        lda  $43          ;    esc to 6502 mode just long
        ldx  $42          ;    enough to print value of
        jsr  _BIN2ASC     ;    beer to active output.
        JSR  SWEET16_3    ; 
        SET (PTR,BOTTL)   ; 
PRBOTT
        BS  (PUTS)        ; PRINT " ... BOTTLE";
        DCR  BEER         ; 
        BNZ (NEQ1)        ; IF BEER = 1 THEN
        INR  PTR          ;    SKIP OVER THE "S"
NEQ1    
        INR  BEER         ; 
        BS  (PUTS)        ; PRINT " ... OF BEER";
        LD   TYPE         ; 
        BM1 (NOWALL)      ; IF TYPE >= 0 THEN
        BS  (PUTS)        ;    PRINT " ON THE WALL";
        LD   TYPE         ; 
        BZ  (KPUT)        ; IF TYPE <> 0 THEN
NOWALL  
        SET(PTR,DOTCR)    ;    PRINT "."
;-----------------------------------------------------;
; PRINT A NULL-TERMINATED STRING @ PTR                ;
; (ENTRY): PTR POINTS TO THE START OF THE STRING      ;
; (EXIT):  PTR POINTS TO THE NEXT STRING IN MEMORY,   ;
;          ACU IS CLEARED                             ;
;-----------------------------------------------------;
PUTS    
        LDat PTR          ; GRAB CHAR @ PTR, ADVANCE PTR
        BZ  (KPUT)        ; 
        RTN               ; ESC TO 6502 MODE
        ldx  $40          ;    just long enough
        jsr  _PUTCHAR     ;    to print the char
        jsr  SWEET16_3    ;    TO ACTIVE OUTPUT
        BR  (PUTS)        ; LOOP UNTIL NULL
KPUT    
        RS                ; RETURN
;-----------------------------------------------------;
; OPTIMIZED SONG LYRIC STRING                         ;
;-----------------------------------------------------;
TAKE    .BYT "TAKE ONE DOWN AND PASS IT AROUND"
COMCR   .BYT ","
CR      .BYT 13,10,0
        .BYT "NO MORE"
BOTTL   .BYT " BOTTLE",0
        .BYT "S OF BEER",0
        .BYT " ON THE WALL",0
DOTCR   .BYT ".",13,10,0
        .BYT "GO TO THE STORE AND BUY SOME MORE,",13,10,0

;-----------------------------------------------------;
_BIN2ASC_TMP .byt 0,0,0,0

_BIN2ASC                  ; ROM: PRINT UNSIGNED16
        stx _BIN2ASC_TMP
        sta _BIN2ASC_TMP+1
        lda #$00
        sta _BIN2ASC_TMP+2
        sta _BIN2ASC_TMP+3
        
        ldx #<_BIN2ASC_TMP
        ldy #>_BIN2ASC_TMP
        jsr _binstr
        
        sta _BIN2ASC_TMP
        ldy #0
loop
        ldx str_buf,y
        jsr _PUTCHAR
        iny
        cpy _BIN2ASC_TMP
        bne loop
        rts

;-----------------------------------------------------;
_PUTCHAR                  ; ROM: PRINT CHARACTER
        jmp $238

;-----------------------------------------------------;


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                                                                             *
;*                CONVERT 32-BIT BINARY TO ASCII NUMBER STRING                 *
;*                                                                             *
;*                             by BigDumbDinosaur                              *
;*                                                                             *
;* This 6502 assembly language program converts a 32-bit unsigned binary value *
;* into a null-terminated ASCII string whose format may be in  binary,  octal, *
;* decimal or hexadecimal.                                                     *
;*                                                                             *
;* --------------------------------------------------------------------------- *
;*                                                                             *
;* Copyright (C)1985 by BCS Technology Limited.  All rights reserved.          *
;*                                                                             *
;* Permission is hereby granted to copy and redistribute this software,  prov- *
;* ided this copyright notice remains in the source code & proper  attribution *
;* is given.  Any redistribution, regardless of form, must be at no charge  to *
;* the end user.  This code MAY NOT be incorporated into any package  intended *
;* for sale unless written permission has been given by the copyright holder.  *
;*                                                                             *
;* THERE IS NO WARRANTY OF ANY KIND WITH THIS SOFTWARE. Its free, so no matter *
;* what, youre getting a great deal.                                           *
;*                                                                             *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; CALLING SYNTAX:

;         LDA #RADIX         ;radix character, see below
;         LDX #<OPERAND      ;binary value address LSB
;         LDY #>OPERAND      ;binary value address MSB
;         (ORA #%10000000)   ;radix suppression, see below
;         JSR BINSTR         ;perform conversion
;         STX ZPPTR          ;save string address LSB
;         STY ZPPTR+1        ;save string address MSB
;         TAY                ;string length
; LOOP    LDA (ZPPTR),Y      ;copy string to...
;         STA MYSPACE,Y      ;safe storage, will include...
;         DEY                ;the terminator
;         BPL LOOP

; CALLING PARAMETERS:

; .A      Conversion radix, which may be any of the following:

;         "%"  Binary.
;         "@"  Octal.
;         "$"  Hexadecimal.

;         If the radix is not one of the above characters decimal will be
;         assumed.  Binary, octal & hex conversion will prepend the radix
;         character to the string.  To suppress this feature set bit 7 of
;         the radix.

; .X/.Y   The address of the 32-bit binary value (operand) that is to be
;         converted.  The operand must be in little-endian format.

; REGISTER RETURNS:

; .A      The printable string length.  The exact length will depend on
;         the radix that has been selected, whether the radix is to be
;         prepended to the string & the number of significant digits.
;         Maximum possible printable string lengths for each radix type
;         are as follows:

;         %  Binary   33
;         @  Octal    12
;            Decimal  11
;         $  Hex       9

; .X/.Y   The LSB/MSB address at which the null-terminated conversion
;         string will be located.  The string will be assembled into a
;         statically allocated buffer and should be promptly copied to
;         user-defined safe storage.

; .C      The carry flag will always be clear.

; APPROXIMATE EXECUTION TIMES in CLOCK CYCLES:

;         Binary    5757
;         Octal     4533
;         Decimal  13390
;         Hex       4373

; The above execution times assume the operand is $FFFFFFFF, the radix
; is to be prepended to the conversion string & all workspace other than
; the string buffer is on zero page.  Relocating ZP workspace to absolute
; memory will increase execution time approximately 8 percent.


;================================================================================
;ATOMIC CONSTANTS

; ------------------------------------------
; Modify the above to suit your application.
; ------------------------------------------

a_hexdec  =    "A"-"9"-2            ;hex to decimal difference
m_bits    =    32                   ;operand bit size
m_cbits   =    48                   ;workspace bit size
m_strlen  =    m_bits+1             ;maximum printable string length
n_radix   =    4                    ;number of supported radices
s_pfac    =    m_bits/8             ;primary accumulator size
s_ptr     =    2                    ;pointer size
s_wrkspc  =    m_cbits/8            ;conversion workspace size


; ---------------------------------
; The following may be relocated to
; absolute storage if desired.
; ---------------------------------
pfac      =    binstr_buf+s_ptr     ;primary accumulator
wrkspc01  =    pfac+s_pfac          ;conversion...
wrkspc02  =    wrkspc01+s_wrkspc    ;workspace
formflag  =    wrkspc02+s_wrkspc    ;string format flag
radix     =    formflag+1           ;radix index
stridx    =    radix+1              ;string buffer index

;================================================================================



;CONVERT 32-BIT BINARY TO NULL-TERMINATED ASCII NUMBER STRING

; ----------------------------------------------------------------
; WARNING! If this code is run on an NMOS MPU it will be necessary
;          to disable IRQs during binary to BCD conversion unless
;          the target systems IRQ handler clears decimal mode.
;          Refer to the FACBCD subroutine.
; ----------------------------------------------------------------

; ----------------------------------------------------------------
.text
; ----------------------------------------------------------------

_binstr
.(
         stx _binstr_ptr       ;operand pointer LSB
         sty _binstr_ptr+1     ;operand pointer MSB
         tax                   ;protect radix

         ldy #s_pfac-1         ;operand size

_binstr_ptr = 1+*
binstr01 lda $1234,y           ;copy operand to...
         sta pfac,y            ;workspace
         dey
         bpl binstr01

         iny
         sty stridx            ;initialize string index

; --------------
; evaluate radix
; --------------

         txa                   ;radix character
         asl                   ;extract format flag &...
         ror formflag          ;save it
         lsr                   ;extract radix character
         ldx #n_radix-1        ;total radices

binstr03 cmp radxtab,x         ;recognized radix?
         beq binstr04          ;yes

         dex
         bne binstr03          ;try next

; ------------------------------------
; radix not recognized, assume decimal
; ------------------------------------

binstr04 stx radix             ;save radix index for later
         txa                   ;converting to decimal?
         bne binstr05          ;no

; ------------------------------
; prepare for decimal conversion
; ------------------------------

         jsr facbcd            ;convert operand to BCD
         lda #0
         beq binstr09          ;skip binary stuff

; -------------------------------------------
; prepare for binary, octal or hex conversion
; -------------------------------------------

binstr05 bit formflag
         bmi binstr06          ;no radix symbol wanted

         lda radxtab,x         ;radix table
         sta str_buf            ;prepend to string
         inc stridx            ;bump string index

binstr06 ldx #0                ;operand index
         ldy #s_wrkspc-1       ;workspace index

binstr07 lda pfac,x            ;copy operand to...
         sta wrkspc01,y        ;workspace in...
         dey                   ;big-endian order
         inx
         cpx #s_pfac
         bne binstr07

         lda #0

binstr08 sta wrkspc01,y        ;pad workspace
         dey
         bpl binstr08

; ----------------------------
; set up conversion parameters
; ----------------------------

binstr09 sta wrkspc02          ;initialize byte counter
         ldy radix             ;radix index
         lda numstab,y         ;numerals in string
         sta wrkspc02+1        ;set remaining numeral count
         lda bitstab,y         ;bits per numeral
         sta wrkspc02+2        ;set
         lda lzsttab,y         ;leading zero threshold
         sta wrkspc02+3        ;set

; --------------------------
; generate conversion string
; --------------------------

binstr10 lda #0
         ldy wrkspc02+2        ;bits per numeral

binstr11 ldx #s_wrkspc-1       ;workspace size
         clc                   ;avoid starting carry

binstr12 rol wrkspc01,x        ;shift out a bit...
         dex                   ;from the operand or...
         bpl binstr12          ;BCD conversion result

         rol                   ;bit to .A
         dey
         bne binstr11          ;more bits to grab

         tay                   ;if numeral isnt zero...
         bne binstr13          ;skip leading zero tests

         ldx wrkspc02+1        ;remaining numerals
         cpx wrkspc02+3        ;leading zero threshold
         bcc binstr13          ;below it, must convert

         ldx wrkspc02          ;processed byte count
         beq binstr15          ;discard leading zero

binstr13 cmp #10               ;check range
         bcc binstr14          ;is 0-9

         adc #a_hexdec         ;apply hex adjust

binstr14 adc #"0"              ;change to ASCII
         ldy stridx            ;string index
         sta str_buf,y          ;save numeral in buffer
         inc stridx            ;next buffer position
         inc wrkspc02          ;bytes=bytes+1

binstr15 dec wrkspc02+1        ;numerals=numerals-1
         bne binstr10          ;not done

; -----------------------
; terminate string & exit
; -----------------------

         lda #0
         ldx stridx            ;printable string length
         sta str_buf,x          ;terminate string
         txa
         ldx #<str_buf          ;converted string LSB
         ldy #>str_buf          ;converted string MSB
         clc                   ;all okay
         rts
.)

;================================================================================
;CONVERT PFAC INTO BCD

facbcd
.(
        ldx #s_pfac-1         ;primary accumulator size -1

facbcd01 lda pfac,x            ;value to be converted
         pha                   ;protect
         dex
         bpl facbcd01          ;next

         lda #0
         ldx #s_wrkspc-1       ;workspace size

facbcd02 sta wrkspc01,x        ;clear final result
         sta wrkspc02,x        ;clear scratchpad
         dex
         bpl facbcd02

         inc wrkspc02+s_wrkspc-1
         php                   ;NMOS MPU
         sei                   ;NMOS MPU
         sed                   ;select decimal mode
         ldy #m_bits-1         ;bits to convert -1

facbcd03 ldx #s_pfac-1         ;operand size
         clc                   ;no carry at start

facbcd04 ror pfac,x            ;grab LS bit in operand
         dex
         bpl facbcd04

         bcc facbcd06          ;LS bit clear

         clc
         ldx #s_wrkspc-1

facbcd05 lda wrkspc01,x        ;partial result
         adc wrkspc02,x        ;scratchpad
         sta wrkspc01,x        ;new partial result
         dex
         bpl facbcd05

         clc

facbcd06 ldx #s_wrkspc-1

facbcd07 lda wrkspc02,x        ;scratchpad
         adc wrkspc02,x        ;double &...
         sta wrkspc02,x        ;save
         dex
         bpl facbcd07

         dey
         bpl facbcd03          ;next operand bit

         plp                   ;NMOS MPU
         ldx #0

facbcd08 pla                   ;operand
         sta pfac,x            ;restore
         inx
         cpx #s_pfac
         bne facbcd08          ;next
         rts
.)

;================================================================================
;PER RADIX CONVERSION TABLES

bitstab  .byt 4,1,3,4         ;bits per numeral
lzsttab  .byt 2,9,2,3         ;leading zero suppression thresholds
numstab  .byt 12,48,16,12     ;maximum numerals
radxtab  .byt 0,"%@$"         ;recognized symbols

;================================================================================
;STATIC STORAGE

binstr_buf  .dsb 32
str_buf     .dsb m_strlen+1        ;conversion string buffer

