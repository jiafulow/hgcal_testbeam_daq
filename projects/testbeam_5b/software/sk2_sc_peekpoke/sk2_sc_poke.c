#include "SKIROC2_SC.h"

int main(int argc, char *argv[])
{

    // Usage
    if(argc != 3) {
        printf("usage: %s REGISTER VALUE\n\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    // Initialize
    skiroc2_slow_control_init();

    // Poke
    const char * reg = argv[1];
    unsigned int value = strtoul(argv[2], NULL, 0);
    skiroc2_slow_control_poke(reg, value);

    value = skiroc2_slow_control_peek(reg);
    printf("%s ", reg);
    print_binary(value);
    printf("\n");

    // Write
    dump_register_to_file();

    return 0;
}
