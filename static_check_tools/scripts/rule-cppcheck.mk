#
# cppcheck build rules
#

##################################################
# Source
##################################################

CPPCHECK_VERSION ?= 2.21.1

CPPCHECK_SRC_DIR ?= \
$(STATIC_CHECK_TOP_DIR)/src/cppcheck-$(CPPCHECK_VERSION)

CPPCHECK_BUILD_DIR ?= \
$(STATIC_CHECK_TOP_DIR)/build/cppcheck

CPPCHECK_SHARED_DIR ?= \
$(STATIC_CHECK_SHARED_DIR)/Cppcheck


CPPCHECK_BIN := \
$(STATIC_CHECK_BIN_DIR)/cppcheck


##################################################
# Report
##################################################

CPPCHECK_REPORT_DIR ?= \
$(STATIC_CHECK_REPORT_DIR)/cppcheck

##################################################
# Build
##################################################

CPPCHECK_MAKE_JOBS ?= $(shell nproc)

##################################################
# Project config
##################################################

#
# user source
#
PROJECT_USER_SRC ?=

#
# kernel source
#
PROJECT_KERNEL_SRC ?=

#
# kernel tree
#
KERNEL_SRC ?=

ARCH ?= x86

#
# extra include
#
CPPCHECK_INCLUDE ?=

##################################################
# System include
##################################################

CPPCHECK_GCC_INCLUDE := \
$(shell gcc -v -E -x c /dev/null 2>&1 \
| sed -n '/search starts here:/,/End of search list./p' \
| grep "^ " \
| sed 's/^ /-I/' \
| tr '\n' ' ')



##################################################
# Kernel config
##################################################
##################################################
# Kernel config
##################################################
CPPCHECK_KERNEL_OPTIONS := \
  --inline-suppr \
  --suppress=unmatchedSuppression \
  -D__KERNEL__ \
  -DMODULE \
  --include=$(STATIC_CHECK_TOP_DIR)/scripts/cppcheck-config/kernel_compat.h

# 彻底清空真实的内核 include，仅依赖 kernel_compat.h
CPPCHECK_KERNEL_INCLUDE := 

CPPCHECK_KERNEL_ARCH := \
  --platform=unix64
##################################################
# Environment
##################################################
CPPCHECK_USER_ENV := \
$(CPPCHECK_GCC_INCLUDE)


CPPCHECK_KERNEL_ENV := \
$(CPPCHECK_KERNEL_OPTIONS) \
$(CPPCHECK_KERNEL_ARCH) \
$(CPPCHECK_KERNEL_INCLUDE)
##################################################
# Target select
##################################################
CPPCHECK_TARGET ?= all


ifeq ($(CPPCHECK_TARGET),user)
CPPCHECK_ENV_OPTIONS := \
$(CPPCHECK_USER_ENV)

CPPCHECK_ENV_SRC := \
$(PROJECT_USER_SRC)
endif


ifeq ($(CPPCHECK_TARGET),kernel)
CPPCHECK_ENV_OPTIONS := \
$(CPPCHECK_KERNEL_ENV)

CPPCHECK_ENV_SRC := \
$(PROJECT_KERNEL_SRC)
endif



##################################################
# Check options
##################################################
CPPCHECK_COMMON_OPTIONS := \
--std=c11 \
--inconclusive \
--suppress=missingIncludeSystem \
--max-configs=1


#
# developer
#
CPPCHECK_DEV_OPTIONS := \
$(CPPCHECK_COMMON_OPTIONS) \
--enable=warning,performance,style \
--inconclusive

#
# CI
#
CPPCHECK_CI_OPTIONS := \
$(CPPCHECK_COMMON_OPTIONS) \
--enable=warning,performance \
--inconclusive \
--error-exitcode=1

#
# security
#
CPPCHECK_SECURITY_OPTIONS := \
$(CPPCHECK_COMMON_OPTIONS) \
--enable=all \
--inconclusive

##################################################
# Wrapper
##################################################
define RUN_CPPCHECK
$(CPPCHECK_BIN) \
$(1) \
$(2) \
$(CPPCHECK_INCLUDE) \
$(3)
endef

##################################################
# Public
##################################################
.PHONY: cppcheck
cppcheck: $(CPPCHECK_BIN)


##################################################
# Developer
##################################################
.PHONY: cppcheck-dev

cppcheck-dev: $(CPPCHECK_BIN)
ifeq ($(CPPCHECK_TARGET),all)
	$(call RUN_CPPCHECK,\
	$(CPPCHECK_DEV_OPTIONS),\
	$(CPPCHECK_USER_ENV),\
	$(PROJECT_USER_SRC))

	$(call RUN_CPPCHECK,\
	$(CPPCHECK_DEV_OPTIONS),\
	$(CPPCHECK_KERNEL_ENV),\
	$(PROJECT_KERNEL_SRC))
