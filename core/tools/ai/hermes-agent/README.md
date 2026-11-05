# Hermes Agent
The self-improving AI agent built by Nous Research

**Package:** hermes-agent
**Author:** W8BDCR  
**Repository:** https://github.com/w8bdcr-official/W8BDCR-Core-Termux  
**Official:** https://github.com/nousresearch/hermes-agent  
**Type:** The agent that grows with you
**License:** MIT

# Description

The self-improving AI agent built by Nous Research. It's the only agent with a built-in learning loop — it creates skills from experience, improves them during use, nudges itself to persist knowledge, searches its own past conversations, and builds a deepening model of who you are across sessions.

# Dependencies

- python
- clang
- rust
- make
- pkg-config
- libffi
- openssl
- nodejs-lts
- ripgrep
- ffmpeg

# Install

```bash
core install ai --hermes-agent
```

# Uninstall

```bash
core uninstall ai --hermes-agent
```

# Update

```bash
core update ai --hermes-agent
```

# Notes

- Installed with the W8BDCR Hermes-Own installer (Python 3.14+, Pillow override, ruamel.yaml fix): https://github.com/w8bdcr-official/W8BDCR-Hermes-Own
- Command: `hermes` (any `hermes` command auto-starts the gateway; `hermes-start` starts gateway + chat in one; `hermes-fix` repairs the setup)
- Requires configuration for optimal performance
