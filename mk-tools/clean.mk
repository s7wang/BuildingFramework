
# ============================================================
# Clean Targets
# ============================================================

.PHONY: clean clean-log clean-build

clean: clean-log clean-build clean-source

clean-log:
	@echo "[INFO] Cleaning logs..."
	@rm -rf $(LOG_DIR)

clean-build:
	@echo "[INFO] Cleaning build directory..."
	@rm -rf $(BUILD_DIR)

clean-source:
	@echo "[INFO] Cleaning downloaded sources..."
	@rm -rf "$(SOURCE_DIR)"
