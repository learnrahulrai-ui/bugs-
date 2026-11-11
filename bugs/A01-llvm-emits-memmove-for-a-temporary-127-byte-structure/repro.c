#include <stdint.h>
typedef struct { uint8_t x1[127]; } Foo;
void with_temp(Foo *ptr, int dst, int src) {
    Foo x = ptr[src];
    ptr[dst] = x;
}
void direct(Foo *ptr, int dst, int src) {
    ptr[dst] = ptr[src];
}
