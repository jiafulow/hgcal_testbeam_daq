#include "ZynqIO.h"

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
