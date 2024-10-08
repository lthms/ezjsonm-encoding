(* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. *)

type 'a t = { decoder : 'a Decoder.t; encoder : 'a Encoder.t }

let to_value_exn jsoner value = jsoner.encoder value
let to_value jsoner value = try Some (jsoner.encoder value) with _ -> None

let to_string_exn ~minify jsoner value =
  Ezjsonm.value_to_string ~minify (to_value_exn jsoner value)

let to_string ~minify jsoner value =
  try Some (to_string_exn ~minify jsoner value) with _ -> None

let from_value_exn jsoner value = jsoner.decoder value

let from_value jsoner value =
  try Some (from_value_exn jsoner value) with _ -> None

let from_string_exn jsoner string =
  Ezjsonm.value_from_string string |> from_value_exn jsoner

let from_string jsoner value =
  try Some (from_string_exn jsoner value) with _ -> None

let json = { decoder = Fun.id; encoder = Fun.id }

let conv from_value to_value jsoner =
  {
    decoder = (fun json -> jsoner.decoder json |> to_value);
    encoder = (fun value -> from_value value |> jsoner.encoder);
  }

let string = { decoder = Decoder.string; encoder = Encoder.string }

let string_enum l =
  { encoder = Encoder.string_enum l; decoder = Decoder.string_enum l }

let enum { encoder; decoder } l =
  { encoder = Encoder.enum encoder l; decoder = Decoder.enum decoder l }

let constant c = string_enum [ (c, ()) ]

let list { decoder; encoder } =
  { decoder = Decoder.list decoder; encoder = Encoder.list encoder }

let int64 = { decoder = Decoder.int64; encoder = Encoder.int64 }
let int = { decoder = Decoder.int; encoder = Encoder.int }
let null = { decoder = Decoder.null; encoder = Encoder.null }
let bool = { decoder = Decoder.bool; encoder = Encoder.bool }
let empty = { decoder = Decoder.empty; encoder = Encoder.empty }

let tup1 f1 =
  {
    decoder =
      (function
      | `A [ x ] -> f1.decoder x
      | _ -> raise (Invalid_argument "tup1: expected a list of 1 element"));
    encoder = (fun v -> `A [ f1.encoder v ]);
  }

let tup2 f1 f2 =
  {
    decoder =
      (function
      | `A [ x1; x2 ] -> (f1.decoder x1, f2.decoder x2)
      | _ -> raise (Invalid_argument "tup2: expected a list of 2 elements"));
    encoder = (fun (v1, v2) -> `A [ f1.encoder v1; f2.encoder v2 ]);
  }

let tup3 f1 f2 f3 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3 ] -> (f1.decoder x1, f2.decoder x2, f3.decoder x3)
      | _ -> raise (Invalid_argument "tup3: expected a list of 3 elements"));
    encoder =
      (fun (v1, v2, v3) -> `A [ f1.encoder v1; f2.encoder v2; f3.encoder v3 ]);
  }

let tup4 f1 f2 f3 f4 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3; x4 ] ->
          (f1.decoder x1, f2.decoder x2, f3.decoder x3, f4.decoder x4)
      | _ -> raise (Invalid_argument "tup4: expected a list of 4 elements"));
    encoder =
      (fun (v1, v2, v3, v4) ->
        `A [ f1.encoder v1; f2.encoder v2; f3.encoder v3; f4.encoder v4 ]);
  }

let tup5 f1 f2 f3 f4 f5 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3; x4; x5 ] ->
          ( f1.decoder x1,
            f2.decoder x2,
            f3.decoder x3,
            f4.decoder x4,
            f5.decoder x5 )
      | _ -> raise (Invalid_argument "tup5: expected a list of 5 elements"));
    encoder =
      (fun (v1, v2, v3, v4, v5) ->
        `A
          [
            f1.encoder v1;
            f2.encoder v2;
            f3.encoder v3;
            f4.encoder v4;
            f5.encoder v5;
          ]);
  }

let tup6 f1 f2 f3 f4 f5 f6 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3; x4; x5; x6 ] ->
          ( f1.decoder x1,
            f2.decoder x2,
            f3.decoder x3,
            f4.decoder x4,
            f5.decoder x5,
            f6.decoder x6 )
      | _ -> raise (Invalid_argument "tup6: expected a list of 6 elements"));
    encoder =
      (fun (v1, v2, v3, v4, v5, v6) ->
        `A
          [
            f1.encoder v1;
            f2.encoder v2;
            f3.encoder v3;
            f4.encoder v4;
            f5.encoder v5;
            f6.encoder v6;
          ]);
  }

