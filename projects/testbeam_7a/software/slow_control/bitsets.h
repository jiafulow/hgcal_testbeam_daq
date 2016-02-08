#ifndef _BITSETS_H_
#define _BITSETS_H_

// from http://c-faq.com/misc/bitsets.html

#include <limits.h>		/* for CHAR_BIT */

#define BITMASK(b) (1 << ((b) % CHAR_BIT))
#define BITSLOT(b) ((b) / CHAR_BIT)
#define BITSET(a, b) ((a)[BITSLOT(b)] |= BITMASK(b))
#define BITCLEAR(a, b) ((a)[BITSLOT(b)] &= ~BITMASK(b))
#define BITTEST(a, b) ((a)[BITSLOT(b)] & BITMASK(b))
#define BITNSLOTS(nb) ((nb + CHAR_BIT - 1) / CHAR_BIT)

// Count number of set bits
// from GNU compiler
#define POPCOUNT(x) (__builtin_popcount(x))

// Count leading zeros (assuming 32 bits)
// from GNU compiler
// NOTE: If x is 0, the result is undefined.
#define CLZ(x) (__builtin_clz(x))

// Find first (i.e. least significant) set bit
// from GNU compiler
#define FFS(x) (__builtin_ffs(x))

#endif  // _BITSETS_H_
