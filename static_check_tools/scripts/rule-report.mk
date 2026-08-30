##################################################
# Static check report framework
##################################################

CHECK_REPORT_TIME := $(shell date +%Y%m%d_%H%M%S)

CHECK_REPORT_SCRIPT := \
$(STATIC_CHECK_TOP_DIR)/scripts/check_report.sh


CHECK_REPORT_DIR ?= $(STATIC_CHECK_TOP_DIR)/reports


##################################################
# Generic report runner
#
# $1 tool
# $2 report file
# $3 command
#
##################################################

define RUN_CHECK_REPORT
mkdir -p $(dir $(2))
$(CHECK_REPORT_SCRIPT) $(1) $(2) $(3)
endef



##################################################
# cppcheck report
#
# $1 domain
# $2 mode
# $3 options
# $4 environment
# $5 source
#
##################################################

define RUN_CPPCHECK_REPORT
$(call RUN_CHECK_REPORT,\
cppcheck,\
$(CPPCHECK_REPORT_DIR)/$(1)/cppcheck_$(2)_$(CHECK_REPORT_TIME).log,\
$(CPPCHECK_BIN) $(3) $(4) $(CPPCHECK_INCLUDE) $(5))
endef