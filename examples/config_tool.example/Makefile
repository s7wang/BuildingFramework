#
# Top Makefile
#
TOP_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

#
# Kconfig output directory
#
KCONFIG_OUTPUT := $(TOP_DIR)/build

#
# Config file
#
KCONFIG_DEFCONFIG := $(TOP_DIR)/configs/test_defconfig
KCONFIG_FILE := $(TOP_DIR)/Kconfig
KCONFIG_CONFIG := $(KCONFIG_OUTPUT)/.config

#
# Generated config files
#
KCONFIG_AUTOCONFIG := $(KCONFIG_OUTPUT)/include/config/auto.conf
KCONFIG_AUTOHEADER := $(KCONFIG_OUTPUT)/include/generated/autoconf.h

include $(TOP_DIR)/../../config_tool/scripts/rule-kconfig.mk

.PHONY: all

all:
	@echo "Kconfig test"
