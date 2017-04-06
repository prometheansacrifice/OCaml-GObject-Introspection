#ifndef GIBASEINFO_STUBS_H
#define GIBASEINFO_STUBS_H

#include "conversions.h"
#include <girepository.h>

#define GIBaseInfo_val(v) (*((GIBaseInfo **) Data_custom_val(v)))
#define Val_gibaseinfo(i) value_gibaseinfo (i)

value
alloc_gibaseinfo (GIBaseInfo *i);

CAMLprim value
caml_g_ibaseinfo_get_name_c (value baseinfo);

#endif // GIBASEINFO_STUBS_H