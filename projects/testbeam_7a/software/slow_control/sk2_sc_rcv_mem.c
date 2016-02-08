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

}

uint32_t get_nwords(uint32_t header)
{
    return ( header >>  8 ) & 0xFF;
}

// Read from RCV register
void rcv_mem(int nwords, uint32_t * words)
{
    int i = 0;
    uint32_t header;

    // From Cristian Gingu:
    // 0. First reset receive memory pointer -> write 0x10
    // -- Read the 32-bit data word to Base Address + 4 (the receive packet register).
    // -- Do the following loop for reading each 32-bit data word in the packet
    // 1. Write 0x20 (to increment the read pointer)
    // 2. Read the 32-bit data word from Base Address + 4 (the receive packet register)
    // 3. Write 0x0 (to prepare for next reading)
    // -- Repeat Steps 1 to 3 until all packet words are read out.

    // Reset
    volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x10);

    // Read header
    header = volatile_read_word(zed_channel, ZRCV_OFFSET);
    printf("0x%08X\n", header);

    //nwords = get_nwords(header);  //FIXME

    for (i = 0; i < nwords; i++) {
        // Increment
        volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x20);

        // Read data
        words[i] = volatile_read_word(zed_channel, ZRCV_OFFSET);
        printf("0x%08X\n", words[i]);

        // Prepare for next reading
        volatile_write_word(zed_channel, ZCTRL_OFFSET, 0x0);
    }
}

// main()
int main(int argc, char *argv[])
{
    //int i;
    //
    //// Usage
    //const char * prog = argv[0];
    //if (argc < 2) {
    //    usage(prog);
    //    exit(EXIT_FAILURE);
    //}

    // Get arguments
    int nwords = 16;

    uint32_t * words = (uint32_t *) malloc(2048*sizeof(uint32_t));

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

    // Read from RCV register
    rcv_mem(nwords, words);

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
