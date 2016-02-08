#!/bin/sh

CONFIGURE="_sk2_sc_configure"

# Write the bit bang command
sk2_sc_bitbang > $CONFIGURE

# For each line in the bit bang command, write to the 
# address 0x01 using the IPbusLite protocol
while read -r LINE
do
    #echo "Text read from file: $LINE"

    sk2_sc_write_txn 0x01 1 $LINE | xargs sk2_sc_send_mem
done < $CONFIGURE

