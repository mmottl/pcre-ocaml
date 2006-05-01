OCAMLMAKEFILE = ../OCamlMakefile

SOURCES   = pcre.mli pcre.ml pcre_stubs.c
CFLAGS    = -O2
CLIBS	  = pcre
RESULT    = pcre

all:

install:	libinstall
uninstall:	libuninstall

clean::	clean-doc

-include $(OCAMLMAKEFILE)
