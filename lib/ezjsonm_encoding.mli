(* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. *)

(** An encoding combinators library for [Ezjsonm] whose API, heavily inspired
    by [data-encoding].

    The two main differences between [ezjsonm-encoding] and the JSON support of
    data-encoding are:

    {ul
      {li [objN] combinators accept JSON objects with _more_ fields than the one
          explicitely specified in the encoding.}
      {li [ezjsonm-encoding] does not have a dependency to [Zarith] (which
          depends on GMP). As a consequence, `ezjsonm-encoding` does not
          provide support for big numbers out of the box.}}

    The examples of this documentation can be copy/pasted to an OCaml REPL. *)

type 'a t
(** A JSON encoding combinator for a value of type ['a]. *)

val to_value_exn : 'a t -> 'a -> Ezjsonm.value
(** [to_value_exn encoding value] encodes [value] in JSON using [encoding].
    Will raise an exception in case [encoding] cannot serialize [value].

    {[
      open Ezjsonm_encoding

      let encoding = obj1 (req "hello" string)

      let json = to_value_exn encoding "world"
        (* `O [("hello", `String "world")] *)
    ]} *)

val to_value : 'a t -> 'a -> Ezjsonm.value option
(** [to_value_exn encoding value] encodes [value] in JSON using [encoding]. Will
    return [None] in case [encoding] cannot serialize [value]. *)

val to_string_exn : minify:bool -> 'a t -> 'a -> string
(** [to_string_exn ~minify encoding value] encodes [value] using [encoding] into a
    JSON value serialized in a string. Will raise an exception in case [encoding]
    cannot serialize [value]. *)

val to_string : minify:bool -> 'a t -> 'a -> string option
(** [to_string ~minify encoding value] encodes [value] using [encoding] into a JSON
    value serialized in a string. Will return [None] in case [encoding] cannot
    serialize [value]. *)

val from_string_exn : 'a t -> string -> 'a
(** [from_string_exn encoding str] decodes a JSON value from [str], then uses
    [encoding] to construct an OCaml value. Will raise an exception if [str] is
    not a valid JSON value, or if [encoding] cannot construct an OCaml value from
    [str]. *)

val from_string : 'a t -> string -> 'a option
(** [from_string encoding str] decodes a JSON value from [str], then uses
    [encoding] to construct an OCaml value. Will return [None] if [str] is not a
    valid JSON value, or if [encoding] cannot construct an OCaml value from
    [str]. *)

val from_value_exn : 'a t -> Ezjsonm.value -> 'a
(** [from_value_exn encoding value] uses [encoding] to construct an OCaml
    value from [value]. Will raise an exception if [encoding] cannot construct
    an OCaml value from [value]. *)

val from_value : 'a t -> Ezjsonm.value -> 'a option
(** [from_string encoding str] decodes a JSON value from [str], then uses
    [encoding] to construct an OCaml value. Will return [None] if [str] is not a
    valid JSON value, or if [encoding] cannot construct an OCaml value from
    [str]. *)

val conv : ('a -> 'b) -> ('b -> 'a) -> 'b t -> 'a t
(** [conv f g encoding] crafts a new encoding from [encoding]. This is
    typically used to creates a JSON encoder/decoder for OCaml records by
    projecting them to tuples, and using [objN] combinators.

    {[
      open Ezjsonm_encoding

      type t = { f1 : int; f2 : bool }

      let encoding =
        conv
          (fun { f1; f2 } -> (f1, f2))
          (fun (f1, f2) -> { f1; f2 })
          (obj2 (req "f1" int) (req "f2" bool))

      let json = to_value_exn encoding { f1 = 0; f2 = true }
        (* `O [("f2", `Bool true); ("f1", `Float 0.)] *)
    ]} *)

val string_enum : (string * 'a) list -> 'a t
(** [string_enum] maps JSON strings to fixed OCaml values.

    {[
      open Ezjsonm_encoding

      type toggle = On | Off

      let toggle_encoding = string_enum [ "on", On; "off", Off ]

      let json = to_value_exn toggle_encoding On
        (* `String "on" *)

      let toggle = from_string_exn toggle_encoding {|"on"|}
        (* On *)
    ]} *)

