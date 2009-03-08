OCAMLMAKEFILE = ../OCamlMakefile

SOURCES := pcre.mli pcre.ml pcre_stubs.c
CFLAGS  := -O2 $(shell pcre-config --cflags)
CLIBS   := $(shell pcre-config --libs | sed -e 's/-l//g')
RESULT  := pcre

all:

install: libinstall
uninstall: libuninstall

clean:: clean-doc

-include $(OCAMLMAKEFILE)
