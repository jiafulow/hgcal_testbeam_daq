#include "IPbusLite.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>


// Create request transaction
uint32_t create_ipbus_txn_header(uint32_t addr, uint32_t nwords, uint8_t type, uint8_t info)
{
    static const uint8_t protocol = IPBUS_PROTOCOL_VERSION;

    if (nwords > 0xFF) {  // 255, 8-bits
        fprintf(stderr, "ERROR: More than 255 words");
        exit(EXIT_FAILURE);
    }

    if (type != IPBUS_TYPEID_READ && type != IPBUS_TYPEID_WRITE) {
        fprintf(stderr, "ERROR: Type ID is neither 'read' nor 'write'");
        exit(EXIT_FAILURE);
    }

    if (info != IPBUS_INFOCODE_REQUEST) {
        fprintf(stderr, "ERROR: Info Code is not 'request'");
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

uint32_t create_ipbus_write_txn_header(uint32_t addr, uint32_t nwords) {
    return create_ipbus_txn_header(addr, nwords, IPBUS_TYPEID_WRITE, IPBUS_INFOCODE_REQUEST);
}

uint32_t create_ipbus_read_txn_header(uint32_t addr, uint32_t nwords) {
    return create_ipbus_txn_header(addr, nwords, IPBUS_TYPEID_READ, IPBUS_INFOCODE_REQUEST);
}

// Extract response transaction
void extract_ipbus_txn_header(uint32_t header, uint32_t* addr, uint32_t* nwords, uint8_t* type, uint8_t* info)
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

void extract_ipbus_response_txn_header(uint32_t header, uint32_t* addr, uint32_t* nwords)
{
    // FIXME: Fake a response to a request
    header &= ~IPBUS_INFOCODE_REQUEST;

    uint8_t type;
    uint8_t info;

    extract_ipbus_txn_header(header, addr, nwords, &type, &info);
}
