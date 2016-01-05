#include "SKIROC2_SC.h"
#include "SKIROC2_SC_hw.h"

int main(int argc, char *argv[])
{
    int i;

    // Zero out the register
    for (i = 0; i < SKIROC2_SC_NWORDS; i++) {
        control_register->data[i] = 0;
    }

    //printf("'lookup_table' has %d entries.\n", LOOKUP_TABLE_SIZE);

    //dump_table();

    // Before config
    printf("'control_register' has %d bits encoded in %d words.\n", SKIROC2_SC_NBITS, SKIROC2_SC_NWORDS);

    dump_register();

    // After config
    printf("'control_register' after initialization with default values.\n");

    skiroc2_slow_control_set_default();

    dump_register();

    // Write to file
    dump_register_to_file();

    return 0;
}
