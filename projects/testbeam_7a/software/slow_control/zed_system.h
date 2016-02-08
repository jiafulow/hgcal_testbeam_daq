#ifndef _ZED_SYSTEM_H_
#define _ZED_SYSTEM_H_

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>


// Read or write functions
inline void volatile_write_byte(void *base, uint32_t offset, uint8_t value);

inline uint8_t volatile_read_byte(void *base, uint32_t offset);

inline void volatile_write_word(void *base, uint32_t offset, uint32_t value);

inline uint32_t volatile_read_word(void *base, uint32_t offset);

// Print in binary format
void print_binary(uint32_t number);

void print_binary_8bits(uint32_t number);

void print_binary_32bits(uint32_t number);

#endif // _ZED_SYSTEM_H_