let tup7 f1 f2 f3 f4 f5 f6 f7 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3; x4; x5; x6; x7 ] ->
          ( f1.decoder x1,
            f2.decoder x2,
            f3.decoder x3,
            f4.decoder x4,
            f5.decoder x5,
            f6.decoder x6,
            f7.decoder x7 )
      | _ -> raise (Invalid_argument "tup7: expected a list of 7 elements"));
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7) ->
        `A
          [
            f1.encoder v1;
            f2.encoder v2;
            f3.encoder v3;
            f4.encoder v4;
            f5.encoder v5;
            f6.encoder v6;
            f7.encoder v7;
          ]);
  }

let tup8 f1 f2 f3 f4 f5 f6 f7 f8 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3; x4; x5; x6; x7; x8 ] ->
          ( f1.decoder x1,
            f2.decoder x2,
            f3.decoder x3,
            f4.decoder x4,
            f5.decoder x5,
            f6.decoder x6,
            f7.decoder x7,
            f8.decoder x8 )
      | _ -> raise (Invalid_argument "tup8: expected a list of 8 elements"));
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7, v8) ->
        `A
          [
            f1.encoder v1;
            f2.encoder v2;
            f3.encoder v3;
            f4.encoder v4;
            f5.encoder v5;
            f6.encoder v6;
            f7.encoder v7;
            f8.encoder v8;
          ]);
  }

let tup9 f1 f2 f3 f4 f5 f6 f7 f8 f9 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3; x4; x5; x6; x7; x8; x9 ] ->
          ( f1.decoder x1,
            f2.decoder x2,
            f3.decoder x3,
            f4.decoder x4,
            f5.decoder x5,
            f6.decoder x6,
            f7.decoder x7,
            f8.decoder x8,
            f9.decoder x9 )
      | _ -> raise (Invalid_argument "tup9: expected a list of 9 elements"));
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7, v8, v9) ->
        `A
          [
            f1.encoder v1;
            f2.encoder v2;
            f3.encoder v3;
            f4.encoder v4;
            f5.encoder v5;
            f6.encoder v6;
            f7.encoder v7;
            f8.encoder v8;
            f9.encoder v9;
          ]);
  }

let tup10 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 =
  {
    decoder =
      (function
      | `A [ x1; x2; x3; x4; x5; x6; x7; x8; x9; x10 ] ->
          ( f1.decoder x1,
            f2.decoder x2,
            f3.decoder x3,
            f4.decoder x4,
            f5.decoder x5,
            f6.decoder x6,
            f7.decoder x7,
            f8.decoder x8,
            f9.decoder x9,
            f10.decoder x10 )
      | _ -> raise (Invalid_argument "tup10: expected a list of 10 elements"));
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7, v8, v9, v10) ->
        `A
          [
            f1.encoder v1;
            f2.encoder v2;
            f3.encoder v3;
            f4.encoder v4;
            f5.encoder v5;
            f6.encoder v6;
            f7.encoder v7;
            f8.encoder v8;
            f9.encoder v9;
            f10.encoder v10;
          ]);
  }

type 'a field = {
  field_encoder : 'a -> Ezjsonm.value -> Ezjsonm.value;
  field_decoder : 'a Decoder.t;
}

let req name { encoder; decoder } =
  {
    field_encoder = Encoder.field name encoder;
    field_decoder = Decoder.field name decoder;
  }

let opt name { encoder; decoder } =
  {
    field_encoder = Encoder.field_opt name encoder;
    field_decoder = Decoder.field_opt name decoder;
  }

let dft ?(equal = ( = )) name { encoder; decoder } default =
  {
    field_encoder = Encoder.field_dft equal name encoder default;
    field_decoder = Decoder.field_dft name decoder default;
  }

let obj0 = { encoder = Encoder.obj0; decoder = Decoder.obj0 }

let obj1 f =
  {
    encoder = (fun value -> f.field_encoder value (`O []));
    decoder = (fun json -> f.field_decoder json);
  }

