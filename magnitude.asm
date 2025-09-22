;******************************************************************************************************************
;Copyright (C) 2020 Floyd Holliday                                                                                *
;                                                                                                                 *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public*
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it *
;will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  *
;PARTICULAR PURPOSE.  See the GNU General Public License for more details.  A copy of the GNU General Public      *
;License v3 is available here:  <https://www.gnu.org/licenses/>.                                                  *
;******************************************************************************************************************


;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2
;
;Author information
;  Author name: Cameron Abo
;  Author email: cabo0@csu.fullerton.edu
;
;Program information
;  Program name: Assignment 2 Array magnitudement
;  Programming environment: Visual Studio Code, gcc 9.4.0, nasm
;  Programming languages:  2 module in C and 5 modules in X86
;  Date program began:     2025-Sep-21
;  Date program completed: 2025-Sep-21
;  Date comments upgraded: 2025-Sep-21
;  Files in this program: main.c, display_array.c, magnituder.asm, input_array.asm, mean.asm, magnitude.asm, append.asm
;  Status: Complete.
;
;References for this program
;  X86-64 Assembly Language Programming with Ubuntu
;
;Purpose (academic)
;  Store and manipulate the elements of two arrays of double-precision floating point numbers.
;
;This file
;   File name: magnituder.asm
;   Language: i-series microprocessor assembly
;   Syntax: Intel
;   Max page width: 116 columns
;   Assemble: nasm -f elf64 -o magnitude.o magnitude.asm -l magnitude.lis
;   Link: gcc -m64 -no-pie -o arr.out -std=c17 main.o display.o manage.o input.o isfloat.o mean.o magnitude.o append.o #-fno-pie -no-pie
;   Reference regarding -no-pie: Jorgensen, page 226.
;
;===== Begin code area ================================================================================================

;Declarations
%include "gpr_backup.inc"           ;<==This file contains macros that back up and restore the general purpose registers.

global get_magnitude

segment .data
double_zero dq 0.0                  ; Define a double-precision floating-point zero in memory
double_one  dq 1.0                  ; Define a double-precision floating-point one in memory

segment .bss

segment .text
get_magnitude:
backup

; Initialize sum and counter to 0.0
movsd       xmm0, [double_zero]     ; sum = 0.0
mov         r13, 0                  ; Initialize loop counter to 0

; Find sum of squares of array elements
beginloop:
    cmp     r13, rsi                ; Compare loop counter with number of elements
    jge     endloop                 ; If counter >= number of elements, exit loop

    movsd   xmm1, [rdi + r13*8]     ; Load array element into xmm1
    mulsd   xmm1, xmm1              ; Square the element
    addsd   xmm0, xmm1              ; Add squared value to sum

inc         r13                     ; Increment loop counter
jmp         beginloop               ; Repeat loop
endloop:
sqrtsd      xmm0, xmm0              ; Compute the square root of the sum (result in xmm0)
restore
ret
; End of file