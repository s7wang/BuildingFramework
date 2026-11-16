
# ============================================================
# Download Module
# ============================================================

.PHONY: download download-help

# Download parameters:
# DOWNLOAD_TYPE   : git or svn
# DOWNLOAD_URL    : Remote repository URL
# DOWNLOAD_BRANCH : Git branch name
# DOWNLOAD_CID    : Git commit ID
# DOWNLOAD_REV    : SVN revision number
# DOWNLOAD_NAME   : Local directory name

# Default download parameters
DOWNLOAD_TYPE ?= git
DOWNLOAD_URL ?=
DOWNLOAD_BRANCH ?=
DOWNLOAD_CID ?=
DOWNLOAD_REV ?=
DOWNLOAD_NAME ?=

DOWNLOAD_DIR := $(PROJECT_ROOT)/sources

# ============================================================
# Download Target
# ============================================================

download:
	@set -eu; \
	TYPE="$(DOWNLOAD_TYPE)"; \
	URL="$(DOWNLOAD_URL)"; \
	BRANCH="$(DOWNLOAD_BRANCH)"; \
	CID="$(DOWNLOAD_CID)"; \
	REV="$(DOWNLOAD_REV)"; \
	NAME="$(DOWNLOAD_NAME)"; \
	\
	if [ -z "$$URL" ]; then \
		echo "[ERROR] DOWNLOAD_URL is required"; \
		echo "Run 'make download-help' for usage"; \
		exit 1; \
	fi; \
	\
	case "$$TYPE" in \
		git|svn) ;; \
		*) \
			echo "[ERROR] Unsupported download type: $$TYPE"; \
			exit 1 ;; \
	esac; \
	\
	if [ -z "$$NAME" ]; then \
		REPO_URL="$${URL%/}"; \
		NAME="$${REPO_URL##*/}"; \
		NAME="$${NAME%.git}"; \
	fi; \
	\
	case "$$NAME" in \
		""|"."|".."|*/*) \
			echo "[ERROR] Invalid download name: $$NAME"; \
			exit 1 ;; \
	esac; \
	\
	DEST="$(DOWNLOAD_DIR)/$$NAME"; \
	\
	if [ -e "$$DEST" ]; then \
		echo "[ERROR] Destination already exists: $$DEST"; \
		exit 1; \
	fi; \
	\
	mkdir -p "$(DOWNLOAD_DIR)"; \
	trap 'status=$$?; if [ $$status -ne 0 ]; then rm -rf -- "$$DEST"; fi; exit $$status' EXIT; \
	\
	echo "============================================================"; \
	echo " Repository Download"; \
	echo "============================================================"; \
	echo "Type        : $$TYPE"; \
	echo "URL         : $$URL"; \
	echo "Branch      : $${BRANCH:-default}"; \
	echo "Commit ID   : $${CID:-default}"; \
	echo "Revision    : $${REV:-HEAD}"; \
	echo "Name        : $$NAME"; \
	echo "Destination : $$DEST"; \
	echo "============================================================"; \
	\
	if [ "$$TYPE" = "git" ]; then \
		command -v git >/dev/null 2>&1 || { echo "[ERROR] git is not installed"; exit 1; }; \
		if [ -n "$$CID" ]; then \
			if [ -n "$$BRANCH" ]; then \
				git clone --no-checkout --branch "$$BRANCH" "$$URL" "$$DEST"; \
			else \
				git clone --no-checkout "$$URL" "$$DEST"; \
			fi; \
			git -C "$$DEST" checkout --detach "$$CID"; \
		elif [ -n "$$BRANCH" ]; then \
			git clone --branch "$$BRANCH" "$$URL" "$$DEST"; \
		else \
			git clone "$$URL" "$$DEST"; \
		fi; \
	else \
		command -v svn >/dev/null 2>&1 || { echo "[ERROR] svn is not installed"; exit 1; }; \
		if [ -n "$$REV" ]; then \
			svn checkout -r "$$REV" "$$URL" "$$DEST"; \
		else \
			svn checkout "$$URL" "$$DEST"; \
		fi; \
	fi; \
	\
	trap - EXIT; \
	echo ""; \
	echo "[PASS] Repository download completed"; \
	echo "Location: $$DEST"

# ============================================================
# Download Help
# ============================================================

download-help:
	@echo ""
	@echo "================================================"
	@echo " Download Help"
	@echo "================================================"
	@echo ""
	@echo "Usage:"
	@echo "  make download DOWNLOAD_URL=<url> [OPTIONS]"
	@echo ""
	@echo "Required parameters:"
	@echo "  DOWNLOAD_URL       Repository URL"
	@echo ""
	@echo "Optional parameters:"
	@echo "  DOWNLOAD_TYPE      Repository type: git or svn (default: git)"
	@echo "  DOWNLOAD_BRANCH    Git branch name"
	@echo "  DOWNLOAD_CID       Git commit ID"
	@echo "  DOWNLOAD_REV       SVN revision"
	@echo "  DOWNLOAD_NAME      Destination directory name"
	@echo ""
	@echo "Download directory:"
	@echo "  $(DOWNLOAD_DIR)"
	@echo ""
	@echo "Examples:"
	@echo "  make download DOWNLOAD_URL=https://github.com/example/project.git"
	@echo "  make download DOWNLOAD_URL=https://github.com/example/project.git DOWNLOAD_BRANCH=develop"
	@echo "  make download DOWNLOAD_URL=https://github.com/example/project.git DOWNLOAD_CID=abcdef123456"
	@echo "  make download DOWNLOAD_TYPE=svn DOWNLOAD_URL=https://svn.example.com/project DOWNLOAD_REV=1234"
	@echo "  make download DOWNLOAD_URL=https://github.com/example/project.git DOWNLOAD_NAME=my-project"
	@echo ""
	@echo "Clean downloaded sources:"
	@echo "  make clean-source"
	@echo ""
