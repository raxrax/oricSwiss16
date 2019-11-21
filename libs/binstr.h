/*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                                                             *
 *                CONVERT 32-BIT BINARY TO ASCII NUMBER STRING                 *
 *                                                                             *
 *                             by BigDumbDinosaur                              *
 *                                                                             *
 * This 6502 assembly language program converts a 32-bit unsigned binary value *
 * into a null-terminated ASCII string whose format may be in  binary,  octal, *
 * decimal or hexadecimal.                                                     *
 *                                                                             *
 * --------------------------------------------------------------------------- *
 *                                                                             *
 * Copyright (C)1985 by BCS Technology Limited.  All rights reserved.          *
 *                                                                             *
 * Permission is hereby granted to copy and redistribute this software,  prov- *
 * ided this copyright notice remains in the source code & proper  attribution *
 * is given.  Any redistribution, regardless of form, must be at no charge  to *
 * the end user.  This code MAY NOT be incorporated into any package  intended *
 * for sale unless written permission has been given by the copyright holder.  *
 *                                                                             *
 * THERE IS NO WARRANTY OF ANY KIND WITH THIS SOFTWARE. Its free, so no matter *
 * what, youre getting a great deal.                                           *
 *                                                                             *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

// CALLING SYNTAX:
//
//         LDA #RADIX         ;radix character, see below
//         LDX #<OPERAND      ;binary value address LSB
//         LDY #>OPERAND      ;binary value address MSB
//         (ORA #%10000000)   ;radix suppression, see below
//         JSR BINSTR         ;perform conversion
//         STX ZPPTR          ;save string address LSB
//         STY ZPPTR+1        ;save string address MSB
//         TAY                ;string length
// LOOP    LDA (ZPPTR),Y      ;copy string to...
//         STA MYSPACE,Y      ;safe storage, will include...
//         DEY                ;the terminator
//         BPL LOOP
//
// CALLING PARAMETERS:
//
// .A      Conversion radix, which may be any of the following:
//
//         "%"  Binary.
//         "@"  Octal.
//         "$"  Hexadecimal.
//
//         If the radix is not one of the above characters decimal will be
//         assumed.  Binary, octal & hex conversion will prepend the radix
//         character to the string.  To suppress this feature set bit 7 of
//         the radix.
//
// .X/.Y   The address of the 32-bit binary value (operand) that is to be
//         converted.  The operand must be in little-endian format.
//
// REGISTER RETURNS:
//
// .A      The printable string length.  The exact length will depend on
//         the radix that has been selected, whether the radix is to be
//         prepended to the string & the number of significant digits.
//         Maximum possible printable string lengths for each radix type
//         are as follows:
//
//         %  Binary   33
//         @  Octal    12
//            Decimal  11
//         $  Hex       9
//
// .X/.Y   The LSB/MSB address at which the null-terminated conversion
//         string will be located.  The string will be assembled into a
//         statically allocated buffer and should be promptly copied to
//         user-defined safe storage.
//
// .C      The carry flag will always be clear.
//
// APPROXIMATE EXECUTION TIMES in CLOCK CYCLES:
//
//         Binary    5757
//         Octal     4533
//         Decimal  13390
//         Hex       4373
//
// The above execution times assume the operand is $FFFFFFFF, the radix
// is to be prepended to the conversion string & all workspace other than
// the string buffer is on zero page.  Relocating ZP workspace to absolute
// memory will increase execution time approximately 8 percent.


#ifndef __BINSTR_H__
#define __BINSTR_H__

#ifdef USE_TIMER_STRINGS

#ifdef ASSEMBLER

#else /* ASSEMBLER */

void binstr(void);

#endif /* ASSEMBLER */

#endif /* USE_TIMER_STRINGS */

#endif /*  __BINSTR_H__ */
