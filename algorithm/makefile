CC = gcc
CFLAGE = -std=c99 -g -Wall

all: Tarjan.o
	${CC} ${CFLAGE} -o testp Tarjan.o
Tarjan.o: Tarjan.c Status.h
	${CC} ${CFLAGE} -c Tarjan.c
clean:
	rm *.o testp
