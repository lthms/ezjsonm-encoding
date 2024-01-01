# `ezjsonm-encoding`

`ezjsonm-encoding` is an encoding combinators library for
[Ezjsonm](https://github.com/mirage/ezjsonm) whose API is heavily inspired by
[data-encoding](https://gitlab.com/nomadic-labs/data-encoding/).

The two main differences between `ezjsonm-encoding` and the JSON support of
data-encoding are:

- `objN` combinators accept JSON objects with _more_ fields than the one
  explicitely specified in the encoding.
- `ezjsonm-encoding` does not have a dependency to `Zarith` (which depends on
  GMP). As a consequence, `ezjsonm-encoding` does not provide support for big
  numbers out of the box.

`ezjsonm-encoding` is packaged and build with Dune. A Makefile is provided for
convinience purposes.

```bash
# Install the minimum to build the library
make build-deps
# Install development dependencies as well
make build-dev-deps
```

In both cases, a local switch is created. Use the variable `OCAML_COMPILER` to
control which compiler is installed (defaults to `ocaml-system`).
