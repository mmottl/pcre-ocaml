PCRE-OCaml - Perl Compatibility Regular Expressions for OCaml
=============================================================

---------------------------------------------------------------------------

What is PCRE-OCaml?
-------------------

This [OCaml](http://www.ocaml.org)-library interfaces the C-library
[PCRE](http://www.pcre.org) (Perl-compatibility Regular Expressions).  It can
be used for matching regular expressions which are written in "PERL"-style.

### Features

PCRE-OCaml offers the following functionality for operating on strings:

  * Searching for patterns
  * Extracting subpatterns
  * Splitting strings according to patterns
  * Pattern substitution

Other reasons to use PCRE-OCaml:

  * The PCRE-library by Philip Hazel has been under development for many
    years and is fairly advanced and stable.  It implements just about all
    of the functionality that can be found in PERL regular expressions.
    The higher-level functions written in OCaml (split, replace, etc.),
    too, are compatible with the corresponding PERL-functions to the extent
    that OCaml allows.  Most people find the syntax of PERL-style regular
    expressions more straightforward and powerful than the Emacs-style regular
    expressions used in the `Str`-module in the standard OCaml distribution.

  * PCRE-OCaml is reentrant and thus thread-safe, which is not the case
    for the `Str`-module in the OCaml standard library.  Using reentrant
    libraries also means more convenience for programmers.  They do not
    have to reason about states in which the library might be in.

  * The high-level functions for replacement and substitution, which are all
    implemented in OCaml, are much faster than the ones in the `Str`-module.
    In fact, when compiled to native code, they even seem to be significantly
    faster than those found in PERL (PERL is written in C).

  * You can rely on the data returned being unique.  In other terms: if
    the result of a function is a string, you can safely use destructive
    updates on it without having to fear side effects.

  * The interface to the library makes use of labels and default arguments
    to give you a high degree of programming comfort.

### Usage

The API-documentation which is built and installed with PCRE-OCaml explains all
functions, most of which are fairly straightforward to understand, in detail.
It can also be found [online](http://mmottl.github.io/pcre-ocaml/api).

A general concept the user may need to understand is that most functions
allow for two different kinds of flags:

  1. "Convenience"-flags that make for readable and concise code, but which
     need to be translated to an internal representation on each call.
     Example:

     ```ocaml
     let rex = regexp ~flags:[`ANCHORED; `CASELESS] "some pattern" in
     (* ... *)
     ```

     This makes it easy to pass flags on the fly.  They will be translated to
     the internal format automatically.  However, if this happens to be in a
     loop, this translation will occur on each iteration.  If you really need
     to save as much performance as possible, you should use the next approach.

  2. "Internal" flags that need to be defined and translated from
     "convenience"-flags before function calls, but which allow for optimum
     performance in loops.  Example:

     ```ocaml
     let iflags = cflags [`ANCHORED; `CASELESS] in
     for i = 1 to 1000 do
       let rex = regexp ~iflags "some pattern constructed at runtime" in
       (* ... *)
     done
     ```

      Factoring out the translation of flags for regular expressions may
      save some cycles, but don't expect too much.  You can save more CPU
      time when lifting the creation of regular expressions out of loops.
      Example for what not to do:

      ```ocaml
      for i = 1 to 1000 do
        let chunks = split ~pat:"[ \t]+" "foo bar" in
        (* ... *)
      done
      ```

      Better:

      ```ocaml
      let rex = regexp "[ \t]+" in
      for i = 1 to 1000 do
        let chunks = split ~rex "foo bar" in
        (* ... *)
      done
      ```

The provided functions use optional arguments with intuitive defaults.
For example, the `split`-function will assume whitespace as pattern.

Take a look at the interface file `pcre.mli` to see which ways exists to pass
parameters and to learn about the defaults.  The `examples`-directory contains
a few example applications demonstrating the functionality of PCRE-OCaml.

---------------------------------------------------------------------------

Contact Information and Contributing
------------------------------------

In the case of bugs, feature requests, contributions and similar, you can
contact me here: <markus.mottl@gmail.com>

Up-to-date information should be available at:
<http://mmottl.github.io/pcre-ocaml>

Enjoy!

Markus Mottl on July 10, 2012
