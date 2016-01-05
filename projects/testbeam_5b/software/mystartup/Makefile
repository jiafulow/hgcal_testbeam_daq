ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

APP = mystartup


all: build install

build: $(APP)

clean:

.PHONY: install image

install: $(APP)
	$(TARGETINST) -d autologin /bin/autologin
	$(TARGETINST) -d inittab /etc/inittab
	$(TARGETINST) -d -p 0755 mystartup /etc/init.d/mystartup
	$(TARGETINST) -s /etc/init.d/mystartup /etc/rc5.d/S99mystartup

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  clean                  clean out build objects"
	@echo "  all                    build $(INSTANCE) and install to rootfs host copy"
	@echo "  build                  build subsystem"
	@echo "  install                install built objects to rootfs host copy"
