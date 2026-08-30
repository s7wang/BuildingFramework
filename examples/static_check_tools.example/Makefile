#
# Top Makefile
#
TOP_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))



.PHONY: all clean

CPPCHECK_TARGET=all
PROJECT_USER_SRC=$(TOP_DIR)/user

PROJECT_KERNEL_SRC=$(TOP_DIR)/kernel

KERNEL_SRC=/home/wangs7_ubuntu22/prj_test/linux


include $(TOP_DIR)/../../static_check_tools/scripts/rules-all.mk
all:
	@echo "Static check tools"


clean:
	$(MAKE) cppcheck-clean