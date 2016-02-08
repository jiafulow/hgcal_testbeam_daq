#include "zed_system.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

// Definitions
#define ZED_CHANNEL_BASEADDR 0x43C00000
#define ZED_CHANNEL_HIGHADDR 0x43C0FFFF
#define ZED_CHANNEL_MAP_SIZE 0x10000
#define ZED_CHANNEL_MAP_MASK (ZED_CHANNEL_MAP_SIZE - 1)

#define ZSEND_OFFSET   0x0
#define ZRCV_OFFSET    0x4
#define ZSTATUS_OFFSET 0xC
#define ZCTRL_OFFSET   0xC

#define USE_MMAP

// Global variables
void *zed_channel;

// Functions

// Usage
void usage(const char* prog)
{
    printf("usage: %s WORD 1 [WORD 2 ... WORD N]\n\n", prog);
    printf("       WORDs are in HEX.\n\n");
    printf("  e.g. %s 0x0ABC0010\n", prog);
    printf("       %s 0x0ABC0410 0x00000012 0x00000034 0x00000099 0x000000FF\n", prog);
}

// Write to SEND register
void send_mem(int nwords, uint32_t * words)
{
    int i = 0;
    uint32_t check;

    // From Cristian Gingu:
    // 0. First reset the send memory pointer -> write 0x1
    // -- Do the following loop for each 32-bit word, starting with the packet header
    // 1. Write the 32-bit data word to Base Address + 0 (the send packet register)
    // 2. Write 0x4 (to write the data into firmware)
    // 3. Read Base Address + 0 to check what you wrote into firmware (optional, for sanity)
    // 4. Write 0x2 (to increment the pointer)
    // -- Repeat Steps 1 to 4 until all data words are written.
    // -- Write 0x800 (bit#11) to send out the packet. The firmware will wait for
    //    the response packet to come in (or it will time-out). You need to poll the
    //    status bit#13 to know when the response packet is available for reading out

    // Reset
    volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x1);

    for (i = 0; i < nwords; i++) {
        // Write data
        volatile_write_word(zed_channel, ZSEND_OFFSET, words[i]);
        volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x4);
        //check = volatile_read_word(zed_channel, ZSEND_OFFSET);
        //printf("0x%08X\n", check);

        // Increment
        volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x2);
    }

    // Send out
    volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x800);

    // Poll the status bit#13
    //while ((volatile_read_word(zed_channel, ZSTATUS_OFFSET) & 0x2000) == 0);

    // Read back for sanity check
    // Reset
    volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x1);

    for (i = 0; i < nwords; i++) {
        // Read written data
        check = volatile_read_word(zed_channel, ZSEND_OFFSET);
        printf("0x%08X\n", check);

        // Increment
        volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x2);

        // Prepare for next reading
        volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x0);
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
    int nwords = argc - 1;

    uint32_t * words = (uint32_t *) malloc(2048*sizeof(uint32_t));
    for (i = 0; i < nwords; i++) {
        words[i] = (uint32_t) strtoul(argv[1+i], NULL, 0);
    }

#ifdef USE_MMAP
    // Open the device
    int memfd;
    off_t dev_base = ZED_CHANNEL_BASEADDR;

    memfd = open("/dev/mem", O_RDWR | O_SYNC);
    if (memfd < 1) {
        printf("Cannot open /dev/mem.\n");
        exit(-1);
    }

    // mmap() the device
    zed_channel = mmap(NULL, ZED_CHANNEL_MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, memfd, dev_base & ~ZED_CHANNEL_MAP_MASK);
    if (zed_channel == MAP_FAILED) {
        printf("Cannot map the memory to user space.\n");
        exit(-1);
    }
#else
    zed_channel = malloc(ZED_CHANNEL_MAP_SIZE);
#endif

    // Write to SEND register
    send_mem(nwords, words);

    // Clean up
    free(words);

#ifdef USE_MMAP
    if (munmap(zed_channel, ZED_CHANNEL_MAP_SIZE) == -1) {
        printf("Cannot unmap memory from user space.\n");
        exit(-1);
    }
    close(memfd);
#else
    free(zed_channel);
#endif

    return 0;
}
