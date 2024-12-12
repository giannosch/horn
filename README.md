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
r =>
T
$ cat spec/fixtures/equals.horn
a,b :: i.
p :: i->o.
p a.

subset, equals :: (i->o)->(i->o)->o.
subset P Q :- ~]X:i P X /\ ~Q X.
equals P Q :- subset P Q, subset Q P.

?- equals p Q_.
$ ./bin/horn -s dnf -f spec/fixtures/equals.horn
((equals p) Q_) =>
(Q_ a), ¬(Q_ b)
```

## Contributors

- [Giannos Chatziagapis](https://github.com/giannosch) - creator and maintainer
