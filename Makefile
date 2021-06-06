# the compiler: gcc for C program, define as g++ for C++
ASM = yasm -f elf64 -DYASM -D__x86_64__ -DPIC 
CC = gcc
CPP = g++
# compiler flags:
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
CFLAGS  = -g -Wall 
# the build target executable:
TARGET = libmini.so start.o

all: $(TARGET)

.PHONY: test clean

libmini.so: libmini64.asm libmini.c
	$(ASM) $< -o libmini64.o
	$(CC) -c $(CFLAGS) -fno-stack-protector -fPIC -nostdlib libmini.c
	ld -shared -o $@ libmini64.o libmini.o

start.o: start.asm
	$(ASM) $< -o start.o

test: test.c
	$(CC) -c $(CFLAGS) -fno-stack-protector -nostdlib -I. -I.. -DUSEMINI test.c
	ld -m elf_x86_64 --dynamic-linker /lib64/ld-linux-x86-64.so.2 -o $@ test.o start.o -L. -L.. -lmini

clean:
	$(RM) $(TARGET) *.o test