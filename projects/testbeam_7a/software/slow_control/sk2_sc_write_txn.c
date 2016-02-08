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
    printf("usage: %s ADDR N [WORD 1 ... WORD N]\n\n", prog);
    printf("       ADDR is in HEX, N is in decimal, WORD is in HEX.\n\n");
    printf("  e.g. %s 0xABC 0\n", prog);
    printf("       %s 0xABC 4 0x12 0x34 0x99 0xFF\n", prog);
}

// Create write txn
void create_write_txn(uint32_t addr, int nwords, uint32_t * words)
{
    int i;

    uint32_t header = create_ipbus_write_txn_header(addr, nwords);

    printf("0x%08X\n", header);
    for (i = 0; i < nwords; i++) {
        printf("0x%08X\n", words[i]);
    }
}

// main()
int main(int argc, char *argv[])
{
    int i;

    // Usage
    const char * prog = argv[0];
    if (argc < 3) {
        usage(prog);
        exit(EXIT_FAILURE);
    }

    // Get arguments
    uint32_t addr = (uint32_t) strtoul(argv[1], NULL, 0);

    int nwords = (int) strtol(argv[2], NULL, 10);
    if (argc != 3+nwords) {
        usage(prog);
        exit(EXIT_FAILURE);
    }

    uint32_t * words = (uint32_t *) malloc(2048*sizeof(uint32_t));
    for (i = 0; i < nwords; i++) {
        words[i] = (uint32_t) strtoul(argv[3+i], NULL, 0);
    }

    // Create write txn
    create_write_txn(addr, nwords, words);

    // Clean up
    free(words);

    return 0;
}
