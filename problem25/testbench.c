#include <stdio.h>
#include <assert.h>

int main (int argc, char *argv[]) { 
    int i;
    for (i = 0; i < 16; ++i) {
        assert(ref_sbox(i) == sbox(i));
    }
    return 0;
}