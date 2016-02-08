#include "SKIROC2_SC.h"
#include "SKIROC2_SC_hw.h"

// Reset
void reset()
{
    // Reset
    skiroc2_slow_control_reset();

    printf("Slow control register reset to:\n");
    dump_register();

    // Write to file
    dump_register_to_file();

    printf("Created file '%s'.\n", control_register_file);

    return;
}

// main()
int main(int argc, char *argv[])
{
    // Reset
    reset();

    return 0;
}
