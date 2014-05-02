#define IMPLEMENT_API

#include <hx/CFFI.h>
#include <stdio.h>
#include <hxcpp.h>
#include "HXParse.h"

extern "C"
{
	int HXParse_register_prims() { return 0; }
}

using namespace hxparse;

void parseConnect(value appId, value clientKey)
{
    connect(val_string(appId), val_string(clientKey));
}
DEFINE_PRIM(parseConnect, 2);
