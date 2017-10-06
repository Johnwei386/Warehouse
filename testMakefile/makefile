include in.mk

usage:
	@echo " " >&2 
	@echo "make built 用来构建目标程序" >&2
	@echo "make clean 用来清除已编译的程序" >&2
	@echo " " >&2

built: main.o
	cd dom1 && ${MAKE}
	cd dom2 && ${MAKE}
	cd bin && ${CC} ${CFLAGS} -o testp *.o

main.o: main.c Status.h Ceshi.h
	mkdir bin
	${CC} ${CFLAGS} -c -o bin/main.o main.c

clean:
	rm -rf bin
