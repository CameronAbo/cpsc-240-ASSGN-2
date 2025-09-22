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

extern is_float
extern stdin
extern atof
extern printf
extern isfloat
extern fgets

global fill_array

segment .data
tryagainmessage db "The last input was invalid and not entered into the array.",newline,null

segment .bss
buffer resb 512                     ; holds the string input of a floating point number

segment .text
fill_array:
backup              ; This macro backs up all general purpose registers.
mov r14, rdi        ; r14 = base address of array (from caller)
mov r15, rsi        ; r15 = capacity (number of cells)
mov r13, 0          ; r13 = 0

begin:
;--------------- Stores string input ------------------------------------------------------
xor rax, rax                        ; Clear rax
mov rdi, buffer                     ; Address of string
mov rsi, 511                        ; Maximum number of characters to read
mov rdx, [stdin]                    ; File handle (FILE*) from libc stdin
call fgets                           ; Call fgets to read a string from stdin stored at address in rdi
;---------------------------------------------------------------------------------------------------

;--------------- Check for ctrl-d ----------------------------------------------------------
cmp rax, 0                          ; Did fgets return 0 (ctrl-d)?
je exit                             ; Jump if ctrl-d was entered
;--------------- Validate string as float ----------------------------------------------------------
;mov rax, 0                          ; Clear rax
;mov rdi, buffer                     ; Address of string
;call isfloat                        ; Call isfloat to validate the string as a float
;; rax holds 0 if test fails, non-zero if test passes
;cmp rax, 0                          ; Did the test fail?
;je failed                           ; Jump if test failed
;---------------------------------------------------------------------------------------------------

;--------------- Convert String to float ----------------------------------------------------------
mov rax, 0
mov rdi, buffer
call atof                            ; Places converted float into rax
jmp continue                         ; Jump to continue
;---------------------------------------------------------------------------------------------------

;--------------- If test Failed ----------------------------------------------------------------
failed:
    mov rax, 0
    mov rdi, tryagainmessage
    call printf
    jmp begin
;---------------------------------------------------------------------------------------------------

continue:
lea r8, [r14 + r13*8]  ; r8 = address of array[index = 0]
movsd [r8], xmm0       ; store the float in the array
inc r13                ; index++
cmp r13, r15          ; compare index to array size
jl begin

exit:
mov rax, r13        ; return number of elements in array
restore             ; This macro restores all general purpose registers.
ret