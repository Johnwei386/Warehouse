INC = /root/ProgramPrac/testMakefile/include
INCDIRS = -I ${INC}
CFLAGS = -g -Wall ${INCDIRS}
MAKE = make -$(MAKEFLAGS)
CC = gcc
VPATH = bin:include
