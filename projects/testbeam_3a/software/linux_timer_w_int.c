#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

#define UIO_SIZE 0x10000

#define IRQ_NUM 61

//#define XIL_AXI_TIMER_BASEADDR 0x42800000
#define XIL_AXI_TIMER_TCSR_OFFSET               0x0
#define XIL_AXI_TIMER_TLR_OFFSET                0x4
#define XIL_AXI_TIMER_TCR_OFFSET                0x8
#define XIL_AXI_TIMER_CSR_INT_OCCURED_MASK      0x00000100
#define XIL_AXI_TIMER_CSR_ENABLE_TMR_MASK       0x00000080
#define XIL_AXI_TIMER_CSR_ENABLE_INT_MASK       0x00000040
#define XIL_AXI_TIMER_CSR_LOAD_MASK             0x00000020
#define XIL_AXI_TIMER_CSR_AUTO_RELOAD_MASK      0x00000010

#define TIMER_RESET_VALUE                       0xF0000000

//static int InterruptFlag;

static void *timer_baseaddr;
static unsigned int *timer_baseaddr_u32;
static int timer_fd;
static unsigned int data;

inline void write32(void *base, unsigned int offset, unsigned int value)
{
	*((volatile unsigned *)(base + offset)) = value;
}

inline unsigned int read32(void *base, unsigned int offset)
{
	return *((volatile unsigned *)(base + offset));
}

inline void initialize_timer()
{
    write32(timer_baseaddr, XIL_AXI_TIMER_TLR_OFFSET,
    		TIMER_RESET_VALUE);
	data = read32(timer_baseaddr, XIL_AXI_TIMER_TLR_OFFSET);
	printf("Set timer reset value 0x%08X\n", data);

	write32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET,
			0x0);
	data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
	printf("Set timer mode 0x%08X\n", data);

	write32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET,
			XIL_AXI_TIMER_CSR_LOAD_MASK);
	data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
	printf("Set timer mode 0x%08X\n", data);

	write32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET,
			XIL_AXI_TIMER_CSR_ENABLE_INT_MASK | XIL_AXI_TIMER_CSR_AUTO_RELOAD_MASK);
	data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
	printf("Set timer mode 0x%08X\n", data);
}

inline void clear_interrupt()
{
    data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
    write32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET,
    		data | XIL_AXI_TIMER_CSR_INT_OCCURED_MASK);
    //data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
    //printf("Cleared interrupt. Set timer mode 0x%08X.\n", data);
}

inline void start_timer()
{
	write32(timer_baseaddr, XIL_AXI_TIMER_TCR_OFFSET,
			0x0);

	data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
	write32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET,
			data | XIL_AXI_TIMER_CSR_ENABLE_TMR_MASK);
	//data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
    //printf("Started the timer. Set timer mode 0x%08X.\n", data);
}

inline void stop_timer()
{
    data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
    write32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET,
    		data & ~(XIL_AXI_TIMER_CSR_ENABLE_TMR_MASK));
    //data = read32(timer_baseaddr, XIL_AXI_TIMER_TCSR_OFFSET);
    //printf("Stopped the timer. Set timer mode 0x%08X.\n", data);
}


void wait_for_interrupt()
{
	int pending = 0;
	int reenable = 1;

	printf("Wait for the Timer interrupt to trigger \n");
	printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");

	/* block on the file waiting for an interrupt */

	read(timer_fd, (void *)&pending, sizeof(int));

	printf("\n\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
	printf("Interrupting ZYNQ!\n");
	printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");

	/* the interrupt occurred so stop the timer and clear the interrupt and then
	 * wait til those are done before re-enabling the interrupt
	 */
	stop_timer();
	clear_interrupt();

	/* re-enable the interrupt again now that it's been handled */

	write(timer_fd, (void *)&reenable, sizeof(int));

	printf("\n\nExit interrupt \n\n");
}


int main()
{
    int i;
    int btns_check, sws_check;
    int ld9_toggle;

    int uiofd0;  // AXI timer
    int uiofd1;  // btns_8bits
    int uiofd2;  // leds_8bits
    int uiofd3;  // sws_8bits
    const char *uiod0 = "/dev/uio0";
    const char *uiod1 = "/dev/uio1";
    const char *uiod2 = "/dev/uio2";
    const char *uiod3 = "/dev/uio3";
    void *uioptr0;
    void *uioptr1;
    void *uioptr2;
    void *uioptr3;


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
	uioptr0 = mmap(NULL, UIO_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd0, 0);
	if (uioptr0 == MAP_FAILED) {
		printf("mmap call failure.\n");
		exit(-1);
	}

	uioptr1 = mmap(NULL, UIO_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd1, 0);
	if (uioptr1 == MAP_FAILED) {
		printf("mmap call failure.\n");
		exit(-1);
	}

	uioptr2 = mmap(NULL, UIO_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd2, 0);
	if (uioptr2 == MAP_FAILED) {
		printf("mmap call failure.\n");
		exit(-1);
	}

	uioptr3 = mmap(NULL, UIO_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uiofd3, 0);
	if (uioptr3 == MAP_FAILED) {
		printf("mmap call failure.\n");
		exit(-1);
	}

	// Initialize timer
	timer_baseaddr = uioptr0;
	timer_baseaddr_u32 = (unsigned int *) uioptr0;
	timer_fd = uiofd0;
	initialize_timer();

	//printf("TCSR0=0x%08X TLR0=0x%08X TCR0=0x%08X\n", read32(timer_baseaddr, 0x0), read32(timer_baseaddr, 0x4), read32(timer_baseaddr, 0x8));


    printf("-- Press BTNR push button to change the LD9 toggle --\n");
    printf("-- Press BTND push button to start the Timer interrupt --\n");
    printf("-- Press BTNL push button to exit --\n");
    printf("-- Change slide switches to see corresponding output on LEDs --\n");

    ld9_toggle = 0;
    //InterruptFlag = 0;

    while(1)
    {
    	btns_check = *((volatile unsigned *) uioptr1);
    	//printf("Buttons Status %x\n", btns_check);
    	sws_check = *((volatile unsigned *) uioptr3);
    	//printf("Switches Status %x\n", sws_check);

    	*((volatile unsigned *) uioptr2) = sws_check;

    	if ((btns_check & 0x08) == 0x08) {
            printf("BTNR is pressed\n");
            printf("Changing the LD9 toggle\n");
            ld9_toggle = !ld9_toggle;  // FIXME
    	}

    	if ((btns_check & 0x02) == 0x02) {
            printf("BTND is pressed\n");
            printf("Starting the Timer\n");
            // Start Timer
            start_timer();
            // Wait for interrupt
            wait_for_interrupt();
    	}

    	if ((btns_check & 0x04) == 0x04) {
            printf("BTNL is pressed\n");
            printf("Exiting\n");
            break;
    	}

    	for (i=0; i<999999999; i++); // delay loop
    }  // end while loop

	printf("-- Exiting main() --\n");

	// Unmap the UIO devices

	munmap(uioptr0, UIO_SIZE);
	munmap(uioptr1, UIO_SIZE);
	munmap(uioptr2, UIO_SIZE);
	munmap(uioptr3, UIO_SIZE);

    return 0;
}
