open Ctypes
open Foreign

type t
let t_typ : t structure typ = structure "Private"
let f_p = field t_typ "p" (ptr void)
(* TODO Struct field Private : interface tag not implemented *)let f_future = field t_typ "future" (Array.t_typ)

