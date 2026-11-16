# ============================================================
# Configure Configuration
# ============================================================
.PHONY:  configure-help

MK_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

#
# Kconfig output directory
#
KCONFIG_BIN_DIR := $(PROJECT_ROOT)/bin
KCONFIG_OUTPUT := $(PROJECT_ROOT)/tmp/

#
# Config file
#
KCONFIG_DEFCONFIG := $(PROJECT_ROOT)/tmp/configs/test_defconfig
KCONFIG_FILE := $(PROJECT_ROOT)/tmp/configs/Kconfig
KCONFIG_CONFIG := $(PROJECT_ROOT)/tmp/.config

#
# Generated config files
#
KCONFIG_AUTOCONFIG := $(PROJECT_ROOT)/tmp/include/config/buto.conf
KCONFIG_AUTOHEADER := $(PROJECT_ROOT)/tmp/include/generated/autoconf.h


# Kconfig tools
KCONFIG_TOOLS := conf mconf

# ============================================================
# Kconfig Rules
# ============================================================
include $(PROJECT_ROOT)/config_tools/scripts/rule-kconfig.mk


# ============================================================
# Help
# ============================================================

.PHONY: configure-help

configure-help:
	@echo ""
	@echo "============================================================"
	@echo " Configure Module - Help"
	@echo "============================================================"
	@echo ""
	@echo "[Configure Targets]"
	@echo "  configure             Build Kconfig tools and deploy binaries"
	@echo "  configure-help        Display this help message"
	@echo ""
	@echo "[Kconfig Targets]"
	@echo "  kconfig-tools         Build conf and mconf tools"
	@echo "  defconfig             Generate .config from defconfig"
	@echo "  oldconfig             Update existing .config"
	@echo "  menuconfig            Open interactive configuration menu"
	@echo "  syncconfig            Generate configuration headers"
	@echo ""
	@echo "[Clean Targets]"
	@echo "  clean-configure       Remove deployed conf/mconf and clean tools"
	@echo "  clean-kconfig         Remove generated Kconfig output"
	@echo "  clean-kconfig-tools   Clean Kconfig host tools"
	@echo "  distclean-kconfig     Remove all Kconfig build files and tools"
	@echo ""
	@echo "[Kconfig Configuration]"
	@echo "  PROJECT_ROOT         Project root directory"
	@echo "  KCONFIG_RULE_DIR     Kconfig rule directory"
	@echo "  KCONFIG_TOP_DIR      Kconfig source root directory"
	@echo "  KCONFIG_DIR          Kconfig source directory"
	@echo "  KCONFIG_OUTPUT       Kconfig build output directory"
	@echo "  KCONFIG_BIN_DIR      Kconfig binary output directory"
	@echo "  KCONFIG_CONF         conf executable path"
	@echo "  KCONFIG_MCONF        mconf executable path"
	@echo ""
	@echo "[Config Files]"
	@echo "  KCONFIG_DEFCONFIG    Default configuration file"
	@echo "  KCONFIG_FILE         Kconfig description file"
	@echo "  KCONFIG_CONFIG       Generated .config file"
	@echo "  KCONFIG_AUTOCONFIG   Generated auto.conf file"
	@echo "  KCONFIG_AUTOHEADER   Generated autoconf.h file"
	@echo ""
	@echo "[Build Configuration]"
	@echo "  HOSTCC               Host compiler (default: gcc)"
	@echo ""
	@echo "[Current Configuration]"
	@echo "  PROJECT_ROOT         = $(PROJECT_ROOT)"
	@echo "  KCONFIG_DIR          = $(KCONFIG_DIR)"
	@echo "  KCONFIG_OUTPUT       = $(KCONFIG_OUTPUT)"
	@echo "  KCONFIG_BIN_DIR      = $(KCONFIG_BIN_DIR)"
	@echo "  KCONFIG_CONF         = $(KCONFIG_CONF)"
	@echo "  KCONFIG_MCONF        = $(KCONFIG_MCONF)"
	@echo "  KCONFIG_DEFCONFIG    = $(KCONFIG_DEFCONFIG)"
	@echo "  KCONFIG_FILE         = $(KCONFIG_FILE)"
	@echo "  KCONFIG_CONFIG       = $(KCONFIG_CONFIG)"
	@echo "  KCONFIG_AUTOCONFIG   = $(KCONFIG_AUTOCONFIG)"
	@echo "  KCONFIG_AUTOHEADER   = $(KCONFIG_AUTOHEADER)"
	@echo "  HOSTCC               = $(HOSTCC)"
	@echo ""
	@echo "[Usage Examples]"
	@echo "  make configure"
	@echo "  make kconfig-tools"
	@echo "  make defconfig"
	@echo "  make menuconfig"
	@echo "  make oldconfig"
	@echo "  make syncconfig"
	@echo "  make clean-configure"
	@echo "  make clean-kconfig"
	@echo "  make distclean-kconfig"
	@echo ""
	@echo "============================================================"
	@echo ""
