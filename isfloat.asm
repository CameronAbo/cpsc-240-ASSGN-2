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
;number_of_cells equ 5          ;<==To next open source developer: you may wish to change the size of the array

extern printf
extern isfloat
extern fget
extern atof
extern input_array
extern showlumber
extern stdin

global isfloat

segment .data
tryagainmessage db "The last input was invalid and not entered into the array.",newline,null


segment .bss
floatnumber resb 15                  ;<==Holds the string input of a floating point number


segment .text
backup    ;<==This macro backs up all general purpose registers.
begin:
;--------------- inputs float as string ------------------------------------------------------
xor rax, rax                        ;Clear rax
mov rdi, floatnumber                ;Address of string
mov rsi, 15                         ;Maximum number of characters to read
mov rdx, [stdin]                    ;File handle 0 is stdin
call fget                           ;Call fget to read a string from stdin
;---------------------------------------------------------------------------------------------------

;--------------- Validate string as float ----------------------------------------------------------
mov rax, 0                          ;Clear rax
mov rdi, floatnumber                ;Address of string
call isfloat                        ;Call isfloat to validate the string as a float
;rax holds 0 if test fails, non-zero if test passes
;---------------------------------------------------------------------------------------------------

;---------------
cmp rax, 0                           ;Did the test fail?
je failed                            ;Jump if test failed
;--------------- handle valid input ----------------------------------------------------------
mov rax, 0
mov rdi, floatnumber
call atof                            ;Places converted float into rax
push rax                             ;Push the float onto the stack
movsd xmm15, [esp]                   ;Move the float from the stack into xmm15
pop rax                              ;Pop the stack
jmp continue
;---------------------------------------------------------------------------------------------------
;--------------- If test Failed ----------------------------------------------------------------
failed:
    mov rax, 0
    mov rdi, tryagainmessage
    call printf
    jmp begin
;---------------------------------------------------------------------------------------------------

continue:
movsd xmm0, xmm15                   ; move result into ABI return register
restore                             ;<==This macro restores all general purpose registers.
ret