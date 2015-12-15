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
#include <ctype.h>  // for isspace
#include <errno.h>  // for strtol error

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

#define SK2_SC_NBITS 616
#define SK2_SC_NWORDS 20

struct uint640_t {
    unsigned int data[SK2_SC_NWORDS];
};

// Other definitions
//#define LED_DELAY 80000000
#define LED_DELAY 10000000

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

// from: http://en.cppreference.com/w/c/string/byte/strtoul
void string_to_uint640(const char * string, struct uint640_t * data) {
    const char * p = string;
    printf("Parsing '%s':\n", p);
    char * end;
    //long i;
    int i=0, j=0, jmax=SK2_SC_NWORDS;

    for (i = strtoul(p, &end, 16);
         p != end;
         i = strtoul(p, &end, 16), j++)
    {
    	if (j >= jmax) {
            printf("length error, got j=%d\n", j);
        }

        //printf("'%.*s' -> ", (int)(end-p), p);
        //printf("0x%08x\n", i);
        p = end;
        while (isspace(*p))
            p++;
        if (errno == ERANGE) {
            printf("range error, got i=%d\n", i);
            errno = 0;
        }
        data->data[jmax-j-1] = i;
    }
}

void uint640_to_string(struct uint640_t * data, char * string) {
	char * p = string;
	int i=0, j=0, jmax=SK2_SC_NWORDS;
	int length=200;

    for (j=0; j<jmax; j++) {
    	if (j==0)
    		i = snprintf(p, length, "%08x", data->data[jmax-j-1]);
    	else
    		i = snprintf(p, length, " %08x", data->data[jmax-j-1]);

        p += i;
        length -= i;
    }
    printf("Parsed '%s'.\n", string);
}

void send_616bit_serial_data(struct uint640_t * data_full) {
	unsigned char data;  // data byte
	unsigned int data_word;
	int i=0, j=0, jmax=SK2_SC_NWORDS, k=0;
	int delay;

	// ?
	output_low(SR_OUT);

	// select device
	output_high(SR_EN);

	// send bits 640..(640-616)
	for (i=0; i<616; i++) {

		// Move to next word after 32 bits
		if ((i & 0x1F) == 0) {  // faster equivalence of (i % 32 == 0)
			data_word = data_full->data[jmax-j-1];
			printf("Write word %d: 0x%08x.\n", j, data_full->data[jmax-j-1]);

			j += 1;
			k = 0;
		}

		// Move to next byte after 8 bits
		if ((i & 0x07) == 0) {  // faster equivalence of (i % 8 == 0)
			data = (data_word & 0xFF000000) >> 24;
			printf("Write byte %d: 0x%02x (0b%s).\n", k, data, byte_to_binary(data));

			data_word <<= 8;
			k += 1;
		}

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
    debug = 0;
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

    debug = 0;
    if (debug) {
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

    // Write

    {
        destination = (unsigned *) uio0_ptr;
        dest_register[0] = 0x0;

        struct uint640_t control_register;

        //control_register.data[0] = 0x00000000;
        //control_register.data[1] = 0x11111111;
        //control_register.data[2] = 0x22222222;
        //control_register.data[3] = 0x33333333;
        //control_register.data[4] = 0x44444444;
        //control_register.data[5] = 0x55555555;
        //control_register.data[6] = 0x66666666;
        //control_register.data[7] = 0x77777777;
        //control_register.data[8] = 0x88888888;
        //control_register.data[9] = 0x99999999;
        //control_register.data[10] = 0xAAAAAAAA;
        //control_register.data[11] = 0xBBBBBBBB;
        //control_register.data[12] = 0xCCCCCCCC;
        //control_register.data[13] = 0xDDDDDDDD;
        //control_register.data[14] = 0xEEEEEEEE;
        //control_register.data[15] = 0xFFFFFFFF;
        //control_register.data[16] = 0x00000000;
        //control_register.data[17] = 0x11111111;
        //control_register.data[18] = 0x22222222;
        //control_register.data[19] = 0x33333333;

        const char * string = "33333333 22222222 11111111 00000000 FFFFFFFF "
            "EEEEEEEE DDDDDDDD CCCCCCCC BBBBBBBB AAAAAAAA "
            "99999999 88888888 77777777 66666666 55555555 "
            "44444444 33333333 22222222 11111111 00000000";
        string_to_uint640(string, &control_register);

        // Sanity check
        {
            char string2[200];
            uint640_to_string(&control_register, string2);
        }

        send_616bit_serial_data(&control_register);

        printf("Write finish\n");
    }

    printf("-- Example program ends --\n");

    // Unmap the UIO devices
    munmap(uio0_ptr, UIO0_SIZE);

    return 0;
}