else
	$(call RUN_CPPCHECK,\
	$(CPPCHECK_DEV_OPTIONS),\
	$(CPPCHECK_ENV_OPTIONS),\
	$(CPPCHECK_ENV_SRC))
endif

##################################################
# CI
##################################################
.PHONY: cppcheck-ci

cppcheck-ci: $(CPPCHECK_BIN)
ifeq ($(CPPCHECK_TARGET),all)
	$(call RUN_CPPCHECK,\
	$(CPPCHECK_CI_OPTIONS),\
	$(CPPCHECK_USER_ENV),\
	$(PROJECT_USER_SRC))

	$(call RUN_CPPCHECK,\
	$(CPPCHECK_CI_OPTIONS),\
	$(CPPCHECK_KERNEL_ENV),\
	$(PROJECT_KERNEL_SRC))
else
	$(call RUN_CPPCHECK,\
	$(CPPCHECK_CI_OPTIONS),\
	$(CPPCHECK_ENV_OPTIONS),\
	$(CPPCHECK_ENV_SRC))
endif

##################################################
# Security
##################################################
.PHONY: cppcheck-security

cppcheck-security: $(CPPCHECK_BIN)
ifeq ($(CPPCHECK_TARGET),all)
	$(call RUN_CPPCHECK,\
	$(CPPCHECK_SECURITY_OPTIONS),\
	$(CPPCHECK_USER_ENV),\
	$(PROJECT_USER_SRC))

	$(call RUN_CPPCHECK,\
	$(CPPCHECK_SECURITY_OPTIONS),\
	$(CPPCHECK_KERNEL_ENV),\
	$(PROJECT_KERNEL_SRC))
else
	$(call RUN_CPPCHECK,\
	$(CPPCHECK_SECURITY_OPTIONS),\
	$(CPPCHECK_ENV_OPTIONS),\
	$(CPPCHECK_ENV_SRC))
endif

##################################################
# CI Report
##################################################
.PHONY: cppcheck-ci-report

cppcheck-ci-report: $(CPPCHECK_BIN)
	$(call RUN_CPPCHECK_REPORT,user,ci,$(CPPCHECK_CI_OPTIONS),\
	$(CPPCHECK_USER_ENV),\
	$(PROJECT_USER_SRC))

	$(call RUN_CPPCHECK_REPORT,kernel,ci,$(CPPCHECK_CI_OPTIONS),\
	$(CPPCHECK_KERNEL_ENV),\
	$(PROJECT_KERNEL_SRC))

##################################################
# Security Report
##################################################
.PHONY: cppcheck-security-report

cppcheck-security-report: $(CPPCHECK_BIN)
	$(call RUN_CPPCHECK_REPORT,user,security,$(CPPCHECK_SECURITY_OPTIONS),\
	$(CPPCHECK_USER_ENV),\
	$(PROJECT_USER_SRC))

	$(call RUN_CPPCHECK_REPORT,kernel,security,$(CPPCHECK_SECURITY_OPTIONS),\
	$(CPPCHECK_KERNEL_ENV),\
	$(PROJECT_KERNEL_SRC))


##################################################
# Build cppcheck
##################################################

$(CPPCHECK_BIN):
	@echo "===================================="
	@echo " Build cppcheck"
	@echo " Source : $(CPPCHECK_SRC_DIR)"
	@echo " Build  : $(CPPCHECK_BUILD_DIR)"
	@echo " Install: $(STATIC_CHECK_BIN_DIR)"
	@echo "===================================="

	mkdir -p $(CPPCHECK_BUILD_DIR)
	mkdir -p $(STATIC_CHECK_BIN_DIR)
	mkdir -p $(CPPCHECK_SHARED_DIR)

	cd $(CPPCHECK_BUILD_DIR) && \
	cmake \
	$(CPPCHECK_SRC_DIR) \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=$(STATIC_CHECK_TOP_DIR) \
	-DCMAKE_INSTALL_DATADIR=share

	cmake --build \
	$(CPPCHECK_BUILD_DIR) \
	-j$(CPPCHECK_MAKE_JOBS)

	cp \
	$(CPPCHECK_BUILD_DIR)/bin/cppcheck \
	$(CPPCHECK_BIN)

	cp -a \
	$(CPPCHECK_SRC_DIR)/cfg \
	$(CPPCHECK_SHARED_DIR)/

##################################################
# Clean
##################################################

.PHONY: cppcheck-clean

cppcheck-clean:
	rm -rf $(CPPCHECK_BUILD_DIR)
	rm -f $(CPPCHECK_BIN)
	rm -rf $(CPPCHECK_SHARED_DIR)