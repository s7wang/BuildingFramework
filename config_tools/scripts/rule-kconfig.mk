#
# rule-kconfig.mk directory
#
KCONFIG_RULE_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

#
# project root
#
KCONFIG_TOP_DIR := $(realpath $(KCONFIG_RULE_DIR)/..)

#
# Generic Kconfig build rule
#
ifndef KCONFIG_DEFCONFIG
KCONFIG_DEFCONFIG := $(KCONFIG_TOP_DIR)/configs/defconfig
endif

ifndef KCONFIG_DIR
KCONFIG_DIR := $(KCONFIG_TOP_DIR)/kconfig
endif

#
# Kconfig source
#
ifndef KCONFIG_FILE
KCONFIG_FILE := $(KCONFIG_TOP_DIR)/Kconfig
endif

#
# Kconfig output directory
#
ifndef KCONFIG_OUTPUT
KCONFIG_OUTPUT := $(KCONFIG_TOP_DIR)/build
endif

#
# Config file
#
ifndef KCONFIG_CONFIG
KCONFIG_CONFIG := $(KCONFIG_OUTPUT)/.config
endif

#
# Generated config files
#
ifndef KCONFIG_AUTOCONFIG
KCONFIG_AUTOCONFIG := $(KCONFIG_OUTPUT)/include/config/auto.conf
endif

ifndef KCONFIG_AUTOHEADER
KCONFIG_AUTOHEADER := $(KCONFIG_OUTPUT)/include/generated/autoconf.h
endif

#
# Kconfig binaries
#
ifndef KCONFIG_BIN_DIR
KCONFIG_BIN_DIR := $(KCONFIG_OUTPUT)/bin
endif

ifndef KCONFIG_CONF
KCONFIG_CONF := $(KCONFIG_BIN_DIR)/conf
endif

ifndef KCONFIG_MCONF
KCONFIG_MCONF := $(KCONFIG_BIN_DIR)/mconf
endif

#
# Build tools
#
HOSTCC ?= gcc

#
# Compile kconfig tools
#
$(KCONFIG_BIN_DIR):
	mkdir -p $@


$(KCONFIG_CONF): $(KCONFIG_DIR)
	@echo "Build kconfig conf"

	mkdir -p $(KCONFIG_BIN_DIR)

	$(MAKE) -C $(KCONFIG_DIR)

	cp $(KCONFIG_DIR)/conf $@


$(KCONFIG_MCONF): $(KCONFIG_DIR)
	@echo "Build kconfig mconf"

	mkdir -p $(KCONFIG_BIN_DIR)

	$(MAKE) -C $(KCONFIG_DIR) mconf

	cp $(KCONFIG_DIR)/mconf $@


#
# Check tool
#
.PHONY: kconfig-tools

kconfig-tools:
	@if [ ! -x "$(KCONFIG_CONF)" ]; then \
		$(MAKE) $(KCONFIG_CONF); \
	else \
		echo "Use existing $(KCONFIG_CONF)"; \
	fi

	@if [ ! -x "$(KCONFIG_MCONF)" ]; then \
		$(MAKE) $(KCONFIG_MCONF); \
	else \
		echo "Use existing $(KCONFIG_MCONF)"; \
	fi



#
# Generate .config
#
.PHONY: oldconfig

oldconfig: kconfig-tools
	@mkdir -p $(KCONFIG_OUTPUT)

	cd $(KCONFIG_OUTPUT) && \
	$(KCONFIG_CONF) \
		--oldconfig \
		$(KCONFIG_FILE)


.PHONY: defconfig

defconfig: kconfig-tools
	@mkdir -p $(KCONFIG_OUTPUT)

	cd $(KCONFIG_OUTPUT) && \
	$(KCONFIG_CONF) \
		--defconfig=$(KCONFIG_DEFCONFIG) \
		$(KCONFIG_FILE)


#
# menuconfig
#
.PHONY: menuconfig

menuconfig: kconfig-tools
	@mkdir -p $(KCONFIG_OUTPUT)

	cd $(KCONFIG_OUTPUT) && \
	$(KCONFIG_MCONF) \
		$(KCONFIG_FILE)


#
# Generate headers
#
.PHONY: syncconfig

syncconfig: defconfig kconfig-tools
	@mkdir -p $(dir $(KCONFIG_AUTOCONFIG))
	@mkdir -p $(dir $(KCONFIG_AUTOHEADER))

	cd $(KCONFIG_OUTPUT) && \
	KCONFIG_AUTOCONFIG="$(KCONFIG_AUTOCONFIG)" \
	KCONFIG_AUTOHEADER="$(KCONFIG_AUTOHEADER)" \
	$(KCONFIG_CONF) --syncconfig $(KCONFIG_FILE)

	@test -f "$(KCONFIG_AUTOCONFIG)" || \
		(echo "[ERROR] Kconfig output not generated: $(KCONFIG_AUTOCONFIG)"; exit 1)

	@echo "[SUCCESS] Generated $(KCONFIG_AUTOCONFIG)"


#
# Clean Kconfig generated files
#
.PHONY: clean-kconfig

clean-kconfig:
	@echo "Clean kconfig output"
	rm -rf $(KCONFIG_OUTPUT)/include
	rm -rf $(KCONFIG_CONFIG) $(KCONFIG_AUTOCONFIG) $(KCONFIG_AUTOHEADER)


#
# Clean Kconfig host tools
#
.PHONY: clean-kconfig-tools

clean-kconfig-tools:
	@echo "Clean kconfig tools"
	$(MAKE) -C $(KCONFIG_DIR) clean
	rm -rf $(KCONFIG_CONF) $(KCONFIG_MCONF)

#
# Full clean
#
.PHONY: distclean-kconfig

distclean-kconfig:
	@echo "Clean all kconfig files"
	rm -rf $(KCONFIG_OUTPUT)/include
	$(MAKE) -C $(KCONFIG_DIR) clean
	rm -rf $(KCONFIG_CONF) $(KCONFIG_MCONF)
	rm -rf $(KCONFIG_CONFIG) $(KCONFIG_AUTOCONFIG) $(KCONFIG_AUTOHEADER)