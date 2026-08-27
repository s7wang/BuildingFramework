##################################################
# sparse rules
##################################################

#
# source
#
SPARSE_VERSION ?= v0.6.4
SPARSE_SRC_DIR := $(STATIC_CHECK_TOP_DIR)/src/sparse-$(SPARSE_VERSION)

SPARSE_BUILD_DIR := $(STATIC_CHECK_BUILD_DIR)/sparse


SPARSE_BIN_DIR := $(STATIC_CHECK_BIN_DIR)


SPARSE_BIN := $(SPARSE_BIN_DIR)/sparse



##################################################
# Public target
##################################################

.PHONY: sparse

sparse: $(SPARSE_BIN)



##################################################
# Build
##################################################

$(SPARSE_BIN):
	@echo "================================="
	@echo " Build sparse"
	@echo " Source: $(SPARSE_SRC_DIR)"
	@echo " Build  : $(SPARSE_BUILD_DIR)"
	@echo "================================="

	mkdir -p $(SPARSE_BUILD_DIR)
	mkdir -p $(SPARSE_BIN_DIR)

	cp -a $(SPARSE_SRC_DIR)/. $(SPARSE_BUILD_DIR)/

	cd $(SPARSE_BUILD_DIR) && \
	make -j$(shell nproc)

	cp $(SPARSE_BUILD_DIR)/sparse \
	$(SPARSE_BIN)

	@echo "sparse installed:"
	@echo $(SPARSE_BIN)

##################################################
# Clean
##################################################

.PHONY: sparse-clean

sparse-clean:
	rm -rf $(SPARSE_BUILD_DIR)
	rm -f $(SPARSE_BIN)