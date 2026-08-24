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
