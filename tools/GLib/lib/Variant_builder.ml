open Ctypes
open Foreign

type t
let t_typ : t structure typ = structure "Variant_builder"
let _new =
foreign "g_variant_builder_new" (ptr t_typ @-> ptr (* interface *) Variant_type.t_typ @-> returning (ptr (* interface *) t_typ))

let add_value =
foreign "g_variant_builder_add_value" (ptr t_typ @-> ptr (* interface *) Variant.t_typ @-> returning (void))

let close =
foreign "g_variant_builder_close" (ptr t_typ @-> returning (void))

let _end =
foreign "g_variant_builder_end" (ptr t_typ @-> returning (ptr (* interface *) Variant.t_typ))

let _open =
foreign "g_variant_builder_open" (ptr t_typ @-> ptr (* interface *) Variant_type.t_typ @-> returning (void))

let ref =
foreign "g_variant_builder_ref" (ptr t_typ @-> returning (ptr (* interface *) t_typ))

let unref =
foreign "g_variant_builder_unref" (ptr t_typ @-> returning (void))

