##################################################
# flawfinder rules
##################################################


#
# source
#
FLAWFINDER_VERSION ?= 2.0.20
FLAWFINDER_SRC_DIR := $(STATIC_CHECK_TOP_DIR)/src/flawfinder-$(FLAWFINDER_VERSION)


#
# build
#
FLAWFINDER_BUILD_DIR := $(STATIC_CHECK_BUILD_DIR)/flawfinder


#
# install
#
FLAWFINDER_BIN_DIR := $(STATIC_CHECK_BIN_DIR)


FLAWFINDER_BIN := $(FLAWFINDER_BIN_DIR)/flawfinder



##################################################
# Public target
##################################################

.PHONY: flawfinder

flawfinder: $(FLAWFINDER_BIN)

##################################################
# Build
##################################################

$(FLAWFINDER_BIN):
	@echo "================================="
	@echo " Build flawfinder"
	@echo " Source : $(FLAWFINDER_SRC_DIR)"
	@echo " Build  : $(FLAWFINDER_BUILD_DIR)"
	@echo "================================="

	rm -rf $(FLAWFINDER_BUILD_DIR)

	mkdir -p $(FLAWFINDER_BUILD_DIR)
	mkdir -p $(FLAWFINDER_BIN_DIR)

	cp -a $(FLAWFINDER_SRC_DIR)/. $(FLAWFINDER_BUILD_DIR)/


	cp $(FLAWFINDER_BUILD_DIR)/flawfinder.py \
	$(FLAWFINDER_BIN)

	chmod +x $(FLAWFINDER_BIN)

	@echo ""
	@echo "flawfinder installed:"
	@echo $(FLAWFINDER_BIN)

##################################################
# Clean
##################################################

.PHONY: flawfinder-clean

flawfinder-clean:
	rm -rf $(FLAWFINDER_BUILD_DIR)
	rm -f $(FLAWFINDER_BIN)
