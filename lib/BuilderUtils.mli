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

open Ctypes

(** BuilderUtils module : Regroups a set of functions needed in almost all the
    Builder* modules. *)

(** Type strings representation used in the bindings for a GITypes tag. *)
type type_strings = { ocaml : string;
                      ctypes : string }

(** Type strings representation for GITypes tag both implemented or not. *)
type bindings_types = Not_implemented of string | Types of type_strings

(** Obtain from a GITypes.tag the type strings to use in bindings for a GITypes.tag
    if implemented. Returns Not_implemented with the tag name if not implemented.
    This is for simple scalar type (ie. with BuilderEnum.get_storage_type) .*)
val type_tag_to_bindings_types:
  GITypes.tag -> bindings_types

(** Obtain from a GITypeInfo.t the type strings to use in bindings.
    Returns Not_implemented with the tag name if not implemented. *)
val type_info_to_bindings_types:
  GITypeInfo.t structure ptr -> bool -> bindings_types

(** Add an open directives in a file for a module name.*)
val write_open_module:
  Pervasives.out_channel -> string -> unit

(** Add the line "open Ctypes\n" in a file. *)
val add_open_ctypes:
  Pervasives.out_channel -> unit

(** Add the line "open Foreign\n" in a file. *)
val add_open_foreign:
  Pervasives.out_channel -> unit

(** Add empty line in a file. *)
val add_empty_line:
  Pervasives.out_channel -> unit

(** Add information in comment. *)
val add_comments:
  Pervasives.out_channel -> string -> unit

(** Uses this to check if a autogenerated variable name does not match an
    OCaml keyword (ie: end ...). If so, it prepends "_" to the name.*)
val escape_OCaml_keywords:
  string -> string

(** Check if the string given in argument is not a string name of an OCaml type.
    If so, it prepends "_" to the name. *)
val escape_OCaml_types:
  string -> string

(** Check if the string given in argument is not a string name of a Ctypes type.
    If so, it prepends "_" to the name. *)
val escape_Ctypes_types:
  string -> string

(** Check if an autogenerated variable name start or not with a number. *)
val has_number_at_beginning:
  string -> bool

(** Check if an autogenerated variable name does not start with a number. If so
    it prepends a "_". *)
val escape_number_at_beginning:
  string -> string

(** Check if the string given in argument
    is not an OCaml keyword ,
    is not an OCaml type name,
    is not a Ctypes type name,
    or does not start with a number.
    If so, prepends "_" to the name. *)
val ensure_valid_variable_name:
  string -> string
