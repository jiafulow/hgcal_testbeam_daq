#ifndef _IPBUSLITE_H_
#define _IPBUSLITE_H_

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

// Transport Layer protocol - loosely based on the IPBus protocol v2.0
// except the "Transaction ID" field is replaced with an "Address" field.
//
// | 31 ... 28 | 27 ... 16 | 15 ...  8 |  7 ...  4 |  3 ...  0 |
// |-----------|-----------|-----------|-----------|-----------|
// | Protocol  | Starting  | Number of | Type ID   | Info code |
// | version   | address   | words     |           |           |
// | (4 bits)  | (12 bits) | (8 bits)  | (4 bits)  | (4 bits)  |
//
// - Protocol version: reserved, currently 0.
// - Starting address: the intended address for this transaction. The
//                     address auto-increments with each word.
// - Number of words : length of transaction (0-255, 8 bits), excluding
//                     the command word.
// - Type ID         : 0x0 - read
//                     0x1 - write
// - Info code       : 0x0 - response
//                     0xF - request


// Definitions
#define IPBUS_PROTOCOL_VERSION  0
#define IPBUS_TYPEID_READ       0x0
#define IPBUS_TYPEID_WRITE      0x1
#define IPBUS_INFOCODE_RESPONSE 0x0
#define IPBUS_INFOCODE_REQUEST  0xF


// Functions

// Create request transaction
uint32_t create_ipbus_txn_header(uint32_t addr, uint32_t nwords, uint8_t type, uint8_t info);
uint32_t create_ipbus_write_txn_header(uint32_t addr, uint32_t nwords);
uint32_t create_ipbus_read_txn_header(uint32_t addr, uint32_t nwords);

// Extract response transaction
void extract_ipbus_txn_header(uint32_t header, uint32_t* addr, uint32_t* nwords, uint8_t* type, uint8_t* info);
void extract_ipbus_response_txn_header(uint32_t header, uint32_t* addr, uint32_t* nwords);

#endif  // _IPBUSLITE_H_
