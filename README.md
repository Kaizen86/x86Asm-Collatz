
# x86 Assembly - Collatz

## What's this?
This is a simple implementation of an algorithm to traverse a Collatz Conjecture with a starting number defined in the source code. Ideally the program would be able to accept user input for an arbitrary starting point, but that would be quite complicated to handle since I need to start really managing memory at that point.

## The Collatz what-now?
The rules for the [Collatz Conjecture](https://en.wikipedia.org/wiki/Collatz_conjecture) are simple:

* Start with a positive integer
* If the number is even, divide it by 2
* If it's odd, multiply it by 3 then add 1
* Repeat until you reach 1

Presently, there is no known number that does not eventually lead to 1. It seems to apply to all natural numbers, up to infinity. That's why it's called a conjecture; there is no known disproof for that yet.

## Ok but why Assembly?
This purpose of this project was to exercise my knowledge of programming in Assembly for Intel CPUs. I hadn't done anything like this before, so it seemed worthwhile to grasp how a program could be expressed as instructions native to the hardware.
This is also practice for programming 6502 processors on a low level, which is something I hope to get into once the [Commander X16](www.commanderx16.com) project enters production.

## Requirements
The following software packages are required to compile the program:

* NASM
* binutils
  * gdb (Used for debugging)
  * ld

Running the `run.sh` build script will run the NASM assembler and linker, then execute the binary automatically.
Supplying the `-d` parameter will attach GDB to the binary for debugging purposes.
