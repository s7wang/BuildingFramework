#
# cppcheck build rules
#


#
# source
#
CPPCHECK_VERSION ?= 2.21.1
CPPCHECK_SRC_DIR ?= $(STATIC_CHECK_TOP_DIR)/src/cppcheck-$(CPPCHECK_VERSION)

CPPCHECK_BUILD_DIR ?= $(STATIC_CHECK_TOP_DIR)/build/cppcheck

CPPCHECK_BIN := $(STATIC_CHECK_BIN_DIR)/cppcheck


##################################################
# Compile options
##################################################
CPPCHECK_MAKE_JOBS ?= $(shell nproc)


##################################################
# Public targets
##################################################
.PHONY: cppcheck
cppcheck: $(CPPCHECK_BIN)



##################################################
# Build cppcheck
##################################################

$(CPPCHECK_BIN):
	@echo "===================================="
	@echo " Build cppcheck"
	@echo " Source : $(CPPCHECK_SRC_DIR)"
	@echo " Build  : $(CPPCHECK_BUILD_DIR)"
	@echo "===================================="

	mkdir -p $(CPPCHECK_BUILD_DIR)
	mkdir -p $(STATIC_CHECK_BIN_DIR)

	cd $(CPPCHECK_BUILD_DIR) && \
	cmake \
		$(CPPCHECK_SRC_DIR) \
		-DCMAKE_BUILD_TYPE=Release


	cmake --build \
		$(CPPCHECK_BUILD_DIR) \
		-j$(CPPCHECK_MAKE_JOBS)


	cp $(CPPCHECK_BUILD_DIR)/bin/cppcheck \
	   $(CPPCHECK_BIN)


	@echo ""
	@echo "cppcheck installed:"
	@echo "$(CPPCHECK_BIN)"



##################################################
# clean
##################################################

.PHONY: cppcheck-clean

cppcheck-clean:
	@echo "Clean cppcheck"
	rm -rf $(CPPCHECK_BUILD_DIR)
	rm -f $(CPPCHECK_BIN)