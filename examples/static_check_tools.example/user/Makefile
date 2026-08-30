TOP_DIR := $(realpath ../..)

STATIC_CHECK_BIN := $(TOP_DIR)/../static_check_tools/build/bin


SRC := main.c


.PHONY: all cppcheck flawfinder sparse clean


all:
	gcc -Wall $(SRC) -o test


cppcheck:
	$(STATIC_CHECK_BIN)/cppcheck \
		--enable=all \
		--std=c11 \
		$(SRC)


flawfinder:
	$(STATIC_CHECK_BIN)/flawfinder \
		$(SRC)


sparse:
	$(STATIC_CHECK_BIN)/sparse \
		$(SRC)


clean:
	rm -f test
