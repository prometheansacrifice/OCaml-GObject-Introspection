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

open OUnit2
open TestUtils

let get_default test_ctxt =
  let _ = GIRepository.get_default () in
  assert_equal_boolean true true

let require test_ctxt =
  let repo = GIRepository.get_default () in
  let namespace = Some "Gtk" in
  let _ = GIRepository.require repo namespace None 0 () in
  assert_equal_boolean true true

let namespace = Some "Gio"
let repo = GIRepository.get_default ()
let typelib = GIRepository.require repo namespace None 0 ()

let get_loaded_namespaces test_ctxt =
  let namespaces_check = "GLib GObject Gio" in
  let namespaces = String.concat " " (GIRepository.get_loaded_namespaces repo) in
  assert_equal_string namespaces_check namespaces

let tests =
  "GObject Introspection Repository tests" >:::
    [
      "GIRepository get default" >:: get_default;
      "GIRepository require" >:: require;
      "GIRepository get loaded namespaces" >:: get_loaded_namespaces
    ]
