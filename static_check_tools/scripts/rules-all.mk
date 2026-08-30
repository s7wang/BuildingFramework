#
# static check build rules
#
SHELL := /bin/bash
##################################################
# Path
##################################################
RULES_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
STATIC_CHECK_TOP_DIR := $(realpath $(RULES_DIR)/..)
STATIC_CHECK_BUILD_DIR ?= $(STATIC_CHECK_TOP_DIR)/build
STATIC_CHECK_BIN_DIR ?= $(STATIC_CHECK_BUILD_DIR)/bin
STATIC_CHECK_SHARED_DIR ?= $(STATIC_CHECK_TOP_DIR)/share
STATIC_CHECK_REPORT_DIR ?= $(STATIC_CHECK_TOP_DIR)/reports

include $(RULES_DIR)/rule-report.mk
include $(RULES_DIR)/rule-cppcheck.mk
include $(RULES_DIR)/rule-sparse.mk
include $(RULES_DIR)/rule-flawfinder.mk

##################################################
# Public targets
##################################################
.PHONY: static-check
static-check: cppcheck sparse flawfinder
	@echo ""
	@echo "Static check tools build success"

.PHONY: static-check-clean
static-check-clean:
	@echo "===================================="
	@echo " Clean static check tools"
	@echo "===================================="

	rm -rf $(STATIC_CHECK_BUILD_DIR)
	rm -rf $(STATIC_CHECK_BIN_DIR)
	rm -rf $(STATIC_CHECK_SHARED_DIR)
