#include "IPbusLite.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>


// Create request transaction
int create_ipbus_txn(const Command * cmnd, Transaction * txn)
{
    static const int32_t nwords_max = 0xFF;  // 255, 8 bits
    int i;

    if (cmnd->nwords > nwords_max) {
        perror("ERROR: More than 255 words");
        exit(EXIT_FAILURE);
    }

    uint32_t * cur = (&(txn->data[0]));  // pointer to current word

    // Header
    *cur = create_ipbus_txn_header(cmnd->addr, cmnd->nwords, cmnd->type, cmnd->info);
    ++cur;

    // Data
    if (cmnd->type == IPBUS_TYPEID_WRITE) {
        for (i = 0; i < cmnd->nwords; i++) {
            *cur = create_ipbus_txn_data(cmnd->data[i]);
            ++cur;
        }
    }

    return cur - (&(txn->data[0]));  // number of words including header word
}

uint32_t create_ipbus_txn_header(uint32_t addr, uint16_t nwords, uint8_t type, uint8_t info)
{
    static const uint8_t protocol = IPBUS_PROTOCOL_VERSION;

    if (type != IPBUS_TYPEID_READ && type != IPBUS_TYPEID_WRITE) {
        perror("ERROR: Type ID is neither 'read' nor 'write'");
        exit(EXIT_FAILURE);
    }

    if (info != IPBUS_INFOCODE_REQUEST) {
        perror("ERROR: Info Code is not 'request'");
        exit(EXIT_FAILURE);
    }

    // Refers: uhal/TemplateDefinitions/ProtocolIPbus.hxx
    //return ( 0x20000000 | ( ( aTransactionId&0xfff ) <<16 ) | ( ( aWordCount&0xff ) <<8 ) | lType | ( aInfoCode&0xF ) );
    return ( ( ( protocol & 0xF   ) << 28 ) |
             ( ( addr     & 0xFFF ) << 16 ) |
             ( ( nwords   & 0xFF  ) <<  8 ) |
             ( ( type     & 0xF   ) <<  4 ) |
             ( ( info     & 0xF   ) <<  0 ) );
}

uint32_t create_ipbus_txn_data(uint32_t word)
{
    return ( word & 0xFFFFFFFF );
}

// Extract response transaction
int extract_ipbus_txn(const Transaction * txn, Command * cmnd)
{
    static const Command null_cmnd = {0};
    * cmnd = null_cmnd;  // zero out
    int i;

    const uint32_t * cur = (&(txn->data[0]));  // pointer to current word

    // Header
    extract_ipbus_txn_header(*cur, &(cmnd->addr), &(cmnd->nwords), &(cmnd->type), &(cmnd->info));
    ++cur;

    // Data
    if (cmnd->type == IPBUS_TYPEID_READ) {
        for (i = 0; i < cmnd->nwords; i++) {
            extract_ipbus_txn_data(*cur, &(cmnd->data[i]));
            ++cur;
        }
    }

    return cur - (&(txn->data[0]));  // number of words including header word
}

void extract_ipbus_txn_header(uint32_t header, uint32_t* addr, uint16_t* nwords, uint8_t* type, uint8_t* info)
{
    const uint8_t protocol = ( header >> 28 ) & 0xF;
                * addr     = ( header >> 16 ) & 0xFFF;
                * nwords   = ( header >>  8 ) & 0xFF;
                * type     = ( header >>  4 ) & 0xF;
                * info     = ( header >>  0 ) & 0xF;

    if (protocol != IPBUS_PROTOCOL_VERSION) {
        perror("ERROR: Protocol version is not 0");
        exit(EXIT_FAILURE);
    }

    if (*type != IPBUS_TYPEID_READ && *type != IPBUS_TYPEID_WRITE) {
        perror("ERROR: Type ID is neither 'read' nor 'write'");
        exit(EXIT_FAILURE);
    }

    if (*info != IPBUS_INFOCODE_RESPONSE) {
        perror("ERROR: Info Code is not 'response'");
        exit(EXIT_FAILURE);
    }
}

void extract_ipbus_txn_data(uint32_t data, uint32_t* word)
{
    * word = ( data & 0xFFFFFFFF );
}

// Dump
void dump_cmnd(const Command * cmnd)
{
    int i;

    printf("0x%08X\n", cmnd->addr);
    printf("0x%08X\n", cmnd->nwords);
    printf("0x%08X\n", cmnd->type);
    printf("0x%08X\n", cmnd->info);
    for (i = 0; i < cmnd->nwords; i++) {
        printf("0x%08X\n", cmnd->data[i]);
    }
}

void dump_txn(int nwords, const Transaction * txn)
{
    int i;

    const uint32_t * cur = (&(txn->data[0]));  // pointer to current word
    for (i = 0; i < nwords; i++) {
        printf("0x%08X\n", *cur);
        ++cur;
    }
}

// Fake a response to a request
int fake_ipbus_response(Transaction * txn)
{
    Command _cmnd = {0};
    Command * cmnd = &_cmnd;

    int i;

    uint32_t * cur = (&(txn->data[0]));  // pointer to current word

    // Fake header: change info code from 'request' to 'response'
    * cur &= ~IPBUS_INFOCODE_REQUEST;
    extract_ipbus_txn_header(*cur, &(cmnd->addr), &(cmnd->nwords), &(cmnd->type), &(cmnd->info));
    ++cur;

    // Fake data: enumerate 0 ... nwords
    if (cmnd->type == IPBUS_TYPEID_READ) {
        for (i = 0; i < cmnd->nwords; i++) {
            * cur = i;
            ++cur;
        }
    }

    return cur - (&(txn->data[0]));  // number of words including header word
}
