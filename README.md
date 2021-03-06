# clp

clp writes input files to stdout with syntax highlighting.
It aims to be relatively fast, provide wide language support, and be easy
to extend with new languages. It currently supports 150 languages.

Language support is implemented with LPEG, a tool developed by PUC which uses
parsing expression grammars to improve upon traditional regex parsers
(described in depth in [this article](http://www.inf.puc-rio.br/~roberto/docs/peg.pdf)).

## Installation

### Homebrew

```
brew tap jpe90/clp
brew install clp
```

### Building from source
Requirements:

- a POSIX compliant operating system
- a C99 Compiler
- Lua >= 5.1 or LuaJIT (the latter for better performance)
- [LPEG](http://www.inf.puc-rio.br/~roberto/lpeg/)
```
$ ./configure
$ make
# make install
```

## Usage

```
$ clp [options] filename
```

#### -t, --override-filetype {filetype}

Force a language's syntax for highlighting the file. To see available filetypes, run clp --list-overrides

#### -h, --highlight-line {number}

Highlight a non-blank line

## Motivation

clp runs faster than other command line syntax highlighting programs. When used
as a previewer for a fuzzy finder in a project with large source files, it can
make a very perceptible difference. Quick benchmarks on my machine (clp
installed with LuaJIT, highlighting
[sqlite3.c](https://fossies.org/linux/sqlite/sqlite3.c))

```
time clp sqlite3.c > /dev/null                   # 276.75 millis
time bat --color=always -p sqlite3.c > /dev/null # 3.06 secs
time source-highlight sqlite3.c > /dev/null      # 4.71 secs
```

Parsers are upstreamed from the
[Scintillua](https://orbitalquark.github.io/scintillua/) project. It's actively
maintained, has great support even for niche languages, and easy to use
relative to other syntax definition mechanisms.

## Contributing

Contributions are welcome! Feel free to send a pull request on [Github](https://github.com/jpe90/clp)
or a patch on [Sourcehut](https://git.sr.ht/~eskin/clp).

Here are some things that would be especially helpful:

- Better interface for customizing color themes
- Bugfixes
- Code quality & performance improvements
