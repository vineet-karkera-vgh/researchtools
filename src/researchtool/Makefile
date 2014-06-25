CFLAGS = -O
SHELL = /bin/sh
GENERIC_FLAGS =
MEM_DEBUG_FLAGS =
SHELL =	/bin/sh
CC = @CC@
OBJS = 
SRCS = tool.tcl

all: tclsh

tclsh: tclAppInit.o
	${CC} tclAppInit.o -o tclsh

tool: tool.o
	${CC} tool.o -o tool

Makefile: Makefile.in
	$(SHELL) config.status
