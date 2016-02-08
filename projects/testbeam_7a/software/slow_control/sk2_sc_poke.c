#include "SKIROC2_SC.h"

// Poke
void poke(const char * reg, unsigned int value)
{
    // Initialize
    skiroc2_slow_control_init();

    // Poke
    skiroc2_slow_control_poke(reg, value);

    // Peek
    value = skiroc2_slow_control_peek(reg);
    printf("%s ", reg);
    print_binary(value);
    printf("\n");

    // Write to file
    dump_register_to_file();

    return;
}

// main()
int main(int argc, char *argv[])
{
    // Usage
    if(argc != 3) {
        printf("usage: %s REGISTER VALUE\n\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    const char * reg = argv[1];
    unsigned int value = strtoul(argv[2], NULL, 0);

    // Poke
    poke(reg, value);

    return 0;
}
