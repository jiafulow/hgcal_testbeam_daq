/*
 * This piece of code is adapted from
 *   https://forums.xilinx.com/t5/Embedded-Linux/UIO-interrupt-with-PS-GPIO/td-p/603502
 *   https://forums.xilinx.com/xlnx/attachments/xlnx/ELINUX/12938/1/gpio_uio_app.c
 */


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>  // for memcpy

// AXI GPIO register space
#define GPIO_MAP_SIZE 		0x10000
#define GPIO_DATA_OFFSET	0x00
#define GPIO_TRI_OFFSET		0x04
//#define GPIO_DATA2_OFFSET	0x08
//#define GPIO_TRI2_OFFSET	0x0C
#define GPIO_GLOBAL_IRQ		0x11C
#define GPIO_IRQ_CONTROL	0x128
#define GPIO_IRQ_STATUS		0x120

#define BRAM_SIZE 0x10000
#define UIO_SIZE  0x10000

#define IRQ_NUM 62  // interrupts = <0 30 4>; so 30+32=62

static int numofwords;
static unsigned data;

static int gpio_fd;
static void * gpio_ptr;
static unsigned * source;
static unsigned * destination;

#define USE_FWRITE


inline void gpio_write(void *gpio_base, unsigned int offset, unsigned int value)
{
	*((volatile unsigned *)(gpio_base + offset)) = value;
}

inline unsigned int gpio_read(void *gpio_base, unsigned int offset)
{
	return *((volatile unsigned *)(gpio_base + offset));
}

void transfer_data() {
#ifndef USE_FWRITE
	memcpy(destination, source, numofwords*sizeof(int));
#else
	FILE * output_file = NULL;
	output_file = fopen("/home/root/outfile.txt", "wb");
	if (output_file != NULL) {
	    fwrite(source, numofwords*sizeof(int), 1, output_file);
	    fclose(output_file);
	} else {
		printf("Failed to open output file");
	}
#endif
}

void clear_interrupt() {
	data = gpio_read(gpio_ptr, GPIO_IRQ_STATUS);
	if (data)
		gpio_write(gpio_ptr, GPIO_IRQ_STATUS, 0x1);
}

void wait_for_interrupt()
{
    int pending = 0;
    int reenable = 1;

	// block on the file waiting for an interrupt */

	read(gpio_fd, (void *)&pending, sizeof(int));

    printf("\n\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
    printf("Interrupting ZYNQ!\n");
    printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");

    clear_interrupt();

    transfer_data();

    //usleep(10);  // add 10 micro seconds delay

	// re-enable the interrupt in the interrupt controller thru the
	// the UIO subsystem now that it's been handled

	write(gpio_fd, (void *)&reenable, sizeof(int));
}

int main() 
{

	int i;

    int uiofd0;  // BRAM
    int uiofd1;  // btns_5bits
    const char *uiod0 = "/dev/uio0";
    const char *uiod1 = "/dev/uio1";
    void *uioptr0;
    void *uioptr1;

    printf("-- Example program --\n");

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

	// mmap() the UIO devices
	uioptr0 = mmap(NULL, BRAM_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd0, 0);
	if (uioptr0 == MAP_FAILED) {
		printf("mmap call failure.\n");
		exit(-1);
	}

	uioptr1 = mmap(NULL, UIO_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd1, 0);
	if (uioptr1 == MAP_FAILED) {
		printf("mmap call failure.\n");
		exit(-1);
	}

	// Set file transfer source and destination
	source = (unsigned *) uioptr0;
	destination = (unsigned *) malloc(BRAM_SIZE);

	// Initialize source array
	numofwords = BRAM_SIZE/4;
    for (i=0; i<numofwords; i++)
        *(source+i) = i;

    // Set GPIO global variables
	gpio_fd = uiofd1;
	gpio_ptr = uioptr1;

	// Make the buttons to be input-only (5 bits)
	gpio_write(gpio_ptr, GPIO_TRI_OFFSET, 0x1F);

	// Enable the interrupts
	gpio_write(gpio_ptr, GPIO_GLOBAL_IRQ, 0x80000000);
	gpio_write(gpio_ptr, GPIO_IRQ_CONTROL, 0x1);


	// Prompt
    printf("-- Press BTND push button to interrupt --\n");
    //printf("-- Press BTNL push button to exit --\n");

    //unsigned int btns;

    while (1)
    {
    	wait_for_interrupt();
    	/*
    	btns = gpio_read(gpio_ptr1, 0x0);

    	if ((btns & 0x02) == 0x02) {  // BTND
    		printf("BTND is pressed\n");
    		printf("Wait for interrupt\n");
    		wait_for_interrupt();
    	}

        if ((btns & 0x04) == 0x04) {  // BTNL
            printf("BTNL is pressed\n");
            printf("Exiting\n");
            break;
        }
        */
    }

    /*
    // Validate destination array
    for (i=0; i<numofwords; i++)
        if (*(destination+i) != i)
            printf("Data transfer verification failed at %d!!\n", i);
    */

    printf("-- Exiting main() --\n");


    // Unmap the UIO devices
    munmap(uioptr0, BRAM_SIZE);
    munmap(uioptr1, UIO_SIZE);

    // Release memory
    free(destination);

    return 0;
}
