/*
 * Simple test of axi_skiroc_sc IP with 616 registers.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>  // for memcpy

#define SKIROC_BASE_ADDRESS 0x43C00000
#define SKIROC_MAP_SIZE 0x10000

#define NWORDS 20

static unsigned * source;
static unsigned * destination;

inline void gpio_write(void *gpio_base, unsigned int offset, unsigned int value)
{
        *((volatile unsigned *)(gpio_base + offset)) = value;
}

inline unsigned int gpio_read(void *gpio_base, unsigned int offset)
{
        return *((volatile unsigned *)(gpio_base + offset));
}

int main()
{
	int i, j;
    int uio0_fd;
    const char *uio0_d = "/dev/uio0";
    void *uio0_ptr;

    printf("-- Example program --\n");

    // Open the UIO devices
    uio0_fd = open(uio0_d, O_RDWR);
    if (uio0_fd < 1) {
    	printf("Invalid UIO device file:%s.\n", uio0_d);
    	exit(-1);
    }

    // mmap() the UIO devices
    uio0_ptr = mmap(NULL, SKIROC_MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uio0_fd, 0);
    if (uio0_ptr == MAP_FAILED) {
            printf("mmap call failure.\n");
            exit(-1);
    }

    // Set data transfer source and destination
    source = (unsigned *) malloc(SKIROC_MAP_SIZE);
    destination = (unsigned *) uio0_ptr;

    unsigned word;

    // Create twenty 32-bit words to encode 616 bits
    printf("Create words...\n");
    for (i=0; i<NWORDS; i++) {
    	//*(source+i) = i;

    	j = i%16;  // a hex char
    	word = (j<<28) | (j<<24) | (j<<20) | (j<<16) | (j<<12) | (j<<8) | (j<<4) | (j<<0);  // concat 8 hex chars
    	*(source+i) = word;

    	printf("32-bit word %2d: 0x%08x\n", i, word);
    }

    // Write
    for (i=0; i<NWORDS; i++) {
    	gpio_write(destination, i*sizeof(unsigned), *(source+i));
    }

    // Read
    printf("\nRead words...\n");
    for (i=0; i<NWORDS; i++) {
    	word = gpio_read(destination, i*sizeof(unsigned));
    	printf("32-bit word %2d: 0x%08x\n", i, word);
    }

    printf("-- Exiting main() --\n");

    // Unmap the UIO devices
    munmap(uio0_ptr, SKIROC_MAP_SIZE);

    // Release memory
    free(source);

    return 0;
}
