#include "SKIROC2_SC.h"

// Peek
void peek(const char * reg)
{
    // Initialize
    skiroc2_slow_control_init();

    // Peek
    unsigned int value = 0;
    value = skiroc2_slow_control_peek(reg);
    printf("%s ", reg);
    print_binary(value);
    printf("\n");

    return;
}

// main()
int main(int argc, char *argv[])
{
    // Usage
    if(argc != 2) {
        printf("usage: %s REGISTER\n\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    const char * reg = argv[1];

    // Peek
    peek(reg);

    return 0;
}
