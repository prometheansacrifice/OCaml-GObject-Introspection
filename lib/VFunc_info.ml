(*
 * Copyright 2017-2018 Cedric LE MOIGNE, cedlemo@gmx.com
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

open Ctypes
open Foreign

type t
let vfuncinfo : t structure typ = structure "VFunc_info"

let get_offset =
  foreign "g_vfunc_info_get_offset"
    (ptr vfuncinfo @-> returning int)

let get_signal info =
  let get_signal_raw =
    foreign "g_vfunc_info_get_signal"
      (ptr vfuncinfo @-> returning (ptr_opt Callable_info.callableinfo)) in
  match get_signal_raw info with
  | None -> None
  | Some info' -> let info'' = Callable_info.add_unref_finaliser info' in
    Some info''

type flags =
  | Must_chain_up
  | Must_override
  | Must_not_override
  | Throws

let string_of_flags = function
  | Must_chain_up -> "Must_chain_up"
  | Must_override -> "Must_override"
  | Must_not_override -> "Must_not_override"
  | Throws -> "Throws"

let get_flags info =
  let get_flags_raw =
    foreign "g_vfunc_info_get_flags"
      (ptr vfuncinfo @-> returning int) in
  let flags = [] in
  let c_flags = get_flags_raw info in
  if ((c_flags land (1 lsl 0)) != 0) then ignore (Must_chain_up :: flags);
  if ((c_flags land (1 lsl 1)) != 0) then ignore (Must_override :: flags);
  if ((c_flags land (1 lsl 2)) != 0) then ignore (Must_not_override :: flags);
  if ((c_flags land (1 lsl 3)) != 0) then ignore (Throws :: flags);
  flags

(* TODO : check that the info can be casted to vfunc info ? *)
let cast_from_baseinfo info =
  coerce (ptr Base_info.baseinfo) (ptr vfuncinfo) info

let cast_to_baseinfo info =
  coerce (ptr vfuncinfo) (ptr Base_info.baseinfo) info

let add_unref_finaliser info =
  let _ = Gc.finalise (fun i ->
      let i' = cast_to_baseinfo i in
      Base_info.base_info_unref i') info
  in info

let from_baseinfo info =
  let _ = Base_info.base_info_ref info in
  let info' = cast_from_baseinfo info in
  add_unref_finaliser info'

let to_baseinfo info =
  let info' = cast_to_baseinfo info in
  let _ = Base_info.base_info_ref info' in
  let _ = Gc.finalise (fun i ->
      Base_info.base_info_unref i) info' in
  info'

let cast_from_callableinfo info =
  coerce (ptr Callable_info.callableinfo) (ptr vfuncinfo) info

let cast_to_callableinfo info =
  coerce (ptr vfuncinfo) (ptr Callable_info.callableinfo) info

let to_callableinfo info =
  let info' = cast_to_baseinfo info in
  let _ = Base_info.base_info_ref info' in
  let info'' = cast_to_callableinfo info in
  Callable_info.add_unref_finaliser info''

let from_callableinfo info =
  let info' = Callable_info.cast_to_baseinfo info in
  let _ = Base_info.base_info_ref info' in
  let info'' = cast_from_callableinfo info in
  let _ = Gc.finalise (fun i ->
      let i' = cast_to_baseinfo i in
      Base_info.base_info_unref i') info'' in
  info''

