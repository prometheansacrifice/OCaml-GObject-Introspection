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
open Foreign

(** Binding_utils module : Regroups a set of functions and sub-modules needed
    and used in almost all the Bind_* modules that generate automatically the
    bindings. *)

(** Helper to write clean code with optional values. *)
module Option : sig
  val value : default:'a -> 'a option -> 'a
end

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

(** Get the bindings name of a C data from its BaseInfo. Only complex C data
    structure need to use it (ie: structure, union, enum, flags, interface and
    gobject.)*)
val get_binding_name:
  Base_info.t structure ptr -> string option

(** Remove each occurence of a pattern in a string. *)
val string_pattern_remove:
  string -> string -> string

(** Type strings representation used in the bindings for a Types tag. *)
type type_strings = { ocaml : string;
                      ctypes : string }

(** Type strings representation for Types tag both implemented or not. *)
type bindings_types = Not_implemented of string | Types of type_strings

(** Obtain from a Types.tag the type strings to use in bindings for a Types.tag
    if implemented. Returns Not_implemented with the tag name if not implemented.
    This is for simple scalar type (ie. with Bind_enum.get_storage_type) .*)
val type_tag_to_bindings_types:
  Types.tag -> bindings_types

(** Obtain from a Type_info.t the type strings to use in bindings.
    Returns Not_implemented with the tag name if not implemented. *)
val type_info_to_bindings_types:
  Type_info.t structure ptr -> bool -> bindings_types

(** Check if a string match on of the pattern in a list. *)
val match_one_of:
  string -> string list -> bool

(** Module for a file representation. A File.t is associated with a
     - name
     - file descriptor
     - buffer
     The idea is to build the bindings in the buffer and write the buffer in
     the file descriptor once the bindings are generated. *)
module File : sig
  type t

  val create:
    string -> t

  (** Used in tests with oUnit. *)
  val create_tmp:
    string * Pervasives.out_channel -> t

  val close :
    t -> unit

  (** Get the filename of the File.t value. *)
  val name:
    t -> string

  (** Get the file descriptor of the File.t value. *)
  val descr:
    t -> Pervasives.out_channel

  (** Get the buffer of the File.t value. *)
  val buffer:
    t -> Buffer.t

  (** Add an open directives in a file for a module name.*)
  val write_open_module:
    t -> string -> unit

  (** Add the line "open Ctypes\n" in a file. *)
  val add_open_ctypes:
    t -> unit

  (** Add the line "open Foreign\n" in a file. *)
  val add_open_foreign:
    t -> unit

  (** Add empty line in a file. *)
  val add_empty_line:
    t -> unit

  (** Add information in comment. *)
  val add_comments:
    t -> string -> unit

  (** Append string to buffer. *)
  val buff_add:
    t ->string -> unit

  (** Append a line to the current buffer. *)
  val buff_add_line:
    t -> string -> unit

  (** Append a comment line. *)
  val buff_add_comments:
    t -> string -> unit

  (** Append an end of line. *)
  val buff_add_eol:
    t -> unit

  (** Printf.bprintf like but that use File.t as argument.*)
  val bprintf:
    t -> ('a, Buffer.t, unit) format -> 'a

  (** Write the buffer into the file descriptor. *)
  val buff_write:
    t -> unit
end

(** This module is dedicated to a set of a mli and ml file represented by two
    File.t type variables. It allows to easily create, write, close and access
    to two sources files. *)
module Sources : sig

  type t

  (** Constructor that generate a two files in append mode and that returns
      a value of type sources.*)
  val create:
    string -> t

  (** Helper that generate ml and mli files, that adds "open Ctypes" in the
      .mli file and "open Ctypes\nopenForeign\n" in the .ml file. *)
  val create_ctypes:
    string -> t

  (** Constructor for oUnit in tests. *)
  val create_tmp:
    File.t * File.t -> t

  (** function that returns the ml part of the sources type. It contains both
      the name of the ".ml" source and its file descriptor.*)
  val ml:
    t -> File.t

  (** function that returns the mli part of the sources type. It contains both
      the name of the ".mli" source and its file descriptor.*)
  val mli:
    t -> File.t

  (** Write all the buffer contents (ml and mli) in their respective files. *)
  val write_buffs:
    t -> unit

  (** Close the source files (ml and mli) and reset the buffer. *)
  val close:
    t -> unit

  (** Add a TODO instructions in comments in both the mli and ml files. *)
  val add_todo:
    t -> string -> unit

  (** Add a DEPRECATED instruction in comments in both the mli and ml files. *)
  val add_deprecated:
    t -> string -> unit

  (** Add a skipped instruction in comments in both the mli and ml files. *)
  val add_skipped:
    t -> string -> unit
end
