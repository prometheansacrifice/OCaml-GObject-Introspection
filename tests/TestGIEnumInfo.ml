(*
 * Copyright 2017 Cedric LE MOIGNE, cedlemo@gmx.com
 * This file is part of OCaml-GObject-Introspection.
 *
 * OCaml-GObject-Introspection is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * OCaml-GObject-Introspection is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OCaml-GObject-Introspection.  If not, see <http://www.gnu.org/licenses/>.
 *)

open TestUtils
open OUnit2

let namespace = "GLib"
let repo = GIRepository.get_default ()
let typelib = GIRepository.require repo namespace
let enum_name = "DateWeekday"

let get_enum_info () =
  match GIRepository.find_by_name repo namespace enum_name with
  | None -> None
  | Some (base_info) ->
    match GIBaseInfo.get_type base_info with
    | GIBaseInfo.Enum -> let info = GIEnumInfo.enuminfo_of_baseinfo base_info
      in Some info
    | _ -> None

let enum_test fn =
  match get_enum_info () with
  | None -> assert_equal_string enum_name "No base info found"
  | Some (info) -> fn info

let test_get_n_values test_ctxt =
  enum_test (fun info ->
      let n_values = GIEnumInfo.get_n_values info in
      assert_equal_int 8 n_values
    )

let test_get_n_methods test_ctxt =
  enum_test (fun info ->
      let n_methods = GIEnumInfo.get_n_methods info in
      assert_equal_int 0 n_methods
    )

let tests =
  "GObject Introspection GIEnumInfo tests" >:::
  [
    "GIEnumInfo get n values" >:: test_get_n_values;
    "GIEnumInfo get n methods" >:: test_get_n_methods
  ]