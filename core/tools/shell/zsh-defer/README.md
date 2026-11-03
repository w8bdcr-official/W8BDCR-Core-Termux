# Zsh-defer

Deferred plugin loading for faster ZSH startup

**Package:** zsh-defer  
**Author:** W8BDCR  
**Repository:** https://github.com/w8bdcr-official/W8BDCR-Core-Termux  
**Official:** https://github.com/romkatv/zsh-defer  
**Type:** ZSH plugin (git clone)  
**License:** MIT

## Description

Zsh-defer defers the loading of ZSH plugins to after the first prompt, significantly improving shell startup time. Non-essential plugins are loaded in the background while the shell remains responsive.

## Dependencies

- ZSH, git, zoxide

## Install

```bash
core install shell --zsh-defer
```

## Uninstall

```bash
core uninstall shell --zsh-defer
```

## Update

```bash
core update shell --zsh-defer
```

## Notes

- Installed in `~/.zsh-plugins/`
- Delays plugin loading until after first prompt
- Improves perceived ZSH startup time

