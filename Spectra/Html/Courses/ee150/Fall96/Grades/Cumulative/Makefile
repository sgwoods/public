#
# UNIX makefile for CHAPTER 7: ARRAYS
#
CHAPTER		= CHAP7
#
# Standard changeable MAKE parameters:
#
#   CC 		  - path name/options of ANSI C compile only
#   CFLAGS        - additional C compiler options
#   COMP_ONLY_OPT - flag to compile only
#   EXEC_NAME_OPT - flag to rename executable
#   LINT	  - style check program
#   LINT_FLAGS    - style check options
#
# Values below are set up for standard UNIX distribution.
#
CFLAGS		= -ansi
CC 		= gcc $(CFLAGS)  
COMP_ONLY_OPT	= -c
EXEC_NAME_OPT	= -o
LINT		= lint
LINT_FLAGS	= -Aa

FILE_REMOVER	= rm -f
FILE_MOVER      = mv
#
# Standard default compilation rules (should already be there):
#
.c.o:
	$(CC) $(COMP_ONLY_OPT) $<

.c:
	$(CC) $(EXEC_NAME_OPT)$* $<
#
# Tasks that can be invoked:
#   all - make a complete set of executables
#   empty - remove everything except the original source/header files
#   clean - remove all object modules and standard backup files
#   save - move all the executables to a separate directory
#   lint - check program style
#
EXECS = revint revint2 usetable isort histo

all:	$(EXECS)

empty:  clean
	$(FILE_REMOVER) $(EXECS)

clean:  
	$(FILE_REMOVER) *.o

save:   
	$(FILE_MOVER) $(EXECS) ../../EXECS/$(CHAPTER)
#
# Object modules and executables:
#
#   - program to fill up a table and then search for values
#
USETABLE_OBJS = usetable.o tabsent.o tabsrch.o
USETABLE_SRCS = usetable.c tabsent.c tabsrch.c

usetable:	$(USETABLE_OBJS)
		$(CC) $(EXEC_NAME_OPT)$@ $(USETABLE_OBJS)
#
#   - histogram program
#
HISTO_OBJS =    histo.o histoout.o utils.o
HISTO_SRCS =    histo.c histoout.c utils.c

histo:		$(HISTO_OBJS)
		$(CC) $(EXEC_NAME_OPT)$@ $(HISTO_OBJS)

lint:
	$(LINT) $(LINT_FLAGS) revint.c
	$(LINT) $(LINT_FLAGS) revint2.c
	$(LINT) $(LINT_FLAGS) isort.c
	$(LINT) $(LINT_FLAGS) $(USETABLE_SRCS)
	$(LINT) $(LINT_FLAGS) $(HISTO_SRCS)
