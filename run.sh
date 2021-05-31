#!/bin/bash

# Make output folder if it doesn't exist
[ ! -d "bin" ] && mkdir bin

# Compile main.asm as an elf64 object
nasm -felf64 main.asm -o bin/main.o

if [ $? -eq 0 ]; then # If nasm succeeded...
	# ... then proceed to run the linker on the object file
	ld bin/main.o -o bin/collatz
	# Test for the -d option. This will start the debugger instead of just running the program.
	for argid in $(seq $#)
	do
		if [ ${!argid} == "-d" ]; then
			debug_program=true # The flag is present, make a note of that.
		fi
	done
	if [ "$debug_program" = true ]; then
		gdb bin/collatz
	else
		./bin/collatz
	fi
else
	# However, if nasm failed then just exit.
	echo Compile failed
	exit 1
fi
