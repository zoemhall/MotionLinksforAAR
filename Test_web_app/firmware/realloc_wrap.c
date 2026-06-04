// Linker shim for `-Wl,-wrap=realloc`.
//
// The build flag `-Wl,-wrap=realloc` (commonly added to nRF52 PlatformIO
// configs alongside `-Wl,-u,_printf_float`) tells the linker to redirect
// every call to `realloc` to a function named `__wrap_realloc`. The original
// `realloc` from libc is exposed as `__real_realloc`.
//
// If no source file in the project provides `__wrap_realloc`, the linker
// errors out with "undefined reference to `__wrap_realloc`" the first time
// any code (including the Arduino String class) calls realloc.
//
// This file provides a minimal pass-through implementation that just
// forwards to the real realloc — enough to satisfy the linker without
// changing runtime behaviour.

#include <stdlib.h>

extern void *__real_realloc(void *ptr, size_t size);

void *__wrap_realloc(void *ptr, size_t size) {
    return __real_realloc(ptr, size);
}
