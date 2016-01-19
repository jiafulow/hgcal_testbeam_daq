ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

TRANSPORT = sk2_sc_transport
WRITETXN = sk2_sc_write_txn
READTXN = sk2_sc_read_txn

APPS = $(TRANSPORT) $(WRITETXN) $(READTXN)

# Add any other object files to this list below
TRANSPORT_OBJS = sk2_sc_transport.o IPbusLite.o
WRITETXN_OBJS = sk2_sc_write_txn.o IPbusLite.o
READTXN_OBJS = sk2_sc_read_txn.o IPbusLite.o

all: build install

build: $(APPS)

$(TRANSPORT): $(TRANSPORT_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(TRANSPORT_OBJS) $(LDLIBS)

$(WRITETXN): $(WRITETXN_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(WRITETXN_OBJS) $(LDLIBS)

$(READTXN): $(READTXN_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(READTXN_OBJS) $(LDLIBS)

clean:
	-rm -f $(APPS) *.elf *.gdb *.o

.PHONY: install image

install: $(APPS)
	$(TARGETINST) -d $(TRANSPORT) /bin/$(TRANSPORT)
	$(TARGETINST) -d $(WRITETXN) /bin/$(WRITETXN)
	$(TARGETINST) -d $(READTXN) /bin/$(READTXN)

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  clean                  clean out build objects"
	@echo "  all                    build $(INSTANCE) and install to rootfs host copy"
	@echo "  build                  build subsystem"
	@echo "  install                install built objects to rootfs host copy"
