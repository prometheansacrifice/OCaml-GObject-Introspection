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

type file = {
  name: string;
  descr : Pervasives.out_channel;
}

type files = {
  ml : file;
  mli : file;
}

let file_in_create_append_mode name =
  Pervasives.open_out_gen [Open_append; Open_creat] 0o666 name

let generate_sources base_name =
  let name = base_name ^ ".ml" in
  let descr = file_in_create_append_mode name in
  let ml = {name; descr} in
  let name = base_name ^ ".mli" in
  let descr = file_in_create_append_mode name in
  let mli = {name; descr} in
  {ml; mli}

let close_sources source_files =
  let close_file f =
    if Sys.file_exists f.name then Pervasives.close_out f.descr in
  close_file source_files.ml;
  close_file source_files.mli

exception Not_Implemented of string

let raise_not_implemented message =
  raise (Not_Implemented message)

let parse_invalid_info info =
  ()

let parse_function_info info source_files =
  ()

let parse_callback_info info =
  ()

let parse_struct_info info source_files =
  match GIBaseInfo.get_name info with
  | None -> ()
  | Some name -> let f_descrs = (source_files.mli.descr,
                                 source_files.ml.descr) in
    let info' = GIStructInfo.from_baseinfo info in
    BuilderStruct.append_ctypes_struct_declaration name f_descrs;
    BuilderStruct.append_ctypes_struct_fields_declarations name info' f_descrs

let parse_boxed_info info =
  ()

let parse_enum_info info source_files =
  ()

let parse_flags_info info =
  ()

let parse_object_info info =
  ()

let parse_interface_info info =
  ()

let parse_constant_info info source_files =
  match GIBaseInfo.get_name info with
  | None -> ()
  | Some name -> let info' = GIConstantInfo.from_baseinfo info in
    let type_info = GIConstantInfo.get_type info' in
    let raise_tag_not_implemented loc tag =
      let m = String.concat ":" [loc; GITypes.string_of_tag tag] in
      raise_not_implemented m in
    let f_descrs = (source_files.mli.descr,
                    source_files.ml.descr) in
    match GITypeInfo.get_tag type_info with
    | GITypes.Void as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.Boolean ->
      BuilderConstant.append_boolean_constant name info' f_descrs
    | GITypes.Int8 ->
      BuilderConstant.append_int8_constant name info' f_descrs
    | GITypes.Uint8 ->
      BuilderConstant.append_uint8_constant name info' f_descrs
    | GITypes.Int16 ->
      BuilderConstant.append_int16_constant name info' f_descrs
    | GITypes.Uint16 ->
      BuilderConstant.append_uint16_constant name info' f_descrs
    | GITypes.Int32 ->
      BuilderConstant.append_int32_constant name info' f_descrs
    | GITypes.Uint32 ->
      BuilderConstant.append_uint32_constant name info' f_descrs
    | GITypes.Int64 ->
      BuilderConstant.append_int64_constant name info' f_descrs
    | GITypes.Uint64 ->
      BuilderConstant.append_uint64_constant name info' f_descrs
    | GITypes.Float ->
      BuilderConstant.append_float_constant name info' f_descrs
    | GITypes.Double ->
      BuilderConstant.append_double_constant name info' f_descrs
    | GITypes.GType as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.Utf8 ->
      BuilderConstant.append_string_constant name info' f_descrs
    | GITypes.Filename as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.Array as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.Interface as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.GList as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.GSList as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.GHash as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.Error as tag -> raise_tag_not_implemented __LOC__ tag
    | GITypes.Unichar as tag -> raise_tag_not_implemented __LOC__ tag

let parse_union_info info source_files =
  match GIBaseInfo.get_name info with
  | None -> ()
  | Some name -> let f_descrs = (source_files.mli.descr,
                                 source_files.ml.descr) in
    let info' = GIUnionInfo.from_baseinfo info in
    BuilderUnion.append_ctypes_union_declaration name f_descrs;
    BuilderUnion.append_ctypes_union_fields_declarations name info' f_descrs

let parse_value_info info =
  ()

let parse_signal_info info =
  ()

let parse_vfunc_info info =
  ()

let parse_property_info info =
  ()

let parse_field_info info =
  ()

let parse_arg_info info =
  ()

let parse_type_info info =
  ()

let parse_unresolved_info info =
  ()


