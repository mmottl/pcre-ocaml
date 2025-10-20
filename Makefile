.PHONY: all clean doc

all:
	@dune build @install
	@make -C lib compile_commands.json

test: all
	@dune build @install @runtest

clean:
	@dune clean
	@make -C lib clean-compile-commands

doc:
	@dune build @doc
