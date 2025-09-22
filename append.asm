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
;  Program name: Assignment 2 Array Management
;  Programming environment: Visual Studio Code, gcc 9.4.0, nasm
;  Programming languages:  2 module in C and 5 modules in X86
;  Date program began:     2025-Sep-21
;  Date program completed: 2025-Sep-21
;  Date comments upgraded: 2025-Sep-21
;  Files in this program: main.c, display_array.c, manager.asm, input_array.asm, mean.asm, magnitude.asm, append.asm
;  Status: Complete.
;
;References for this program
;  X86-64 Assembly Language Programming with Ubuntu
;
;Purpose (academic)
;  Store and manipulate the elements of two arrays of double-precision floating point numbers.
;
;This file
;   File name: append.asm
;   Language: i-series microprocessor assembly
;   Syntax: Intel
;   Max page width: 116 columns
;   Assemble: nasm -f elf64 -o append.o append.asm -l append.lis
;   Link: gcc -m64 -no-pie -o arr.out -std=c17 main.o display.o manage.o input.o isfloat.o mean.o magnitude.o append.o #-fno-pie -no-pie
;   Reference regarding -no-pie: Jorgensen, page 226.
;
;===== Begin code area ================================================================================================

;Declarations
%include "gpr_backup.inc"               ;<==This file contains macros that back up and restore the general purpose registers.
extern malloc

global append

segment .data
; empty

segment .bss
; empty

segment .text
append:
backup
mov         r12, rdi                        ; r12 = pointer to arrayA
mov         r13, rsi                        ; r13 = number of elements arrayA
mov         r14, rdx                        ; r14 = pointer to arrayB
mov         r15, rcx                        ; r15 = length of arrayB
; Compute total bytes = (r13 + r15) * 8
mov     rax, r13                            ; rax = elems in A
add     rax, r15                            ; rax = elemsA + elemsB
lea     r8, [rax*8]                         ; r8 = total bytes (elements * 8)

; Allocate new buffer: malloc(total_bytes)
mov     rdi, r8                             ; rdi = size in bytes
call    malloc
mov     r9, rax                             ; r9 = pointer to new array (result)

; Copy qwords (8-byte doubles) from arrayA to new array
xor     rbx, rbx                            ; rbx = index (element index)
cmp     r13, 0
je      copy_b_only
copy_a_loop:
    cmp     rbx, r13
    jge     copy_after_a
    mov     rax, [r12 + rbx*8]              ; load qword (double) from arrayA[rbx]
    mov     [r9 + rbx*8], rax               ; store into new[rbx]
    inc     rbx
    jmp     copy_a_loop
copy_after_a:

; Copy qwords from arrayB into new array starting at offset elemsA
copy_b_only:
    xor     rcx, rcx                        ; rcx = index for arrayB
    cmp     r15, 0
    je      done_copy
copy_b_loop:
    cmp     rcx, r15
    jge     done_copy
    mov     rax, [r14 + rcx*8]              ; load qword from arrayB[rcx]
    mov     rdx, r13
    add     rdx, rcx
    mov     [r9 + rdx*8], rax
    inc     rcx
    jmp     copy_b_loop

done_copy:
mov     rax, r9                             ; return pointer to new array in rax
restore
ret
; End of file