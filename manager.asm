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
;   File name: manager.asm
;   Language: i-series microprocessor assembly
;   Syntax: Intel
;   Max page width: 116 columns
;   Assemble: nasm -f elf64 -o manage.o manager.asm -l manage.lis
;   Link: gcc -m64 -no-pie -o arr.out -std=c17 director.o super.o input.o output.o 
;   Reference regarding -no-pie: Jorgensen, page 226.
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
extern get_mean
extern get_magnitude
extern append
extern clearerr
extern stdin

global manager

segment .data
align 16
welcome     db "This program will manage your arrays of 64-bit floats",newline,null

promptA     db "For array A enter a sequence of 64-bit floats seperated by white space.", newline,
            db "After the last input press enter followed by Control+D", newline, null

displayA    db newline, "These numbers were received and placed into array A:",newline,null

magnitudeA  db "The magnitude of array A is %1.10lf",newline,null 

promptB     db newline, "For array B enter a sequence of 64-bit floats seperated by white space.", newline,
            db "After the last input press enter followed by Control+D", newline, null

displayB    db newline, "These numbers were received and placed into array B:",newline,null

magnitudeB  db "The magnitude of array B is %1.10lf",newline,null

displayAB   db newline, "Arrays A and B have been appended and given the name A ", 0x2295, " B", newline,
            db "A ",0x2295, " B contains",newline,null

magnitudeAB db newline, "The magnitude of A ", 0x2295, " B is %1.10lf",newline,null

meanAB      db newline, "The mean of A ",0x2295," B is %1.10lf",newline,newline,null

stringformat db "%s", 0                                     ;general string format

floatformat db "%lf", 0                                     ;general float format

align 64

segment .bss
arrayA resq array_size                      ; Holds up to 15 double precision floating point numbers (cell size: 8 bytes)

arrayB resq array_size                      ; Holds up to 15 double precision floating point numbers


segment .text
manager:
backup                                      ; This macro backs up all general purpose registers.
; Print welcome message
mov qword   rax, 0
mov         rdi, stringformat
mov         rsi, welcome
call        printf

; Input array A
mov qword   rax, 0
mov         rdi, stringformat
mov         rsi, promptA
call        printf
mov         rax, 0
mov         rdi, arrayA
mov         rsi, array_size
call        fill_array                      ; rax = elements in arrayA
mov         r13, rax                        ; r13 holds the number of values stored in the array plywood.

; Call display_array(arrayA, rax)
mov qword   rax, 0
mov         rdi, stringformat
mov         rsi, displayA
call        printf
mov         rdi, arrayA                     ; rdi = pointer to arrayA
mov         rsi, r13                        ; rsi = number of elements returned in arrayA
call        display_array

; Call get_magnitude(arrayA, r13)
mov         rdi, arrayA                     ; rdi = pointer to arrayA
mov         rsi, r13
call        get_magnitude                   ; rsi = number of elements returned in arrayA
movsd       xmm8, xmm0                      ; Store magnitude of array A in xmm8

; Display Magnitude of array A
mov         rax, 1
movsd       xmm0, xmm8                      ; Move magnitude of array A into xmm0 for printf
mov         rdi, magnitudeA
call        printf

; Clear EOF on stdin so subsequent fgets calls (for array B) will work after Ctrl-D
mov     rdi, [rel stdin]
call    clearerr

; Input array B
mov qword   rax, 0
mov         rdi, stringformat
mov         rsi, promptB
call        printf
mov         rax, 0
mov         rdi, arrayB
mov         rsi, array_size
call        fill_array                      ; rax = elements in arrayB
mov         r14, rax                        ; r14 holds the number of values stored in the arrayB.

; Call display_array(arrayB, rax)
mov qword   rax, 0
mov         rdi, stringformat
mov         rsi, displayB
call        printf
mov         rdi, arrayB                     ; rdi = pointer to arrayB
mov         rsi, r14                        ; rsi = number of elements returned in arrayB
call        display_array

; Call get_magnitude(arrayB, r14)
mov         rdi, arrayB                     ; rdi = pointer to arrayB
mov         rsi, r14
call        get_magnitude                   ; rsi = number of elements returned in arrayB
movsd       xmm9, xmm0                      ; Store magnitude of array B in xmm9

; Display Magnitude of array B
mov         rax, 1
movsd       xmm0, xmm9                      ; Move magnitude of array B into xmm0 for printf
mov         rdi, magnitudeB
call        printf

; Append array B to array A to create arrayC
mov         rdi, arrayA                     ; rdi = pointer to arrayA
mov         rsi, r13                        ; rsi = number of elements arrayA
mov         rdx, arrayB                     ; rdx = pointer to arrayB
mov         rcx, r14                        ; rcx = length of arrayB
call        append                          ; rax = pointer to new arrayC
mov         r12, rax                        ; r12 = pointer to new arrayC
mov         r15, r13                        ; r15 = number of elements in arrayC
add         r15, r14                        ; r15 = number of elements in arrayC

; Display arrayC
mov qword   rax, 0
mov         rdi, stringformat
mov         rsi, displayAB
call        printf
mov         rdi, r12                        ; rdi = pointer to arrayC
mov         rsi, r15                        ; rsi = number of elements returned in arrayC
call        display_array   

; Call get_magnitude(arrayC, r15)
mov         rdi, r12                        ; rdi = pointer to arrayC
mov         rsi, r15
call        get_magnitude                   ; rsi = number of elements returned in arrayC
movsd       xmm10, xmm0                     ; Store magnitude of array C in xmm10

; Display Magnitude of array C
mov         rax, 1
movsd       xmm0, xmm10                     ; Move magnitude of array C into xmm0 for
mov         rdi, magnitudeAB
call        printf

; Call get_mean(arrayC, r15)
mov         rdi, r12                        ; rdi = pointer to arrayC
mov         rsi, r15
call        get_mean                        ; rsi = number of elements returned in arrayC
movsd       xmm10, xmm0                     ; Store mean of array C in xmm10

; Display Mean of array C
mov         rax, 1
movsd       xmm0, xmm10                     ; Move mean of array C into xmm0 for
mov         rdi, meanAB
call        printf

restore                                     ; This macro restores all general purpose registers.
ret
; End of file