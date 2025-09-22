#!/bin/bash

#Program: Array Management
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out

echo "Bash: The script file for Array Management has begun"

echo "Bash: Compile the main function" 
gcc -c -m64 -Wall -fno-pie -no-pie -o main.o main.c -std=c17
#References regarding "-no-pie" see Jorgensen, page 226.

echo "Bash: Compile the display_array function" 
gcc -c -m64 -Wall -fno-pie -no-pie -o display.o display_array.c -std=c17

echo "Bash: Assemble manager.asm"
nasm -f elf64 -o manage.o manager.asm

echo "Bash: Assemble input_array.asm"
nasm -f elf64 -o input.o input_array.asm

echo "Bash: Assemble isfloat.asm"
nasm -f elf64 -o isfloat.o isfloat.asm

echo "Bash: Link the object files"
gcc -m64 -no-pie -o arr.out -std=c17 main.o display.o manage.o input.o isfloat.o #-fno-pie -no-pie

echo "Bash: Run the program Integer Arithmetic:"
./arr.out

echo "The script file will terminate"

