#include "SKIROC2_SC.h"

int main(int argc, char *argv[])
{
    // Initialize
    skiroc2_slow_control_init();

    // Scan
    skiroc2_slow_control_scan();

    return 0;
}
