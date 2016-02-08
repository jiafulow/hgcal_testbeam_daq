#include "zed_system.h"
#include "bitsets.h"

// Read or write functions
inline void volatile_write_byte(void *base, uint32_t offset, uint8_t value)
{
    *((volatile uint8_t *)(base + offset)) = value;
}

inline uint8_t volatile_read_byte(void *base, uint32_t offset)
{
    return *((volatile uint8_t *)(base + offset));
}

inline void volatile_write_word(void *base, uint32_t offset, uint32_t value)
{
    *((volatile uint32_t *)(base + offset)) = value;
}

inline uint32_t volatile_read_word(void *base, uint32_t offset)
{
    return *((volatile uint32_t *)(base + offset));
}

// Print in binary format
void print_binary(uint32_t number)
{
    printf("0b");
    if (number == 0) {
        printf("0");
    } else {
        int places = 32 - CLZ(number);  // if number is 0, CLZ is undefined
        while(places > 0) {
            //printf("%d", (number & (1 << places)));
            printf((number & (1 << (places-1))) ? "1" : "0");
            places--;
        }
    }
}

void print_binary_8bits(uint32_t number)
{
    printf("0b");

    int places = 8;
    while(places > 0) {
        //printf("%d", (number & (1 << places)));
        printf((number & (1 << (places-1))) ? "1" : "0");
        places--;
    }
}

void print_binary_32bits(uint32_t number)
{
    printf("0b");

    int places = 32;
    while(places > 0) {
        //printf("%d", (number & (1 << places)));
        printf((number & (1 << (places-1))) ? "1" : "0");
        places--;
    }
}
