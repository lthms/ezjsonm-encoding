# 2.1.0 (2024-08-18)

- Add the `constant` combinator, typically used to tag objects.
- Add the `null` combinator.
- Add `obj0` (matches any object) and `empty` (matches the empty object)
  combinators.
- Add the `union` combinator.
- Add the `dft` field combinator.
- Add the `json` combinator.
- Add the `enum` combinator.
- Add the `satisfies` combinator.
- Add the `tupN` combinators family (`tup1` to `tup10`).

# 2.0.0 (2024-01-12)

- Rename `Decoding.of_string` into `Decoding.from_string` for consistency with
  top-module.
- Rename `Decoding.of_string_exn` into `Decoding.from_string_exn` for
  consistency with top-module.
- Add `Decoding.from_value_exn` and `Decoding.from_value`.
- Add `from_value_exn` and `from_value`.

# 1.0.0 (2024-01-01)

Extract the `jsoner` private library from the [Spatial Shell
repository](https://github.com/lthms/spatial-shell) and turn it into
a standalone library named `ezjsonm-encoding`.
