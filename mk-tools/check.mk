
# ============================================================
# Static Check Targets
# ============================================================

.PHONY: check format-check

# Run all checks
check: format-check

# Check source file format
format-check:
	@echo "[INFO] Running format check..."
	bash $(CHECK_TOOLS_DIR)/format-check.sh

