# ============================================================
# BuildingFramework Main Makefile
# ============================================================

.DEFAULT_GOAL := help

PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
MK_TOOLS_DIR := $(PROJECT_ROOT)/mk-tools

include $(MK_TOOLS_DIR)/common.mk

# Load functional modules
include $(MK_TOOLS_DIR)/check.mk
include $(MK_TOOLS_DIR)/download.mk
include $(MK_TOOLS_DIR)/configure.mk
include $(MK_TOOLS_DIR)/organize.mk
include $(MK_TOOLS_DIR)/build.mk
include $(MK_TOOLS_DIR)/clean.mk

# Load help module at last
include $(MK_TOOLS_DIR)/help.mk