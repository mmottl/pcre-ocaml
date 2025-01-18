NOT_OCAMLFIND=not-ocamlfind

bootstrap: ../test/pcre_tests.ml

../test/%.ml: %.ml
	$(NOT_OCAMLFIND) preprocess \
		-package pa_ppx_regexp,camlp5.pr_o -ppopt -pa_ppx_regexp-nostatic \
		-syntax camlp5o $< > $@.NEW && \
	mv $@.NEW $@

.SUFFIXES: .ml
