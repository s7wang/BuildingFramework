
# ============================================================
# Common Configuration
# ============================================================

PROJECT_NAME := BuildingFramework

PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)

CHECK_TOOLS_DIR := $(PROJECT_ROOT)/check-tools
MK_TOOLS_DIR := $(PROJECT_ROOT)/mk-tools

# Dirs
TMP_DIR := $(PROJECT_ROOT)/tmp
LOG_DIR := $(TMP_DIR)/log
BUILD_DIR := $(PROJECT_ROOT)/build
SOURCE_DIR ?= $(PROJECT_ROOT)/sources
BIN_DIR := $(PROJECT_ROOT)/bin
DOWNLOAD_DIR ?= $(SOURCE_DIR)

# Shell
SHELL := /bin/bash
