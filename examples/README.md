# Examples

## `cloc`

This program reads C source code from `stdin` and outputs it to `stdout`
with comments and empty lines removed. It's useful for counting lines of code.

## `count_hash`

This program reads text from `stdin`, counts occurrences of identical words
separated by whitespace, and prints the result to `stdout`.

## `pcregrep`

A grep-like program using Perl-compatible regular expressions. Start the
program with the `-help` argument to see its functionality.

## `subst`

Substitutes text in files using Perl-compatible regular expressions and
substitution patterns. Start the program with the `-help` argument to see
its functionality.

Example invocation:

```sh
subst '([Tt])ermcap' '$1ermCap' < /etc/termcap
```

## `dfa_restart`

Tests the DFA matching function and its partial match restart capability.
Given a pattern, it accepts input incrementally, restarting the prior
partial match until the pattern either succeeds or fails.

Example interaction:

```sh
$ dfa_restart.exe 'abc12+3'
> abc
partial match, provide more input:
> 122222
partial match, provide more input:
> 222
partial match, provide more input:
> 3
match completed: "[|0;1;0|]"
```
