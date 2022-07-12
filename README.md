# clp

clp writes input files to stdout with syntax highlighting.
It aims to be relatively fast, provide wide language support, and be easy
to extend with new languages. It currently supports over 140 languages.

Language support is implemented with LPEG, a tool developed by PUC which uses
parsing expression grammars to improve upon traditional regex parsers
(described in depth in [this article](http://www.inf.puc-rio.br/~roberto/docs/peg.pdf)).

## Installation

```
$ ./configure
$ make
# make install
```

## Usage

```
$ clp [-t FILETYPE] filename
```
