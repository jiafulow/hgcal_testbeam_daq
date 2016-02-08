#include "SKIROC2_SC.h"
#include "SKIROC2_SC_hw.h"

// Scan
void scan()
{
    int i;
    const char * reg;
    unsigned int values[LOOKUP_TABLE_SIZE];

    // Initialize
    skiroc2_slow_control_init();

    // Scan
    skiroc2_slow_control_scan(values, sizeof(values)/sizeof(values[0]));

    for (i = 0; i < LOOKUP_TABLE_SIZE; i++) {
        reg = lookup_table_names_ordered[i];
        printf("%s ", reg);
        print_binary(values[i]);
        printf("\n");
    }

    return;
}

// main()
int main(int argc, char *argv[])
{
    // Scan
    scan();

    return 0;
}
