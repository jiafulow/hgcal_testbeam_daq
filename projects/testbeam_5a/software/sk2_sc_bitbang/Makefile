ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

#CFLAGS += -O0
CFLAGS2 = $(subst -Os,-O0,$(CFLAGS))

APP = sk2_sc_bitbang

# Add any other object files to this list below
APP_OBJS = sk2_sc_bitbang.o

all: build install

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(APP_OBJS) $(LDLIBS)

clean:
	-rm -f $(APP) *.elf *.gdb *.o

.PHONY: install image

install: $(APP)
	$(TARGETINST) -d $(APP) /bin/$(APP)

%.o: %.c
#	@echo "  CFLAGS: $(CFLAGS)"
#	$(CC) -c $(CFLAGS) -o $@ $<
	@echo "  CFLAGS2: $(CFLAGS2)"
	$(CC) -c $(CFLAGS2) -o $@ $<

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  clean                  clean out build objects"
	@echo "  all                    build $(INSTANCE) and install to rootfs host copy"
	@echo "  build                  build subsystem"
	@echo "  install                install built objects to rootfs host copy"
