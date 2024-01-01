OCAML_COMPILER ?= ocaml-system
BUILD_PROFILE ?= release
PKG := ezjsonm-encoding

.PHONY: build-deps
build-deps: _opam/.created
	@opam update
	@opam pin ${PKG} . --no-action -y
	@opam install ${PKG} --deps-only -y

.PHONY: build-dev-deps
build-dev-deps: _opam/.created
	@opam update
	@opam pin ${PKG} . --no-action -y
	@opam pin ${PKG}-dev . --no-action -y
	@opam install ${PKG} ${PKG}-dev --deps-only -y

_opam/.created:
	@opam switch create . --no-install --packages "${OCAML_COMPILER}" --deps-only -y || true
	@touch $@
