# Instructions of kconfig

## Environment Dependencies

The Kconfig tool only requires host-side tools.

Required:

- gcc
- make
- flex
- bison
- ncurses development library (required by mconf)

List of required tools

| Tool        | Purpose                          | necessary                                               |
| ----------- | -------------------------------- | ------------------------------------------------------- |
| gcc         | Compile the kconfig tool itself  | Y                                                       |
| make        | Compile the kconfig tool         | Y                                                       |
| flex        | Generate lexer                   | Y (If lexer.lex.c already exists, it is not necessary)  |
| bison       | Generate parser                  | Y (If parser.tab.c already exists, it is not necessary) |
| Ncurses     | Support menuconfig interface     | Y only  mconf                                           |

---

Minimum installation list - Ubuntu / Debian



Ubuntu/Debian:

```shell
sudo apt install gcc make flex bison libncurses-dev
```

The generated configuration files include:

```txt
.config
include/config/auto.conf
include/generated/autoconf.h
```

No target compiler or cross compilation environment is required.
After install these packages, you can use the kconfig.

```shell
make
./conf Kconfig
./mconf Kconfig
```

## Output Control Of kconfig

These three variables are output path control variables in the Linux Kconfig configuration system, with corresponding functions:

| Variable             | Description                                                        | Default Value                  | Generated Content                                |
| -------------------- | ------------------------------------------------------------------ | ------------------------------ | ------------------------------------------------ |
| `O=`                 | Specifies the entire build output directory (out-of-tree build)    | Current source directory       | `.config`, generated files, object files         |
| `KCONFIG_CONFIG`     | Specifies the path and name of the Kconfig configuration file      | `.config`                      | User-selected `CONFIG_xxx` configuration options |
| `KCONFIG_AUTOCONFIG` | Specifies the generated configuration file path used by Makefiles  | `include/config/auto.conf`     | Configuration variables read by Make             |
| `KCONFIG_AUTOHEADER` | Specifies the generated header file path used by C/C++ source code | `include/generated/autoconf.h` | `#define CONFIG_xxx` macros                      |

## Example

You can refer to the case of porting the kconfig module to the examples/config_tool.example directory of this repository.

Execute commands in the examples/config_tool.example directory.

kconfig-tools Usage:

```shell
make kconfig-tools
```

Build and prepare the Kconfig host tools.

- Builds `conf` if it does not exist.
- Builds `mconf` if it does not exist.
- Reuses existing tools when they are already available.

Generated tools:

- $(KCONFIG_BIN_DIR)/conf
- $(KCONFIG_BIN_DIR)/mconf

---

oldconfig Usage:

```shell
make oldconfig
```

Update an existing configuration according to the current Kconfig definitions.

Reads the existing .config file.
Keeps all existing configuration values.
Prompts for newly added configuration options.

Typical usage:

After adding new config entries into Kconfig.
When migrating an existing configuration to a newer Kconfig version.

---

defconfig Usage:

```shell
make defconfig
```

Generate a default configuration from a predefined defconfig file.

Loads configuration values from $(KCONFIG_DEFCONFIG).
Creates the final .config file.
Used for reproducible builds and product-specific configurations.

Typical usage:

Initial project configuration.
CI/build automation.
Different product or platform configurations.

---

menuconfig Usage:

```shell
make menuconfig
```

Launch the interactive Kconfig menu interface.

Provides a terminal-based UI for selecting configuration options.
Allows users to enable, disable, or modify configuration values.
Generates the .config file after saving.

Typical usage:

Developer configuration.
Debug feature selection.
Manual configuration changes.

---

syncconfig Usage:

```shell
make syncconfig
```

Synchronize generated configuration files.

Converts .config into files required by the build system.
Generates configuration headers and Makefile variables.

Generated files:

```txt
include/config/auto.conf
include/generated/autoconf.h
```

Typical usage:

Before compiling source code.
After changing configuration.
When configuration values are used by Makefiles or C code.

---

You can configure the path and name of the input and output files, defined by the following macros

```makefile
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
```