val string : string t
(** The encoding which maps JSON strings and OCaml strings.

    {[
      open Ezjsonm_encoding

      let json = to_value_exn string "hello, world!"
        (* `String "hello, world!" *)

      let str = from_string_exn string {|"hello, world!"|}
        (* "hello, world!" *)
    ]} *)

val int64 : int64 t
(** The encoding which maps JSON ints and OCaml int64. As a reminder,
    Ezjsonm uses floats internally to encode integers.

    {[
      open Ezjsonm_encoding

      let json = to_value_exn int64 1L
        (* `Float 1. *)

      let str = from_string_exn int64 "1"
        (* 1L *)
    ]} *)

val int : int t
(** The encoding which maps JSON ints and OCaml ints. As a reminder, Ezjsonm uses
    floats internally to encode integers.

    {[
      open Ezjsonm_encoding

      let json = to_value_exn int 1
        (* `Float 1. *)

      let str = from_string_exn int "1"
        (* 1 *)
    ]} *)

val bool : bool t
(** The encoding which maps JSON booleans and OCaml booleans.

    {[
      open Ezjsonm_encoding

      let json = to_value_exn bool false
        (* `Bool false *)

      let str = from_string_exn bool "false"
        (* false *)
    ]} *)

val list : 'a t -> 'a list t
(** [list encoding] creates a encoding for a list of values based on the
    encoding of said values.

    {[
      open Ezjsonm_encoding

      let json = to_value_exn (list bool) [true; true; false]
        (* `A [`Bool true; `Bool true; `Bool false] *)

      let str = from_string_exn (list int) "[1, 2, 3]"
        (* [1; 2; 3] *)
    ]}
    *)

type 'a field
(** The description of one field of a JSON object. See {!req} and {!opt} to
    construct [field] values, and {!obj1} to {!obj10} and {!merge_objs} to
    construct encoding for objects. *)

val req : string -> 'a t -> 'a field
(** [req field_name encoding] represents a {i required} field. That is,
    the decoding will fail if provided an object lacking this field (and raises an exepction with {!from_string_exn} and
    {!from_string_exn}).

    {[
      open Ezjsonm_encoding

      let json = to_value_exn (obj1 (req "hello" string)) "world!"
        (* `O [("hello", `String "world!")] *)

      let str = from_string_exn (obj1 (req "hello" string)) {|{ "hello": "world!"}|}
        (* "world!" *)

      let str = from_string (obj1 (req "hello" string)) {|{ "bye": "world!"}|}
        (* None *)
    ]} *)

