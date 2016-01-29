#include "IPbusLite.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

void usage(const char* prog)
{
    printf("usage: %s N [WORD 1, ..., WORD N]\n\n", prog);
    printf("       N is in decimal, WORD is in HEX, e.g.\n");
    printf("       %s 0\n", prog);
    printf("       %s 4 0x12 0x34 0x99 0xFF\n", prog);
}

int main(int argc, char *argv[])
{
    int i = 0;
    int len = 0;

    // Usage
    const char * prog = argv[0];
    if(argc < 2) {
        usage(prog);
        exit(EXIT_FAILURE);
    }

    int nwords = (int)strtol(argv[1], NULL, 10);
    if (argc != 2+nwords) {
        usage(prog);
        exit(EXIT_FAILURE);
    }

    uint32_t addr = 0xdeadbeef;

    // IPbusLite objects
    Command request = {
        .addr = addr,
        .nwords = nwords,
        .type = IPBUS_TYPEID_WRITE,
        .info = IPBUS_INFOCODE_REQUEST,
        .data = {0}
    };

    for (i = 0; i < request.nwords; i++) {
        request.data[i] = (uint32_t) strtoul(argv[2+i], NULL, 0);
    }

    Command response = {0};

    Transaction txn = {
        .data = {0}
    };

    // _________________________________________________________________
    // Create write transaction

    len = create_ipbus_txn(&request, &txn);

    // Verbose
    printf("Request:\n");
    printf("  addr=0x%08X, nwords=%u, words=\n", request.addr, request.nwords);
    for (i = 0; i < request.nwords; i++) {
        if (i%8 == 0) printf("  ");
        printf("0x%08X ", request.data[i]);
        if (i%8 == 7 || i == request.nwords-1) printf("\n");
    }
    //printf("Dump cmnd:\n");
    //dump_cmnd(&request);
    printf("Dump txn:\n");
    dump_txn(len, &txn);
    printf("\n");

    // _________________________________________________________________
    // FIXME: fake response

    fake_ipbus_response(&txn);

    // _________________________________________________________________
    // Extract write transaction

    len = extract_ipbus_txn(&txn, &response);

    // Verbose
    printf("Response:\n");
    printf("  addr=0x%08X, nwords=%u\n", response.addr, response.nwords);
    //printf("Dump cmnd:\n");
    //dump_cmnd(&response);
    printf("Dump txn:\n");
    dump_txn(len, &txn);
    printf("\n");

    // _________________________________________________________________

    exit(EXIT_SUCCESS);
}
