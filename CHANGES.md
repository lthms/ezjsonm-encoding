# 2.1.0 Unreleased

- Add the `constant` combinator, typically used to tag objects.
- Add the `null` combinator.

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
