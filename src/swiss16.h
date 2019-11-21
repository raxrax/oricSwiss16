/*
 * Real Programmers don't need comments -- the code is obvious.
 *
*/

#ifndef __SWISS16_H__
#define __SWISS16_H__

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
#define BR(loc)         .byt  $01,<(loc-1),>(loc-1)
#define BNC(loc)        .byt  $02,<(loc-1),>(loc-1)
#define BC(loc)         .byt  $03,<(loc-1),>(loc-1)
#define BP(loc)         .byt  $04,<(loc-1),>(loc-1)
#define BM(loc)         .byt  $05,<(loc-1),>(loc-1)
#define BZ(loc)         .byt  $06,<(loc-1),>(loc-1)
#define BNZ(loc)        .byt  $07,<(loc-1),>(loc-1)
#define BM1(loc)        .byt  $08,<(loc-1),>(loc-1)
#define BNM1(loc)       .byt  $09,<(loc-1),>(loc-1)
#define BK              .byt  $0a
#define RS              .byt  $0b
#define BS(loc)         .byt  $0c,<(loc-1),>(loc-1)

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
// Resister aliases
// -------------------------------
#define ACU             R0           // SWEET16 MAIN ACCUM.
#define STK             RC           // SWEET16 STACK POINTER

// -------------------------------
// Sweet16 entries and aliases
// -------------------------------
#define SWEET16_INIT    _SW16_INIT
#define SWISS16_INIT    _SW16_INIT
#define SWEET16         _SW16
#define SWEET16_3       _SW16+3
#define SWISS16         _SW16
#define SWISS16_3       _SW16+3

#endif /* __SWISS16_H__ */
