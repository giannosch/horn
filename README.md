# HORN

Higher-Order Reasoning with Negation

## Installation

1. Install Crystal and Shards. See [here](https://crystal-lang.org/install/).
2. Install [tree-sitter](https://github.com/tree-sitter/tree-sitter):
    - On ubuntu: `apt install libtree-sitter-dev`
    - On macOS: `brew install tree-sitter`
3. Run `make`.

## Usage

```
$ cat spec/fixtures/program.horn
a,b :: i. p :: i->o. r :: o.
p(a).
r :- ]X:i ~(p X).

?- r.
$ ./bin/horn -f spec/fixtures/program.horn
r => T
```

## Contributors

- [Giannos Chatziagapis](https://github.com/giannosch) - creator and maintainer
