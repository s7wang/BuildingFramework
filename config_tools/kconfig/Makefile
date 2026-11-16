#
# Standalone Linux Kconfig
#

HOSTCC ?= gcc

RM := rm -f

CFLAGS += -I.
CFLAGS += -I./include
CFLAGS += -DCURSES_LOC=\"ncurses.h\"
CFLAGS += -DYYDEBUG=1


#
# Common objects
#
COMMON_OBJS = \
	confdata.o \
	expr.o \
	lexer.lex.o \
	menu.o \
	parser.tab.o \
	preprocess.o \
	symbol.o \
	util.o

#
# lxdialog objects
#

LXDIALOG_OBJS = \
	lxdialog/checklist.o \
	lxdialog/inputbox.o \
	lxdialog/menubox.o \
	lxdialog/textbox.o \
	lxdialog/util.o \
	lxdialog/yesno.o

#
# targets
#
.PHONY: all clean distclean


all: conf mconf


#
# command line config
#
conf: conf.o $(COMMON_OBJS)
	$(HOSTCC) -o $@ $^



#
# menuconfig
#
MCONF_OBJS = \
	mconf.o \
	mnconf-common.o \
	$(LXDIALOG_OBJS) \
	$(COMMON_OBJS)


mconf: $(MCONF_OBJS)
	$(HOSTCC) -o $@ $^ -lncurses



#
# flex / bison
#
lexer.lex.c: lexer.l
	flex -o $@ $<



parser.tab.c parser.tab.h: parser.y
	bison -d -o parser.tab.c parser.y



#
# object dependencies
#
lexer.lex.o: lexer.lex.c parser.tab.h


parser.tab.o: parser.tab.c parser.tab.h



#
# clean
#
clean:
	@$(RM) *.o
	@$(RM) lxdialog/*.o

	@$(RM) conf
	@$(RM) mconf

#
# remove generated parser files
#
distclean: clean
	$(RM) lexer.lex.c
	$(RM) parser.tab.c
	$(RM) parser.tab.h