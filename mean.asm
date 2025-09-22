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
;  Program name: gpr_backup.inc
;  Programming environment: Visual Studio Code, gcc 9.4.0, nasm
;  Programming languages:  X86
;  Date program began:     2025-Sep-21
;  Date program completed: 2025-Sep-21
;  Date comments upgraded: 2025-Sep-21
;  Files in this program: director.c, supervisor.asm, output_array.asm, input_array.c, director.c 
;  Status: Complete.  Alpha testing is finished.  Extreme cases were tested and errors resolved.
;
;References for this program
;  X86-64 Assembly Language Programming with Ubuntu
;
;Purpose (academic)
;  Backup and restore all general purpose registers and rflags.
;
;This file
;   File name: gpr_backup.inc
;   Language: i-series microprocessor assembly
;   Syntax: Intel
;   Max page width: 116 columns
;   Assemble: nasm -f elf64 -o super.o supervisor.asm -l super.lis
;   Link: gcc -m64 -no-pie -o arr.out -std=c17 director.o super.o input.o output.o 
;   Reference regarding -no-pie: Jorgensen, page 226.
;   Prototype of this function:  double manage_arrays();
;
;=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2
;
;
;
;
;===== Begin code area ================================================================================================

;Declarations
%include "gpr_backup.inc"      ;<==This file contains macros that back up and restore the general purpose registers.

global get_mean

segment .data
double_zero dq 0.0             ; Define a double-precision floating-point zero in memory
double_one  dq 1.0             ; Define a double-precision floating-point one in memory
segment .bss

segment .text
get_mean:
backup
; rdi = pointer to array
; rsi = number of elements in array
; returns: xmm0 = mean of array elements

; Initialize sum to 0.0
movsd  xmm0, [double_zero]  ; sum = 0.0
movsd  xmm1, [double_zero]  ; counter = 0.0
; Loop through the array and sum the elements
mov     r13, 0             ; index i = 0

loopbegin:
    cmp     r13, rsi       ; compare i with number of elements
    jge     loopend        ; if i >= number of elements, exit loop

    movsd   xmm2, [rdi + r13*8] ; load array[i]
    addsd   xmm0, xmm2           ; sum += array[i]
    addsd   xmm1, [double_one]   ; counter++
    inc     r13                  ; i++
    jmp     loopbegin            ; repeat loop
loopend:

; Calculate mean = sum / number of elements
divsd xmm0, xmm1        ; xmm0 = sum / counter (mean)
restore
ret