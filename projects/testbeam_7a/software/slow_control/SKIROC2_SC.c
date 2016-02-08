#include "SKIROC2_SC.h"
#include "SKIROC2_SC_hw.h"

#include <string.h>  // for strcmp
#include <ctype.h>  // for isspace
#include "bitsets.h"

#define REVERSE_BIT_ORDER

uint640_t control_register_instance;
uint640_t * control_register = &control_register_instance;
const char * control_register_file = "_sk2_sc_cur_state";

// Conversion string <--> uint640
// from: http://en.cppreference.com/w/c/string/byte/strtoul
void string_to_uint640(const char * string, uint640_t * data) {
    const char * p = string;
    char * end;
    unsigned long i;
    int j=0;

    for (i = strtoul(p, &end, 16); p != end; i = strtoul(p, &end, 16)) {
        p = end;
        while (isspace(*p))
            p++;
        if (errno == ERANGE) {
            fprintf(stderr, "range error, got %lu\n", i);
            errno = 0;
        }
        data->data[j] = i;
        j++;
    }
}

void uint640_to_string(uint640_t * data, char * string, int length) {
    char * p = string;
    int i=0;
    int j=0;

    for (j=0; j<SKIROC2_SC_NWORDS; j++) {
        if (j%4 != 3) {
            i = snprintf(p, length, "0x%08X ", data->data[j]);
            //printf("0x%08X ", data->data[j]);
        } else {
            i = snprintf(p, length, "0x%08X \n", data->data[j]);
            //printf("0x%08X \n", data->data[j]);
        }
        p += i;
        length -= i;
    }
    //printf("actual length: %d.\n", length);
}

// Look up using binary search
const item_t * skiroc2_slow_control_lookup_item(const char * key)
{
    int len = LOOKUP_TABLE_SIZE;  // skip the last item, which is NULL
    int half_len;
    int cmp;

    const item_t * first = (item_t *) (&lookup_table[0]);
    const item_t * last = first + len;
    const item_t * middle;

    while (len > 0) {
        half_len = len/2;
        middle = first + half_len;
        cmp = strcmp(key, middle->name);
        if (cmp == 0) {
            return middle;
        } else if (cmp > 0) {
            first = ++middle;
            len -= (half_len + 1);
        } else {
            len = half_len;
        }
    }
    return last;
}

// Get and set functions
void skiroc2_slow_control_set(const item_t * item, unsigned int value) {
    if (item->nbits <= 0) {
        fprintf(stderr, "Invalid number of bits for register %s.\n", item->name);
        exit(EXIT_FAILURE);
    }

    int i;
    int offset = item->subaddr;
    char * bitarray = (char *) control_register;

#ifdef REVERSE_BIT_ORDER
    int value2 = 0;
    for (i = 0; i < item->nbits; ++i) {
        value2 <<= 1;
        value2 |= (value & 1);
        value >>= 1;
    }
    value = value2;
#endif

    for (i = 0; i < item->nbits; ++i) {
        if (value & (1<<i)) {
            BITSET(bitarray, offset+i);
        } else {
            BITCLEAR(bitarray, offset+i);
        }
    }
}

unsigned int skiroc2_slow_control_get(const item_t * item) {
    if (item->nbits <= 0) {
        fprintf(stderr, "Invalid number of bits for register %s.\n", item->name);
        exit(EXIT_FAILURE);
    }

    int i;
    int offset = item->subaddr;
    char * bitarray = (char *) control_register;

    unsigned int value = 0;
    for (i = 0; i < item->nbits; ++i) {
        if (BITTEST(bitarray, offset+i)) {
            value |= (1<<i);
        }
    }

#ifdef REVERSE_BIT_ORDER
    int value2 = 0;
    for (i = 0; i < item->nbits; ++i) {
        value2 <<= 1;
        value2 |= (value & 1);
        value >>= 1;
    }
    value = value2;
#endif

    return value;
}

// Peek and poke functions
void skiroc2_slow_control_poke(const char * key, unsigned int value)
{
    const item_t * item = skiroc2_slow_control_lookup_item(key);

    if (item->name == NULL) {
        fprintf(stderr, "Cannot find register name %s.\n", key);
        exit(EXIT_FAILURE);
    } else {
        skiroc2_slow_control_set(item, value);
    }
}

unsigned int skiroc2_slow_control_peek(const char * key)
{
    const item_t * item = skiroc2_slow_control_lookup_item(key);
    unsigned int value = 0xFFFFFFFF;

    if (item->name == NULL) {
        fprintf(stderr, "Cannot find register name %s.\n", key);
        exit(EXIT_FAILURE);
    } else {
        value = skiroc2_slow_control_get(item);
    }
    return value;
}

void skiroc2_slow_control_scan(unsigned int * values, int n)
{
    int i;
    const char * name;

    if (n < LOOKUP_TABLE_SIZE) {
        fprintf(stderr, "Output array size must be >= %d.\n", LOOKUP_TABLE_SIZE);
        exit(EXIT_FAILURE);
    }

    for (i = 0; i < LOOKUP_TABLE_SIZE; i++) {
        name = lookup_table_names_ordered[i];
        values[i] = skiroc2_slow_control_peek(name);
    }
}

// Init functions
void skiroc2_slow_control_reset()
{
    int i;
    const item_t * item = &(lookup_table[0]);

    // Zero out the register
    for (i = 0; i < SKIROC2_SC_NWORDS; i++) {
        control_register->data[i] = 0;
    }

    // Set default values
    for (i = 0; i < LOOKUP_TABLE_SIZE; i++, item++) {
        skiroc2_slow_control_set(item, item->dvalue);
    }

    dump_register_to_file();
}

void skiroc2_slow_control_init()
{
    int fd;
    fd = open(control_register_file, O_RDONLY);
    if (fd < 1) {
        skiroc2_slow_control_reset();
    }

    int length = 226;  // (11*3 + 12)*5 + 1
    char string[length];
    read(fd, string, length);

    string_to_uint640(string, control_register);
    close(fd);
}

// Dump functions
void dump_table()
{
    int i;
    const item_t * item = &(lookup_table[0]);

    for (i = 0; i < LOOKUP_TABLE_SIZE; i++, item++) {
        fprintf(stderr, "%s, %d, %d, %d\n", item->name, item->nbits, item->subaddr, item->dvalue);
    }
}

void dump_register()
{
    int length = 226;  // (11*3 + 12)*5 + 1
    char string[length];
    uint640_to_string(control_register, string, length);

    printf("%s", string);
}

void dump_register_to_file()
{
    int fd;
    fd = open(control_register_file, O_RDWR | O_CREAT | O_TRUNC, 0644);
    if (fd < 1) {
        fprintf(stderr, "Cannot write file: %s.\n", control_register_file);
        exit(EXIT_FAILURE);
    }

    int length = 226;  // (11*3 + 12)*5 + 1
    char string[length];
    uint640_to_string(control_register, string, length);

    write(fd, string, length-1);
    close(fd);
}
