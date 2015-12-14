/*
 * An example of sending 616 bits using bit bang.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>  // for memcpy

// Macros to set bits
// from: http://c-faq.com/misc/bitsets.html
#include <limits.h>
#define BITMASK(b) (1 << ((b) % CHAR_BIT))
#define BITSLOT(b) ((b) / CHAR_BIT)
#define BITSET(a, b) ((a)[BITSLOT(b)] |= BITMASK(b))
#define BITCLEAR(a, b) ((a)[BITSLOT(b)] &= ~BITMASK(b))
#define BITTEST(a, b) ((a)[BITSLOT(b)] & BITMASK(b))
#define BITNSLOTS(nb) ((nb + CHAR_BIT - 1) / CHAR_BIT)

// Hardware/Firmware definition
#define UIO0_SIZE 0x10000

#define SR_OUT 0x0
#define SR_EN  0x1
#define SR_CK  0x2
#define SR_IN  0x3

// Other definitions
#define LED_DELAY 80000000

// Static variables
static unsigned * destination;
static unsigned char dest_register[BITNSLOTS(8)];

// Functions
inline void gpio_write(void *gpio_base, unsigned int offset, unsigned int value)
{
    *((volatile unsigned *)(gpio_base + offset)) = value;
}

inline unsigned int gpio_read(void *gpio_base, unsigned int offset)
{
    return *((volatile unsigned *)(gpio_base + offset));
}

void output_low(unsigned char bit) {
    BITCLEAR(dest_register, bit);
}

void output_high(unsigned char bit) {
    BITSET(dest_register, bit);
}

void write_to_register() {
    *((volatile unsigned char *)(destination)) = dest_register[0];
}

// Print 8 bits in binary
// from: http://stackoverflow.com/questions/111928/is-there-a-printf-converter-to-print-in-binary-format
const char *byte_to_binary(int x)
{
    static char b[9];
    b[0] = '\0';

    int z;
    for (z = 128; z > 0; z >>= 1)
    {
        strcat(b, ((x & z) == z) ? "1" : "0");
    }

    return b;
}

// Transmit byte serially, MSB first
// from: https://en.wikipedia.org/wiki/Bit_banging
void send_8bit_serial_data(unsigned char data) {
    int i;
    int delay;

    // ?
    output_low(SR_OUT);

    // select device
    output_high(SR_EN);

    // send bits 7..0
    for (i=0; i<8; i++) {

        //for (delay = 0; delay < LED_DELAY; delay++);

        // consider leftmost bit
        // set line high if bit is 1, low if bit is 0
        if (data & 0x80)
            output_high(SR_IN);
        else
            output_low(SR_IN);

        // pulse clock to indicate that bit value should be read
        output_low(SR_CK);

        printf("-- write to register: 0x%02x (0b%s)\n", dest_register[0], byte_to_binary(dest_register[0]));
        write_to_register();
        for (delay = 0; delay < LED_DELAY; delay++);

        // pulse clock to indicate that bit value should be read
        output_high(SR_CK);

        printf("-- write to register: 0x%02x (0b%s)\n", dest_register[0], byte_to_binary(dest_register[0]));
        write_to_register();
        for (delay = 0; delay < LED_DELAY; delay++);

        // shift byte left so next bit will be leftmost
        data <<= 1;
    }

    // deselect device
    output_low(SR_EN);
}


// Main function
int main()
{

    int i;
    int debug;
    int delay;

    int uio0_fd;
    const char *uio0_d = "/dev/uio0";
    void *uio0_ptr;

    printf("-- Example program begins --\n");

    // Debug
    debug = 1;
    if (debug) {
        printf("[debug] CHAR_BIT: %d\n", CHAR_BIT);
        printf("[debug] BITNSLOTS(8): %d\n", BITNSLOTS(8));

        for (i=0; i<CHAR_BIT; i++) {
            dest_register[0] = 0x0;
            printf("[debug] BITSET(register,%d): 0x%02x\n", i, BITSET(dest_register,i));
        }
    }



    // Open the UIO devices
    uio0_fd = open(uio0_d, O_RDWR);
    if (uio0_fd < 1) {
        printf("Invalid UIO device file:%s.\n", uio0_d);
        exit(-1);
    }

    // mmap() the UIO devices
    uio0_ptr = mmap(NULL, UIO0_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, uio0_fd, 0);
    if (uio0_ptr == MAP_FAILED) {
        printf("mmap call failure.\n");
        exit(-1);
    }

    // Write

    debug = 0;
    if (debug) {
        destination = (unsigned *) uio0_ptr;
        dest_register[0] = 0xFF;

        printf("\n");
        printf("Writing 0x%02x (0b%s).\n", dest_register[0], byte_to_binary(dest_register[0]));

        gpio_write(destination, 0, dest_register[0]);
        for (delay = 0; delay < LED_DELAY; delay++);

        printf("Write finish\n");
    }

    // Write

    {
        destination = (unsigned *) uio0_ptr;
        dest_register[0] = 0x0;

        int test_data[8] = {0, 255, 127, 128, 13, 82, 148, 223};

        for (i=0; i<8; i++) {
            printf("\n");
            printf("Writing 0x%02x (0b%s) by bit-banging via 4 lines, MSB first.\n", test_data[i], byte_to_binary(test_data[i]));
            printf("line  0  : sr_out\n");
            printf("line  1  : sr_en\n");
            printf("line  2  : sr_ck\n");
            printf("line  3  : sr_in\n");
            printf("lines 4-7: not connected\n");

            send_8bit_serial_data(test_data[i]);

            printf("Write finish\n");
        }
    }

    printf("-- Example program ends --\n");

    // Unmap the UIO devices
    munmap(uio0_ptr, UIO0_SIZE);

    return 0;
}
