#ifndef _SKIROC2_SC_H_
#define _SKIROC2_SC_H_

#include "zed_system.h"


// Structs

struct item_t { const char *name; unsigned int nbits; unsigned int subaddr; unsigned int dvalue; };
typedef struct item_t item_t;

#define SKIROC2_SC_NBITS 616
#define SKIROC2_SC_NWORDS 20
struct uint640_t { unsigned int data[SKIROC2_SC_NWORDS]; };
typedef struct uint640_t uint640_t;

// Global variables

extern uint640_t * control_register;
extern const char * control_register_file;

// Functions

// Conversion string <--> uint640
void string_to_uint640(const char * string, uint640_t * data);

void uint640_to_string(uint640_t * data, char * string, int length);

// Look up using binary search
const item_t * skiroc2_slow_control_lookup_item(const char * key);

// Get and set functions
void skiroc2_slow_control_set(const item_t * item, unsigned int value);

unsigned int skiroc2_slow_control_get(const item_t * item);

// Peek and poke functions
void skiroc2_slow_control_poke(const char * key, unsigned int value);

unsigned int skiroc2_slow_control_peek(const char * key);

void skiroc2_slow_control_scan(unsigned int * values, int n);

// Init functions
void skiroc2_slow_control_reset();

void skiroc2_slow_control_init();  // from control_register_file

// Dump functions
void dump_table();

void dump_register();

void dump_register_to_file();  // to control_register_file

#endif  // _SKIROC2_SC_H_
