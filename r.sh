#!/bin/bash

#Program: Array Management
#Author: F. Holliday

#Delete some un-needed files
rm *.o
rm *.out

echo "Bash: The script file for Array Management has begun"

echo "Bash: Compile the main function" 
gcc -c -m64 -Wall -fno-pie -no-pie -o director.o director.c -std=c17
#References regarding "-no-pie" see Jorgensen, page 226.

echo "Bash: Assemble supervisor.asm"
nasm -f elf64 -o super.o supervisor.asm

echo "Bash: Compile input_array.c"
gcc -c -m64 -Wall -fno-pie -no-pie -o input.o input_array.c -std=c17

echo "Bash: Assemble output_array.asm"
nasm -f elf64 -o output.o output_array.asm

echo "Bash: Link the object files"
gcc -m64 -no-pie -o arr.out -std=c17 director.o super.o input.o output.o #-fno-pie -no-pie

echo "Bash: Run the program Integer Arithmetic:"
./arr.out

echo "The script file will terminate"

