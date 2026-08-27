#
# Top Makefile
#
TOP_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

include $(TOP_DIR)/../../static_check_tools/scripts/rules-all.mk

.PHONY: all clean


all:
	@echo "Static check tools"


clean:
	$(MAKE) cppcheck-clean