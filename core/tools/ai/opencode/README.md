# OpenCode

Open-source agent that helps you write code in your terminal

**Package:** opencode  
**Author:** W8BDCR  
**Repository:** https://github.com/w8bdcr-official/W8BDCR-Core-Termux  
**Official:** https://github.com/anomalyco/opencode  
**Type:** AI coding agent (native on Termux, pinned v1.19.5 binary)  
**License:** MIT

## Description

OpenCode is an AI-powered coding agent developed by anomalyco that operates directly in your terminal. It provides intelligent code completion, refactoring suggestions, and natural language code generation. W8BDCR-Core-Termux installs OpenCode natively on stock Termux (pinned v1.19.5 — verified working on phone 2026-11-06), or in a proot Ubuntu container if you pick Proot-distro at install time.

## Dependencies

- **Native mode (recommended, verified working on phone):** glibc-repo, glibc, clang, git, ripgrep, python, jq, nodejs-lts, curl, tar
- **Proot mode (alternative):** proot-distro, curl, ca-certificates, ripgrep

## Install

```bash
core install ai --opencode
```

You will be prompted to choose:

**Native (recommended)** — Compiles a glibc bootstrapper and downloads the pinned OpenCode v1.19.5 binary from GitHub releases (verified working on phone 2026-11-06)

**Proot-distro** — Ubuntu container, pinned OpenCode v1.19.5, ripgrep included

## Server commands

```bash
opencode          # Bare launch: server auto-starts on 127.0.0.1:4096, TUI attaches to it
opencode-start    # Start the server (if needed) and attach the TUI — same flow, explicit
opencode-fix      # Repair: reinstall the pinned v1.19.5 binary and restart the server
```

Subcommands (`serve`, `attach`, `run`, `web`, `--help`, ...) run directly against the binary, unchanged.

## Model setup (OpenRouter free model / OmniRoute)

```bash
chmod +x setup-opencode.sh
./setup-opencode.sh
```

Defaults to the local OmniRoute gateway (`http://localhost:20128/v1`). Set the model to the free OpenRouter model `nvidia/nemotron-3-ultra-550b-a55b:free` and keep your API key in an environment variable — never in the repo.

## Uninstall

```bash
core uninstall ai --opencode
```

## Update

```bash
core update ai --opencode
```

## Notes

- **Proot mode** installs pinned OpenCode v1.19.5 inside the Ubuntu container (`/root/.opencode/bin/opencode`); ripgrep is installed via apt upfront
- **Native mode** requires `glibc-repo`, `glibc`, `clang`, and other dependencies (installed automatically)
- The native binary is stored in `~/.local/share/core-termux-data/opencode/`
- A small C bootstrapper (`opencode_helper.c`) handles ELF loading via the glibc dynamic linker (native mode only)
- The server log lives inside Ubuntu at `/root/.opencode/serve.log` (proot mode)
- Data directory: `~/.local/share/core-termux-data/opencode/`
