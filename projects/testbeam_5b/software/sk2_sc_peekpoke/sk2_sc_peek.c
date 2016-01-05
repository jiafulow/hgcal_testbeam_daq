#include "SKIROC2_SC.h"

int main(int argc, char *argv[])
{

    // Usage
    if(argc != 2) {
        printf("usage: %s REGISTER\n\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    // Initialize
    skiroc2_slow_control_init();

    // Peek
    const char * reg = argv[1];
    unsigned int value = skiroc2_slow_control_peek(reg);
    printf("%s ", reg);
    print_binary(value);
    printf("\n");

    return 0;
}