val opt : string -> 'a t -> 'a option field
(** [opt field_name encoding] represents an {i optional} field ({i i.e.}, wrapped
    in an [option]).

    {[
      open Ezjsonm_encoding

      let json = to_value_exn (obj1 (opt "hello" string)) (Some "world!")
        (* `O [("hello", `String "world!")] *)

      let json' = to_value_exn (obj1 (opt "hello" string)) None
        (* `O [] *)

      let str = from_string_exn (obj1 (opt "hello" string)) {|{ "hello": "world!"}|}
        (* Some "world!" *)

      let str = from_string (obj1 (opt "hello" string)) {|{ "bye": "world!"}|}
        (* Some None *)
    ]} *)

val obj1 : 'a field -> 'a t
(** [obj1 f] represents an object characterized by {i at least} the field [f].
    This field can be optional or required depending on how it has been defined
    (see {!req} and {!opt}). *)

val obj2 : 'a field -> 'b field -> ('a * 'b) t
(** [obj2 f1 f2] represents an object characterized by {i at least} the fields passed
    as arguments. They can be optional or required depending on how they have
    been defined (see {!req} and {!opt}). *)

val obj3 : 'a field -> 'b field -> 'c field -> ('a * 'b * 'c) t
(** [obj3 f1 f2 f3] represents an object characterized by {i at least} the
    fields passed as arguments. They can be optional or required depending on
    how they have been defined (see {!req} and {!opt}). *)

val obj4 : 'a field -> 'b field -> 'c field -> 'd field -> ('a * 'b * 'c * 'd) t
(** [obj4 f1 f2 f3 f4] represents an object characterized by {i at least} the
    fields passed as arguments. They can be optional or required depending on
    how they have been defined (see {!req} and {!opt}). *)

val obj5 :
  'a field ->
  'b field ->
  'c field ->
  'd field ->
  'e field ->
  ('a * 'b * 'c * 'd * 'e) t
(** [obj5 f1 f2 f3 f4 f5] represents an object characterized by {i at least}
    the fields passed as arguments. They can be optional or required depending
    on how they have been defined (see {!req} and {!opt}). *)

val obj6 :
  'a field ->
  'b field ->
  'c field ->
  'd field ->
  'e field ->
  'f field ->
  ('a * 'b * 'c * 'd * 'e * 'f) t
(** [obj6 f1 f2 f3 f4 f5 f6] represents an object characterized by {i at least}
    the fields passed as arguments. They can be optional or required depending
    on how they have been defined (see {!req} and {!opt}). *)

val obj7 :
  'a field ->
  'b field ->
  'c field ->
  'd field ->
  'e field ->
  'f field ->
  'g field ->
  ('a * 'b * 'c * 'd * 'e * 'f * 'g) t
(** [obj7 f1 f2 f3 f4 f5 f6 f7] represents an object characterized by {i at
    least} the fields passed as arguments. They can be optional or required
    depending on how they have been defined (see {!req} and {!opt}). *)

val obj8 :
  'a field ->
  'b field ->
  'c field ->
  'd field ->
  'e field ->
  'f field ->
  'g field ->
  'h field ->
  ('a * 'b * 'c * 'd * 'e * 'f * 'g * 'h) t
(** [obj8 f1 f2 f3 f4 f5 f6 f7 f8] represents an object characterized by {i at
    least} the fields passed as arguments. They can be optional or required
    depending on how they have been defined (see {!req} and {!opt}). *)

val obj9 :
  'a field ->
  'b field ->
  'c field ->
  'd field ->
  'e field ->
  'f field ->
  'g field ->
  'h field ->
  'i field ->
  ('a * 'b * 'c * 'd * 'e * 'f * 'g * 'h * 'i) t
(** [obj9 f1 f2 f3 f4 f5 f6 f7 f8 f9] represents an object characterized by {i
    at least} the fields passed as arguments. They can be optional or required
    depending on how they have been defined (see {!req} and {!opt}). *)

val obj10 :
  'a field ->
  'b field ->
  'c field ->
  'd field ->
  'e field ->
  'f field ->
  'g field ->
  'h field ->
  'i field ->
  'j field ->
  ('a * 'b * 'c * 'd * 'e * 'f * 'g * 'h * 'i * 'j) t
(** [obj10 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10] represents an object characterized
    by {i at least} the fields passed as arguments. They can be optional or
    required depending on how they have been defined (see {!req} and {!opt}).
    *)

val merge_objs : 'a t -> 'b t -> ('a * 'b) t
(** [merg_objs obj1 obj2] represents an object characterized by {i at least}
    the fields of [obj1] and [obj2]. This is useful when an object expects at
    least more than 10 fields. Note that it is expected that [obj1] and [obj2]
    do not have conflict wrt. field names. This is not checked by [ezjsonm-encoding],
    and is considered an undefined behavior (which may change in a future
    version of the library).

    {[
      open Ezjsonm_encoding

      let json =
        to_value_exn
          (merge_objs
             (obj2 (req "foo" string) (req "bar" bool))
             (obj1 (opt "foobar" int)))
          (("hello", true), Some 1)
        (* `O [("bar", `Bool true); ("foo", `String "hello"); ("foobar", `Float 1.)] *)
    ]} *)

module Decoding : sig
  type 'a encoding = 'a t

  type 'a t
  (** A JSON decoder. Compared to an [encoding], this type provides the {!mu}
      combinator, and a monadic DSL to write decoder. See the {!Syntax} module.
      *)

  val from_encoding : 'a encoding -> 'a t
  (** [from_encoding] specializes an Ezjsonmer encoding to be a decoder. *)

  val from_string : 'a t -> string -> 'a option
  (** [from_string enc input] interprets [input] as a serialized Json
      value, then uses [enc] to decode it into an OCaml value, if
      possible. It returns [None] in case of error. *)

  val from_string_exn : 'a t -> string -> 'a
  (** Same as [from_string], but raises exceptions in case of error. *)

  val from_value : 'a t -> Ezjsonm.value -> 'a option
  (** [from_value enc value] uses [enc] to decode [value] into an OCaml value,
      if possible. It returns [None] in case of error. *)

  val from_value_exn : 'a t -> Ezjsonm.value -> 'a
  (** Same as [from_value], but raises exceptions in case of error. *)

  (** This modules provides a monadic interface to compose existing
      decoders together. *)
  module Syntax : sig
    val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
    (** The [bind] operator. *)

    val ( let+ ) : 'a t -> ('a -> 'b) -> 'b t
    (** The [map] operator. *)

    val ( and+ ) : 'a t -> 'b t -> ('a * 'b) t

    val return : 'a -> 'a t
    (** [return x] is the decoder that ignores the input Json value, and
        always return [x]. *)
  end

  val field : string -> 'a t -> 'a t
  (** [field name dec] decodes the input Json as an object which
      contains at least one property whose name is [name], and whose
      value can be decoded with [dec]. The resulting OCaml value is
      returned as-is.

      [field] is typically used to read from several property of an
      object, which can later be composed together.

      {[
        let tup2 dl dr =
          let open Ezjsonm_encoding.Decoding in
          let open Syntax in
          let+ x = field "0" dl
          and+ y = field "1" dr in
          (x, y)
      ]}

      The decoding will fail in the input Json value does not have a
      property [name]. *)

  val field_opt : string -> 'a t -> 'a option t
  (** Same as {!val-field}, but the the decoding will not fail if the input
      Json value does not have the expected property. In that case,
      [None] is returned. *)

  val list : 'a t -> 'a list t
  (** [list enc] decodes the input Json value as a list of values which
      can be decoded using [enc].  *)

  val string : string t
  (** [string] decodes the input Json value as a string. *)

  val int64 : int64 t
  (** [int64] decodes the input Json value as an 64-byte integer. *)

  val bool : bool t
  (** [bool] decodes the input Json value as a boolean. *)

  val float : float t
  (** [float] decodes the input Json value as a float. *)

  val string_enum : (string * 'a) list -> 'a t
  (** [string_enum l] decodes the input Json value as a string, then
      compare said string with the values contained in the associated
      list [l], to return the OCaml value associated to that string. *)

  val mu : ('a t -> 'a t) -> 'a t
  (** [mu] is a combinator that lets you write a recursive decoder,
    without having to write a recursive function. For instance, if [mu]
    can be used to manipulate tree-like structures.

    {[
      open Ezjsonm_encoding.Decoding

      type tree = { value : int64; children : tree list }

      let decoder =
        let open Syntax in
        mu (fun tree_decoder ->
            let+ value = field "value" int64
            and+ children = field "children" @@ list tree_decoder in
            { value; children })

      let leaf = of_string_exn decoder {|{ "value": 3 , "children" : [] }|}
        (* { value = 3L; children = [] } *)

      let tree = of_string_exn decoder {|{ "value": 3 , "children" : [ { "value": 5, "children": [] } ] }|}
        (* { value = 3L; children = [{ value = 5L; children = [] }] } *)
    ]} *)
end
