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
    printf("usage: %s TXN_HEADER [TXN_DATA 1 ... TXN_DATA N]\n\n", prog);
    printf("       TXN_HEADER, TXN_DATA are in HEX.\n\n");
    printf("  e.g. %s 0x0ABC0010\n", prog);
    printf("       %s 0x0ABC0410 0x00000012 0x00000034 0x00000099 0x000000FF\n", prog);
}

// Extract response txn
void extract_response_txn(uint32_t header, int nwords, uint32_t * words)
{
    int i;

    uint32_t txn_addr;
    uint32_t txn_nwords;
    extract_ipbus_response_txn_header(header, &txn_addr, &txn_nwords);

    if (txn_nwords > nwords) {
        fprintf(stderr, "ERROR: Expect %u data words, got %d words", txn_nwords, nwords);
        exit(EXIT_FAILURE);
    }

    //printf("ADDR=0x%08X, N=%u\n", txn_addr, txn_nwords);
    for (i = 0; i < txn_nwords; i++) {
        printf("0x%08X\n", words[i]);
    }
}

// main()
int main(int argc, char *argv[])
{
    int i;

    // Usage
    const char * prog = argv[0];
    if (argc < 2) {
        usage(prog);
        exit(EXIT_FAILURE);
    }

    // Get arguments
    uint32_t header = (uint32_t) strtoul(argv[1], NULL, 0);

    int nwords = argc - 2;

    uint32_t * words = (uint32_t *) malloc(2048*sizeof(uint32_t));
    for (i = 0; i < nwords; i++) {
        words[i] = (uint32_t) strtoul(argv[2+i], NULL, 0);
    }

    // Extract response txn
    extract_response_txn(header, nwords, words);

    // Clean up
    free(words);

    return 0;
}
