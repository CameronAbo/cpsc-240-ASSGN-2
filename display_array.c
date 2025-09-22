// ;******************************************************************************************************************
// ;Copyright (C) 2020 Floyd Holliday                                                                                *
// ;                                                                                                                 *
// ;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public*
// ;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it *
// ;will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  *
// ;PARTICULAR PURPOSE.  See the GNU General Public License for more details.  A copy of the GNU General Public      *
// ;License v3 is available here:  <https://www.gnu.org/licenses/>.                                                  *
// ;******************************************************************************************************************


// ;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2
// ;
// ;Author information
// ;  Author name: Cameron Abo
// ;  Author email: cabo0@csu.fullerton.edu
// ;
// ;Program information
// ;  Program name: Assignment 2 Array magnitudement
// ;  Programming environment: Visual Studio Code, gcc 9.4.0, nasm
// ;  Programming languages:  2 module in C and 5 modules in X86
// ;  Date program began:     2025-Sep-21
// ;  Date program completed: 2025-Sep-21
// ;  Date comments upgraded: 2025-Sep-21
// ;  Files in this program: main.c, display_array.c, manager.asm, input_array.asm, mean.asm, magnitude.asm, append.asm
// ;  Status: Complete.
// ;
// ;References for this program
// ;  X86-64 Assembly Language Programming with Ubuntu
// ;
// ;Purpose (academic)
// ;  Store and manipulate the elements of two arrays of double-precision floating point numbers.
// ;
// ;This file
// ;   File name: display_array.c
// ;   Language: i-series microprocessor assembly
// ;   Syntax: Intel
// ;   Max page width: 116 columns
// ;   Compile: gcc -c -m64 -Wall -fno-pie -no-pie -o main.o main.c -std=c17
// ;   Link: gcc -m64 -no-pie -o arr.out -std=c17 main.o display.o manage.o input.o isfloat.o mean.o magnitude.o append.o #-fno-pie -no-pie 
// ;   Reference regarding -no-pie: Jorgensen, page 226.
// ;
// ;===== Begin code area ================================================================================================

#include "stdio.h"

void display_array(double array[], size_t size){
    size_t i = 0;
    for(i = 0; i < size; i++){
        printf("%1.5f\t", array[i]);
    }
    printf("\n");
    return;

}

// End of display_array