let obj2 f1 f2 =
  {
    encoder =
      (fun (v1, v2) -> `O [] |> f1.field_encoder v1 |> f2.field_encoder v2);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder and+ v2 = f2.field_decoder in
       (v1, v2));
  }

let obj3 f1 f2 f3 =
  {
    encoder =
      (fun (v1, v2, v3) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder in
       (v1, v2, v3));
  }

let obj4 f1 f2 f3 f4 =
  {
    encoder =
      (fun (v1, v2, v3, v4) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3 |> f4.field_encoder v4);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder
       and+ v4 = f4.field_decoder in
       (v1, v2, v3, v4));
  }

let obj5 f1 f2 f3 f4 f5 =
  {
    encoder =
      (fun (v1, v2, v3, v4, v5) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3 |> f4.field_encoder v4 |> f5.field_encoder v5);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder
       and+ v4 = f4.field_decoder
       and+ v5 = f5.field_decoder in
       (v1, v2, v3, v4, v5));
  }

let obj6 f1 f2 f3 f4 f5 f6 =
  {
    encoder =
      (fun (v1, v2, v3, v4, v5, v6) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3 |> f4.field_encoder v4 |> f5.field_encoder v5
        |> f6.field_encoder v6);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder
       and+ v4 = f4.field_decoder
       and+ v5 = f5.field_decoder
       and+ v6 = f6.field_decoder in
       (v1, v2, v3, v4, v5, v6));
  }

let obj7 f1 f2 f3 f4 f5 f6 f7 =
  {
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3 |> f4.field_encoder v4 |> f5.field_encoder v5
        |> f6.field_encoder v6 |> f7.field_encoder v7);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder
       and+ v4 = f4.field_decoder
       and+ v5 = f5.field_decoder
       and+ v6 = f6.field_decoder
       and+ v7 = f7.field_decoder in
       (v1, v2, v3, v4, v5, v6, v7));
  }

let obj8 f1 f2 f3 f4 f5 f6 f7 f8 =
  {
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7, v8) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3 |> f4.field_encoder v4 |> f5.field_encoder v5
        |> f6.field_encoder v6 |> f7.field_encoder v7 |> f8.field_encoder v8);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder
       and+ v4 = f4.field_decoder
       and+ v5 = f5.field_decoder
       and+ v6 = f6.field_decoder
       and+ v7 = f7.field_decoder
       and+ v8 = f8.field_decoder in
       (v1, v2, v3, v4, v5, v6, v7, v8));
  }

let obj9 f1 f2 f3 f4 f5 f6 f7 f8 f9 =
  {
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7, v8, v9) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3 |> f4.field_encoder v4 |> f5.field_encoder v5
        |> f6.field_encoder v6 |> f7.field_encoder v7 |> f8.field_encoder v8
        |> f9.field_encoder v9);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder
       and+ v4 = f4.field_decoder
       and+ v5 = f5.field_decoder
       and+ v6 = f6.field_decoder
       and+ v7 = f7.field_decoder
       and+ v8 = f8.field_decoder
       and+ v9 = f9.field_decoder in
       (v1, v2, v3, v4, v5, v6, v7, v8, v9));
  }

let obj10 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 =
  {
    encoder =
      (fun (v1, v2, v3, v4, v5, v6, v7, v8, v9, v10) ->
        `O [] |> f1.field_encoder v1 |> f2.field_encoder v2
        |> f3.field_encoder v3 |> f4.field_encoder v4 |> f5.field_encoder v5
        |> f6.field_encoder v6 |> f7.field_encoder v7 |> f8.field_encoder v8
        |> f9.field_encoder v9 |> f10.field_encoder v10);
    decoder =
      (let open Decoder.Syntax in
       let+ v1 = f1.field_decoder
       and+ v2 = f2.field_decoder
       and+ v3 = f3.field_decoder
       and+ v4 = f4.field_decoder
       and+ v5 = f5.field_decoder
       and+ v6 = f6.field_decoder
       and+ v7 = f7.field_decoder
       and+ v8 = f8.field_decoder
       and+ v9 = f9.field_decoder
       and+ v10 = f10.field_decoder in
       (v1, v2, v3, v4, v5, v6, v7, v8, v9, v10));
  }

let merge_objs j1 j2 =
  {
    encoder =
      (fun (v1, v2) ->
        match (j1.encoder v1, j2.encoder v2) with
        | `O l1, `O l2 -> `O (l1 @ l2)
        | _ -> raise (Invalid_argument "merge_objs: expected objects"));
    decoder = (fun json -> (j1.decoder json, j2.decoder json));
  }

let case f g j =
  conv
    (fun v ->
      match f v with Some x -> x | None -> failwith "Invalid argument")
    g j

let union cases =
  {
    decoder = Decoder.union (List.map (fun { decoder; _ } -> decoder) cases);
    encoder = Encoder.union (List.map (fun { encoder; _ } -> encoder) cases);
  }

let satisfies cond { decoder; encoder } =
  {
    decoder =
      (fun v ->
        match decoder v with
        | x when cond x -> x
        | _ -> raise (Invalid_argument "satisfies: decoder"));
    encoder =
      (fun v ->
        if cond v then encoder v
        else raise (Invalid_argument "satisfies: encoder"));
  }

module Decoding = struct
  type 'a encoding = 'a t

  let from_encoding { decoder; _ } = decoder

  include Decoder
end
