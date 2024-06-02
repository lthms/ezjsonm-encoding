(lang dune 3.0)
(name ezjsonm-encoding)

(generate_opam_files true)

(source
 (github lthms/ezjsonm-encoding))

(license mpl-2.0)

(authors "Thomas Letan <lthms@soap.coffee>")

(maintainers "Thomas Letan <lthms@soap.coffee>")

(version 2.1.0)

(package
 (name ezjsonm-encoding)
 (synopsis
  "Encoding combinators a la Data_encoding for Ezjsonm")
 (depends (ocaml (>= "4.8.0")) (ezjsonm (>= "1.2.0"))))

(package
 (allow_empty)
 (name ezjsonm-encoding-dev)
 (synopsis
  "Virtual package gathering development dependencies for hacking the ezjsonm-encoding library")
 (depends
  dune-release
  ocaml-lsp-server
  odoc
  utop
  (ocamlformat
   (= 0.26.1))))
