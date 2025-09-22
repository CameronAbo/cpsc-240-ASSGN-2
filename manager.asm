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
newline equ 10
null equ 0
global array_size
array_size equ 15

extern printf
extern isfloat
extern fill_array
extern display_array

global manager

segment .data
align 16
welcome db "This program will manage your arrays of 64-bit floats",newline,null
promptA db "For array A enter a sequence of 64-bit floats seperated by white space.", newline,
        db "After the last input press enter followed by Control+D", newline, null

displayA db newline, "These numbers were received and placed into array A:",newline,null

magnitudeA db "The magnitude of array A is %1.6lf",newline,null 

promptB db newline, "For array B enter a sequence of 64-bit floats seperated by white space.", newline,
        db "After the last input press enter followed by Control+D", newline, null

displayB db newline, "These numbers were received and placed into array B:",newline,null

magnitudeB db "The magnitude of array B is %1.6lf",newline,null

displayAB db newline, "Arrays A and B have been appended and given the name A0x2295B", newline,
          db "A0x2295B contains",newline,null

magnitudeAB db newline, "The magnitude of array A0x2295B is %1.6lf",newline,null

meanAB db newline, "The mean of array A0x2295B is %1.6lf",newline,null

stringformat db "%s", 0                                     ;general string format

floatformat db "%lf", 0

align 64

segment .bss
arrayA resq array_size                      ; Holds up to 15 double precision floating point numbers (cell size: 8 bytes)
arrayB resq array_size                      ; Holds up to 15 double precision floating point numbers



segment .text
manager:
backup                  ; This macro backs up all general purpose registers.
;---------------- Print welcome message ------------------------------------------------------
mov qword rax, 0
mov       rdi, stringformat
mov       rsi, welcome
call printf
;---------------------------------------------------------------------------------------------------

;---------------- Input array A ------------------------------------------------------
mov qword rax, 0
mov       rdi, stringformat
mov       rsi, promptA
call printf
mov rax, 0
mov rdi, arrayA
mov rsi, array_size
call fill_array        ; rax = elements in arrayA
mov r13, rax           ; r13 holds the number of values stored in the array plywood.
; Call display_array(arrayA, rax)
mov qword rax, 0
mov     rdi, stringformat
mov     rsi, displayA
call    printf

mov     rdi, arrayA
mov     rsi, r13        ; number of elements returned in r13
call    display_array




restore                 ; This macro restores all general purpose registers.
ret