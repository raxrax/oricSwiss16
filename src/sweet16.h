/*
 * Real Programmers don't need comments -- the code is obvious.
 *
*/

#ifndef __SWEET16_H__
#define __SWEET16_H__

// -------------------------------
// Sweet16 instructions
// -------------------------------
#define SET(reg,val)    .byt  $10+reg,<(val),>(val)
#define LD              .byt  $20+
#define ST              .byt  $30+
#define LDat            .byt  $40+
#define STat            .byt  $50+
#define LDDat           .byt  $60+
#define STDat           .byt  $70+
#define POPat           .byt  $80+
#define STPat           .byt  $90+
#define ADD             .byt  $a0+
#define SUB             .byt  $b0+
#define POPDat          .byt  $c0+
#define CPR             .byt  $d0+
#define INR             .byt  $e0+
#define DCR             .byt  $f0+
#define RTN             .byt  $00

// -------------------------------
// Branches
// -------------------------------
#ifdef __CC65__
#define RELBR(loc)       <((loc)-*-1)
#else
#define RELBR(loc)       <((loc)-*-2)
#endif

#define BR(loc)         .byt  $01,RELBR(loc)
#define BNC(loc)        .byt  $02,RELBR(loc)
#define BC(loc)         .byt  $03,RELBR(loc)
#define BP(loc)         .byt  $04,RELBR(loc)
#define BM(loc)         .byt  $05,RELBR(loc)
#define BZ(loc)         .byt  $06,RELBR(loc)
#define BNZ(loc)        .byt  $07,RELBR(loc)
#define BM1(loc)        .byt  $08,RELBR(loc)
#define BNM1(loc)       .byt  $09,RELBR(loc)
#define BK              .byt  $0a
#define RS              .byt  $0b
#define BS(loc)         .byt  $0c,RELBR(loc)

// -------------------------------
// Resisters
// -------------------------------
#define R0              $0
#define R1              $1
#define R2              $2
#define R3              $3
#define R4              $4
#define R5              $5
#define R6              $6
#define R7              $7
#define R8              $8
#define R9              $9
#define RA              $a
#define RB              $b
#define RC              $c
#define RD              $d
#define RE              $e
#define RF              $f

// -------------------------------
// Sweet16 entry
// -------------------------------
#define SWEET16         _SW16
#define SWEET16_3       _SW16+3

#endif /* __SWEET16_H__ */
