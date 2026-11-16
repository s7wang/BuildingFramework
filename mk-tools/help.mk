
# ============================================================
# Help Targets
# ============================================================

.PHONY: help

help:
	@echo ""
	@echo "================================================"
	@echo " $(PROJECT_NAME) Build Framework"
	@echo "================================================"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "  help          Show this help"
	@echo "  check         Run all static checks"
	@echo "  format-check  Check file format"
	@echo "  download      Download source repository"
	@echo "  build         Build project"
	@echo "  clean         Clean build and log files"
	@echo "  clean-log     Clean log files"
	@echo "  clean-source  Clean downloaded source files"
	@echo "  clean-build   Clean build files"
	@echo ""
