OCAMLMAKEFILE = ../OCamlMakefile

SOURCES      := pcre.mli pcre.ml pcre_stubs.c
CFLAGS       := -O2 $(shell pcre-config --cflags)
OCAMLLDFLAGS := -cclib "$(shell pcre-config --libs)"
RESULT       := pcre

all:

install: libinstall
uninstall: libuninstall

-include $(OCAMLMAKEFILE)
