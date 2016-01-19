#include "IPbusLite.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

void usage(const char* prog)
{
    printf("usage: %s N\n\n", prog);
    printf("       N is in decimal, e.g.\n");
    printf("       %s 4\n", prog);

}

int main(int argc, char *argv[])
{
    int i = 0;
    int len = 0;

    // Usage
    const char * prog = argv[0];
    if(argc != 2) {
        usage(prog);
        exit(EXIT_FAILURE);
    }

    int nwords = (int)strtol(argv[1], NULL, 10);

    uint32_t addr = 0xdeadbeef;

    // IPbusLite objects
    Command request = {
        .addr = addr,
        .nwords = nwords,
        .type = IPBUS_TYPEID_READ,
        .info = IPBUS_INFOCODE_REQUEST,
        .data = {0}
    };

    Command response = {0};

    Transaction txn = {
        .data = {0}
    };

    // _________________________________________________________________
    // Create read transaction

    len = create_ipbus_txn(&request, &txn);

    // Verbose
    printf("Request:\n");
    printf("  addr=0x%08X, nwords=%u\n", request.addr, request.nwords);
    //printf("Dump cmnd:\n");
    //dump_cmnd(&request);
    printf("Dump txn:\n");
    dump_txn(len, &txn);
    printf("\n");

    // _________________________________________________________________
    // FIXME: fake response

    fake_ipbus_response(&txn);

    // _________________________________________________________________
    // Extract read transaction

    len = extract_ipbus_txn(&txn, &response);

    // Verbose
    printf("Response:\n");
    printf("  addr=0x%08X, nwords=%u, words=\n", response.addr, response.nwords);
    for (i = 0; i < response.nwords; i++) {
        if (i%8 == 0) printf("  ");
        printf("0x%08X ", response.data[i]);
        if (i%8 == 7 || i == response.nwords-1) printf("\n");
    }
    //printf("Dump cmnd:\n");
    //dump_cmnd(&response);
    printf("Dump txn:\n");
    dump_txn(len, &txn);
    printf("\n");

    // _________________________________________________________________

    exit(EXIT_SUCCESS);
}
