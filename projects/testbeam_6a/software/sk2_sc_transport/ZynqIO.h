#ifndef _ZYNQIO_H_
#define _ZYNQIO_H_

#include <stdint.h>
#include <stddef.h>

inline void volatile_write_byte(void *base, uint32_t offset, uint8_t value);

inline uint8_t volatile_read_byte(void *base, uint32_t offset);

inline void volatile_write_word(void *base, uint32_t offset, uint32_t value);

inline uint32_t volatile_read_word(void *base, uint32_t offset);

#endif  // _ZYNQIO_H_

