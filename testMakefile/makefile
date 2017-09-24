INC = /tmp/test/include
INCDIRS = -I${INC}
CFLAGS = -g -Wall ${INCDIRS}
MAKE = make -$(MAKEFLAGS)

usage:
	@echo " " >&2 
	@echo "make built 用来构建目标程序" >&2
	@echo "make clean 用来清除已编译的程序" >&2
	@echo " " >&2

built:
	mkdir bin
	cd dom1 && ${MAKE}
	cd dom2 && ${MAKE}
	cd bin && ${CC} ${CFLAGS} -o testp *.o

clean:
	rm -rf bin
