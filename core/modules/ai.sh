#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"
import "@/utils/resume"

LOG_FILE="$CORE_CACHE/install_ai.log"

install_ai() {
  separator
  box "Installing AI Tools"
  separator
  echo

  log_info "Select AI tool to install:"
  echo
  mkdir -p "$(dirname "$LOG_FILE")"

  read_select "AI tool" SELECTED_AI_TOOL \
    "OpenCode (recommended)" \
    "Claude Code" \
    "Kilo Code CLI" \
    "Cline" \
    "Antigravity CLI" \
    "CodeGraph" \
    "Codex CLI" \
    "Command Code" \
    "Context7" \
    "Engram" \
    "Freebuff" \
    "Gemini CLI" \
    "Gentle-AI" \
    "GGA" \
    "Hermes Agent" \
    "Kimchi" \
    "Kimi Code" \
    "MiMoCode" \
    "MiniMax CLI" \
    "Mistral Vibe" \
    "Ollama" \
    "OpenClaude" \
    "OpenClaw" \
    "OpenSpec" \
    "Pi Coding Agent" \
    "Qwen Code"

  local install_rc=0

  case "$SELECTED_AI_TOOL" in
  *OpenCode*)
    _install_selected_ai_tool "opencode"
    install_rc=$?
    ;;
  *OpenClaude*)
    _install_selected_ai_tool "openclaude"
    install_rc=$?
    ;;
  *Claude*)
    _install_selected_ai_tool "claude-code"
    install_rc=$?
    ;;
  *Kilo*)
    _install_selected_ai_tool "kilocode-cli"
    install_rc=$?
    ;;
  *Cline*)
    _install_selected_ai_tool "cline"
    install_rc=$?
    ;;
  *Antigravity*)
    _install_selected_ai_tool "antigravity-cli"
    install_rc=$?
    ;;
  *CodeGraph*)
    _install_selected_ai_tool "codegraph"
    install_rc=$?
    ;;
  *Codex*)
    _install_selected_ai_tool "codex"
    install_rc=$?
    ;;
  *Command\ Code*)
    _install_selected_ai_tool "command-code"
    install_rc=$?
    ;;
  *Context7*)
    _install_selected_ai_tool "ctx7"
    install_rc=$?
    ;;
  *Engram*)
    _install_selected_ai_tool "engram"
    install_rc=$?
    ;;
  *Freebuff*)
    _install_selected_ai_tool "freebuff"
    install_rc=$?
    ;;
  *Gemini*)
    _install_selected_ai_tool "gemini-cli"
    install_rc=$?
    ;;
  *Gentle*)
    _install_selected_ai_tool "gentle-ai"
    install_rc=$?
    ;;
  *GGA*)
    _install_selected_ai_tool "gga"
    install_rc=$?
    ;;
  *Hermes*)
    _install_selected_ai_tool "hermes-agent"
    install_rc=$?
    ;;
  *Kimchi*)
    _install_selected_ai_tool "kimchi"
    install_rc=$?
    ;;
  *Kimi\ Code*)
    _install_selected_ai_tool "kimi-code"
    install_rc=$?
    ;;
  *MiMoCode*)
    _install_selected_ai_tool "mimocode"
    install_rc=$?
    ;;
  *MiniMax*)
    _install_selected_ai_tool "minimax-cli"
    install_rc=$?
    ;;
  *Mistral*)
    _install_selected_ai_tool "mistral-vibe"
    install_rc=$?
    ;;
  *Ollama*)
    _install_selected_ai_tool "ollama"
    install_rc=$?
    ;;
  *OpenClaw*)
    _install_selected_ai_tool "openclaw"
    install_rc=$?
    ;;
  *OpenSpec*)
    _install_selected_ai_tool "openspec"
    install_rc=$?
    ;;
  *Pi\ Coding*)
    _install_selected_ai_tool "pi"
    install_rc=$?
    ;;
  *Qwen*)
    _install_selected_ai_tool "qwen-code"
    install_rc=$?
    ;;
  esac

  separator
  echo
  if [[ $install_rc -eq 0 ]]; then
    log_success "$SELECTED_AI_TOOL installed successfully"
  else
    log_error "$SELECTED_AI_TOOL failed to install"
  fi

  return $install_rc
}

