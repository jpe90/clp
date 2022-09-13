# clp

clp writes input files to stdout with syntax highlighting. It aims to be relatively fast, provide wide language support, and be easy to extend with new languages. It currently supports 150 languages.

![clpm](https://github.com/jpe90/images/raw/master/clpm.png)

Language support is implemented with LPEG, a tool developed by PUC which uses parsing expression grammars to improve upon traditional regex parsers (described in depth in [this article](http://www.inf.puc-rio.br/~roberto/docs/peg.pdf)).

More information is available [here](https://jeskin.net/blog/clp/), along with a blog post showing [how I use it with fzf](https://jeskin.net/blog/grep-fzf-clp/).

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

#### Distro Specific Dependencies

##### Ubuntu
```
# apt-get install -y build-essential pkg-config libluajit-5.1-dev lua-lpeg
```

##### Arch
```
# pacman -S --needed --noconfirm base-devel pkg-config luajit lua51-lpeg
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

Existing syntax highlighting programs are either relatively slow or support a small number of languages. `clp` aims to be faster without compromising on language support.

Here are some quick benchmarks comparing similar programs running on my machine (clp
installed with LuaJIT, highlighting
[sqlite3.c](https://fossies.org/linux/sqlite/sqlite3.c))

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `clp sqlite3.c` | 216.6 ± 2.4 | 212.2 | 220.8 | 1.00 |
| `bat --color=always sqlite3.c` | 3161.0 ± 12.3 | 3149.7 | 3182.7 | 14.59 ± 0.17 |
| `source-highlight sqlite3.c` | 4313.6 ± 25.5 | 4277.7 | 4355.9 | 19.91 ± 0.25 |

More benchmarks are available [here](https://github.com/sharkdp/bat/blob/master/doc/alternatives.md)

Parsers are upstreamed from the
[Scintillua](https://orbitalquark.github.io/scintillua/) project. It's actively
maintained, has great support even for niche languages, and easy to use
relative to other syntax definition mechanisms.

## Configuration

`clp` can be configured in `~/.config/clp/clprc.lua`:

```lua
clprc = {}
clprc.theme = "ansi-16"
return clprc
```

### Changing your colorscheme

Instructions [available here](https://jeskin.net/blog/clp/#adding-color-themes).

## Contributing

Contributions are welcome! Feel free to send a pull request on [Github](https://github.com/jpe90/clp)
or a patch on [Sourcehut](https://git.sr.ht/~eskin/clp).
