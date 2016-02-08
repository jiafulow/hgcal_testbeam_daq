#include "IPbusLite.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

// Usage
void usage(const char* prog)
{
    printf("usage: %s ADDR N\n\n", prog);
    printf("       ADDR is in HEX, N is in decimal.\n\n");
    printf("  e.g. %s 0xABC 4\n", prog);
}

// Create read txn
void create_read_txn(uint32_t addr, int nwords)
{
    uint32_t header = create_ipbus_read_txn_header(addr, nwords);

    printf("0x%08X\n", header);
}

// main()
int main(int argc, char *argv[])
{
    // Usage
    const char * prog = argv[0];
    if (argc != 3) {
        usage(prog);
        exit(EXIT_FAILURE);
    }

    // Get arguments
    uint32_t addr = (uint32_t) strtoul(argv[1], NULL, 0);

    int nwords = (int) strtol(argv[2], NULL, 10);

    // Create read txn
    create_read_txn(addr, nwords);

    return 0;
}
