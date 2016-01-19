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


// Structs

struct Command
{
    uint32_t addr;
    uint16_t nwords;
    uint8_t type;
    uint8_t info;
    uint32_t data[255];  // maximum is 255 data words
};
typedef struct Command Command;

struct Transaction
{
    uint32_t data[256];  // maximum is 1 header word + 255 data words
};
typedef struct Transaction Transaction;


// Functions

// Create request transaction
int create_ipbus_txn(const Command * cmnd, Transaction * txn);
uint32_t create_ipbus_txn_header(uint32_t addr, uint16_t nwords, uint8_t type, uint8_t info);
uint32_t create_ipbus_txn_data(uint32_t word);

// Extract response transaction
int extract_ipbus_txn(const Transaction * txn, Command * cmnd);
void extract_ipbus_txn_header(uint32_t header, uint32_t* addr, uint16_t* nwords, uint8_t* type, uint8_t* info);
void extract_ipbus_txn_data(uint32_t data, uint32_t* word);

// Dump
void dump_cmnd(const Command * cmnd);
void dump_txn(int nwords, const Transaction * txn);

// Fake a response to a request
int fake_ipbus_response(Transaction * txn);


#endif  // _IPBUSLITE_H_