_install_selected_ai_tool() {
  import "@/tools/ai/all"
  resume_checkpoint_tool_start "$1"
  _install_ai_tool "$1"
  local rc=$?

  if [[ $rc -eq 2 ]]; then
    return 0
  fi

  if (( rc == 0 )); then
    resume_checkpoint_tool_done "$1"
  fi

  return $rc
}
_install_ai_tools_wrapper() {
  import "@/tools/ai/all"
  install_all_ai_tools
}

uninstall_ai() {
  if ! command -v opencode &>/dev/null && ! command -v claude &>/dev/null && ! command -v kilo &>/dev/null && ! command -v cline &>/dev/null && ! command -v agy &>/dev/null && ! command -v codegraph &>/dev/null && ! command -v codex &>/dev/null && ! command -v command-code &>/dev/null && ! command -v ctx7 &>/dev/null && ! command -v engram &>/dev/null && ! command -v freebuff &>/dev/null && ! command -v gemini &>/dev/null && ! command -v gentle-ai &>/dev/null && ! command -v gga &>/dev/null && ! command -v hermes &>/dev/null && ! command -v kimchi &>/dev/null && ! command -v kimi &>/dev/null && ! command -v mimo &>/dev/null && ! command -v mmx &>/dev/null && ! command -v vibe &>/dev/null && ! command -v ollama &>/dev/null && ! command -v openclaude &>/dev/null && ! command -v openclaw &>/dev/null && ! command -v openspec &>/dev/null && ! command -v pi &>/dev/null && ! command -v qwen &>/dev/null; then
    log_info "AI Tools are not installed"
    return 0
  fi
  separator
  box "Uninstalling AI Tools"
  separator
  echo

  log_info "Uninstalling AI tools..."

  _uninstall_ai_tools_wrapper
  log_success "AI tools uninstalled"
}

_uninstall_ai_tools_wrapper() {
  import "@/tools/ai/all"
  uninstall_all_ai_tools
}

update_ai() {
  separator
  box "Updating AI Tools"
  separator
  echo

  log_info "Updating AI tools..."

  _update_ai_tools_wrapper
  log_success "AI tools updated"
}

_update_ai_tools_wrapper() {
  import "@/tools/ai/all"
  update_all_ai_tools
}

reinstall_ai() {
  separator
  box "Reinstalling AI Tools"
  separator
  echo

  log_info "Reinstalling AI tools..."
  echo

  _reinstall_ai_tools_wrapper
  log_success "AI tools reinstalled successfully"
  separator
  echo
  list_item "Claude Code"
  list_item "OpenCode"
  list_item "Kilo Code CLI"
  list_item "Cline"
  list_item "Antigravity CLI"
  list_item "CodeGraph"
  list_item "Codex CLI"
  list_item "Command Code"
  list_item "Context7"
  list_item "Engram"
  list_item "Freebuff"
  list_item "Gemini CLI"
  list_item "Gentle-AI"
  list_item "GGA"
  list_item "Hermes Agent"
  list_item "Kimchi"
  list_item "Kimi Code"
  list_item "MiMoCode"
  list_item "MiniMax CLI"
  list_item "Mistral Vibe"
  list_item "Ollama"
  list_item "OpenClaude"
  list_item "OpenClaw"
  list_item "OpenSpec"
  list_item "Pi Coding Agent"
  list_item "Qwen Code"
  echo
}

_reinstall_ai_tools_wrapper() {
  import "@/tools/ai/all"
  reinstall_all_ai_tools
}
