#include "SKIROC2_SC.h"
#include "bitsets.h"


// Hardware definitions
#define SR_RST 0x3
#define SR_SEL 0x2
#define SR_BIT 0x1
#define SR_CLK 0x0

// Global variables
static unsigned char output_bytes[BITNSLOTS(8)];  // one byte
static unsigned int * destination;
static unsigned int * p_destination;

// Functions
inline void output_low(unsigned char bit) {
    BITCLEAR(output_bytes, bit);
}

inline void output_high(unsigned char bit) {
    BITSET(output_bytes, bit);
}

inline void write_to_destination() {
    *p_destination = output_bytes[0];
    ++p_destination;
}

// Transmit bytes serially, LSB first
// Reference: https://en.wikipedia.org/wiki/Bit_banging
void send_616bit_serial_data(uint640_t * data_full) {
    unsigned char data;  // data byte
    unsigned char * p_data = (unsigned char *) data_full;

    int i;

    output_low(SR_RST);

    // select device
    output_high(SR_SEL);

    // send bits 616..0
    for (i = 0; i < 616; i++) {
        // Move to next byte after 8 bits
        if ((i & 0x07) == 0) {  // faster equivalence of (i % 8 == 0)
            data = *p_data;
            ++p_data;
        }

        // consider rightmost bit
        // set line high if bit is 1, low if bit is 0
        if (data & 0x1)
            output_high(SR_BIT);
        else
            output_low(SR_BIT);

        // pulse clock to indicate that bit value should be read
        output_low(SR_CLK);
        write_to_destination();

        output_high(SR_CLK);
        write_to_destination();

        // shift byte right so next bit will be rightmost
        data >>= 1;
    }

    // deselect device
    output_low(SR_SEL);
}

// Bit bang
void bitbang()
{
    int i;
    int len;

    // Initialize
    skiroc2_slow_control_init();

    // Magic ??
    //*p_destination = 0x01234567;  // header
    //++p_destination;
    //*p_destination = 0x0000001F;  // select reset
    //++p_destination;
    //*p_destination = 0x0000000F;  // select set to config
    //++p_destination;

    // Transmit bytes serially
    send_616bit_serial_data(control_register);

    // Print
    len = p_destination - destination;
    p_destination = destination;

    for (i = 0; i < len; i++) {
        printf("0x%08x\n", *p_destination);
        ++p_destination;
    }

    return;
}

// main()
int main(int argc, char *argv[])
{
    // Output bytes
    output_bytes[0] = 0x0;

    // Output destination
    destination = (unsigned int *) malloc(2048*sizeof(unsigned int));
    p_destination = destination;

    // Bit bang
    bitbang();

    // Clean up
    free(destination);

    return 0;
}
