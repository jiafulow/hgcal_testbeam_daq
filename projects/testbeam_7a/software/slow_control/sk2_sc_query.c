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

//#define USE_MMAP

// Global variables
void *zed_channel;

// Functions

/*
 * See http://stackoverflow.com/questions/266357/tokenizing-strings-in-c
 */

/* Tokenize the string, parse the tokens as string */
void tokenize_all_str(const char * str)
{
    char buffer[256];
    strcpy(buffer, str);
    char* token = strtok(buffer, " ");

    while (token != NULL) {
        /* Do stuff */
        printf("Token: %s\n", token);

        token = strtok(NULL, " ");
    }
}

/* Tokenize the string, parse the first token as string, parse the other tokens as HEX */
void tokenize_first_str(const char * str)
{
    char buffer[256];
    strcpy(buffer, str);
    char* token = strtok(buffer, " ");

    unsigned int n;
    char * end;
    int i = 0;

    while (token != NULL) {
        /* Do stuff */
        if (i == 0) {
            printf("Token: %s\n", token);

        } else {
            /* Parse as HEX */
            n = strtoul(token, &end, 16);
            printf("Token: 0x%08X\n", n);
        }

        token = strtok(NULL, " ");
        ++i;
    }
}

// Usage
void usage(const char* prog)
{
    printf("usage: %s COMMAND_STRING\n\n", prog);
    printf("  e.g. %s RESET\n", prog);
    printf("       %s STAT\n", prog);
    printf("       %s W 4 12345678 22222222 33333333 00000001\n", prog);
    printf("       %s R 4\n", prog);
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
    char command_string[1024];
    command_string[0] = 0;
    for (i = 1; i < argc; i++) {
        strcat(command_string, argv[i]);
        strcat(command_string, " ");
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

    // Tokenize
    tokenize_all_str(command_string);
    //tokenize_first_str(command_string);

    // Clean up
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
