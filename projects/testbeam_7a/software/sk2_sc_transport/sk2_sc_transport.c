#include "IPbusLite.h"
#include "ZynqIO.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>


#define REG_SIZE   0x10000
#define BRAM_SIZE  0x20000


int main(int argc, char *argv[])
{
    int i;
    int len = 0;

    // _________________________________________________________________
    // UIO devices
    // Check the device names and make sure they actually match!
    int uiofd0;
    int uiofd1;
    int uiofd2;
    int uiofd3;
    const char *uiod0 = "/dev/uio0";  // axi_bram_ctrl_0
    const char *uiod1 = "/dev/uio1";  // axi_bram_ctrl_1
    const char *uiod2 = "/dev/uio2";  // myip_0
    const char *uiod3 = "/dev/uio3";  // myip_1
    void *uioptr0;
    void *uioptr1;
    void *uioptr2;
    void *uioptr3;

    // Open the UIO devices
    uiofd0 = open(uiod0, O_RDWR);
    if (uiofd0 < 1) {
        printf("Invalid UIO device file:%s.\n", uiod0);
        exit(-1);
    }

    uiofd1 = open(uiod1, O_RDWR);
    if (uiofd1 < 1) {
        printf("Invalid UIO device file:%s.\n", uiod1);
        exit(-1);
    }

    uiofd2 = open(uiod2, O_RDWR);
    if (uiofd2 < 1) {
        printf("Invalid UIO device file:%s.\n", uiod2);
        exit(-1);
    }

    uiofd3 = open(uiod3, O_RDWR);
    if (uiofd3 < 1) {
        printf("Invalid UIO device file:%s.\n", uiod3);
        exit(-1);
    }

    // mmap() the UIO devices
    uioptr0 = mmap(NULL, BRAM_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd0, 0);
    if (uioptr0 == MAP_FAILED) {
        printf("mmap call failure.\n");
        exit(-1);
    }

    uioptr1 = mmap(NULL, BRAM_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd1, 0);
    if (uioptr1 == MAP_FAILED) {
        printf("mmap call failure.\n");
        exit(-1);
    }

    uioptr2 = mmap(NULL, REG_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd2, 0);
    if (uioptr2 == MAP_FAILED) {
        printf("mmap call failure.\n");
        exit(-1);
    }

    uioptr3 = mmap(NULL, REG_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd3, 0);
    if (uioptr3 == MAP_FAILED) {
        printf("mmap call failure.\n");
        exit(-1);
    }

    // _________________________________________________________________
    // IPbusLite objects
    Command request = {
        .addr = 0x0,
        .nwords = 255,
        .type = IPBUS_TYPEID_WRITE,
        .info = IPBUS_INFOCODE_REQUEST,
        .data = {0}
    };

    for (i = 0; i < request.nwords; i++) {
        request.data[i] = i;
    }

    Command response = {0};

    Transaction txn = {
        .data = {0}
    };

    // _________________________________________________________________
    // Steps:
    // 1. Create write transaction
    // 2. Put the transaction into SEND
    // 3. Set READY bit in CR
    // 4. Move the transaction from SEND to RECV
    // 5. Unset READY bit in CR, set READY bit in SR
    // 6. Read the fake response from RECV
    // 7. Unset READY bit in SR
    // 8. FIXME: Fake the response
    // 9. Extract the response

    // Create write transaction
    create_ipbus_txn(&request, &txn);

    // ...

    // Extract write transaction
    len = extract_ipbus_txn(&txn, &response);

    // _________________________________________________________________
    // Unmap the UIO devices
    munmap(uioptr0, BRAM_SIZE);
    munmap(uioptr1, BRAM_SIZE);
    munmap(uioptr2, REG_SIZE);
    munmap(uioptr3, REG_SIZE);

    exit(EXIT_SUCCESS);
}
