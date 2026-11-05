#!/bin/bash

import "@/utils/log"

LOG_FILE="$CORE_CACHE/install_ai.log"

AI_TOOLS=(
  "claude-code"
  "opencode"
  "kilocode-cli"
  "cline"
  "antigravity-cli"
  "codegraph"
  "codex"
  "command-code"
  "ctx7"
  "engram"
  "freebuff"
  "gemini-cli"
  "gentle-ai"
  "gga"
  "hermes-agent"
  "kimchi"
  "kimi-code"
  "mimocode"
  "minimax-cli"
  "mistral-vibe"
  "ollama"
  "openclaude"
  "openclaw"
  "openspec"
  "pi"
  "qwen-code"
)

source "$(dirname "$BASH_SOURCE")/claude-code/install.sh"
source "$(dirname "$BASH_SOURCE")/opencode/install.sh"
source "$(dirname "$BASH_SOURCE")/kilocode-cli/install.sh"
source "$(dirname "$BASH_SOURCE")/cline/install.sh"
source "$(dirname "$BASH_SOURCE")/antigravity-cli/install.sh"
source "$(dirname "$BASH_SOURCE")/codegraph/install.sh"
source "$(dirname "$BASH_SOURCE")/codex/install.sh"
source "$(dirname "$BASH_SOURCE")/command-code/install.sh"
source "$(dirname "$BASH_SOURCE")/ctx7/install.sh"
source "$(dirname "$BASH_SOURCE")/engram/install.sh"
source "$(dirname "$BASH_SOURCE")/freebuff/install.sh"
source "$(dirname "$BASH_SOURCE")/gemini-cli/install.sh"
source "$(dirname "$BASH_SOURCE")/gentle-ai/install.sh"
source "$(dirname "$BASH_SOURCE")/gga/install.sh"
source "$(dirname "$BASH_SOURCE")/hermes-agent/install.sh"
source "$(dirname "$BASH_SOURCE")/kimchi/install.sh"
source "$(dirname "$BASH_SOURCE")/kimi-code/install.sh"
source "$(dirname "$BASH_SOURCE")/mimocode/install.sh"
source "$(dirname "$BASH_SOURCE")/minimax-cli/install.sh"
source "$(dirname "$BASH_SOURCE")/mistral-vibe/install.sh"
source "$(dirname "$BASH_SOURCE")/ollama/install.sh"
source "$(dirname "$BASH_SOURCE")/openclaude/install.sh"
source "$(dirname "$BASH_SOURCE")/openclaw/install.sh"
source "$(dirname "$BASH_SOURCE")/openspec/install.sh"
source "$(dirname "$BASH_SOURCE")/pi/install.sh"
source "$(dirname "$BASH_SOURCE")/qwen-code/install.sh"


_install_ai_tool() {
  case "$1" in
  claude-code) install_claude_code ;;
  opencode) install_opencode ;;
  kilocode-cli) install_kilocode_cli ;;
  cline) install_cline ;;
  antigravity-cli) install_antigravity_cli ;;
  codegraph) install_codegraph ;;
  codex) install_codex ;;
  command-code) install_command_code ;;
  ctx7) install_ctx7 ;;
  engram) install_engram ;;
  freebuff) install_freebuff ;;
  gemini-cli) install_gemini_cli ;;
  gentle-ai) install_gentle_ai ;;
  gga) install_gga ;;
  hermes-agent) install_hermes_agent ;;
  kimchi) install_kimchi ;;
  kimi-code) install_kimi_code ;;
  mimocode) install_mimocode ;;
  minimax-cli) install_minimax_cli ;;
  mistral-vibe) install_mistral_vibe ;;
  ollama) install_ollama ;;
  openclaude) install_openclaude ;;
  openclaw) install_openclaw ;;
  openspec) install_openspec ;;
  pi) install_pi ;;
  qwen-code) install_qwen_code ;;
  *) log_warn "Unknown AI tool: --$1"; return 2 ;;
  esac
}

_uninstall_ai_tool() {
  case "$1" in
  claude-code) uninstall_claude_code ;;
  opencode) uninstall_opencode ;;
  kilocode-cli) uninstall_kilocode_cli ;;
  cline) uninstall_cline ;;
  antigravity-cli) uninstall_antigravity_cli ;;
  codegraph) uninstall_codegraph ;;
  codex) uninstall_codex ;;
  command-code) uninstall_command_code ;;
  ctx7) uninstall_ctx7 ;;
  engram) uninstall_engram ;;
  freebuff) uninstall_freebuff ;;
  gemini-cli) uninstall_gemini_cli ;;
  gentle-ai) uninstall_gentle_ai ;;
  gga) uninstall_gga ;;
  hermes-agent) uninstall_hermes_agent ;;
  kimchi) uninstall_kimchi ;;
  kimi-code) uninstall_kimi_code ;;
  mimocode) uninstall_mimocode ;;
  minimax-cli) uninstall_minimax_cli ;;
  mistral-vibe) uninstall_mistral_vibe ;;
  ollama) uninstall_ollama ;;
  openclaude) uninstall_openclaude ;;
  openclaw) uninstall_openclaw ;;
  openspec) uninstall_openspec ;;
  pi) uninstall_pi ;;
  qwen-code) uninstall_qwen_code ;;
  *) log_warn "Unknown AI tool: --$1"; return 2 ;;
  esac
}

_update_ai_tool() {
  case "$1" in
  claude-code) update_claude_code ;;
  opencode) update_opencode ;;
  kilocode-cli) update_kilocode_cli ;;
  cline) update_cline ;;
  antigravity-cli) update_antigravity_cli ;;
  codegraph) update_codegraph ;;
  codex) update_codex ;;
  command-code) update_command_code ;;
  ctx7) update_ctx7 ;;
  engram) update_engram ;;
  freebuff) update_freebuff ;;
  gemini-cli) update_gemini_cli ;;
  gentle-ai) update_gentle_ai ;;
  gga) update_gga ;;
  hermes-agent) update_hermes_agent ;;
  kimchi) update_kimchi ;;
  kimi-code) update_kimi_code ;;
  mimocode) update_mimocode ;;
  minimax-cli) update_minimax_cli ;;
  mistral-vibe) update_mistral_vibe ;;
  ollama) update_ollama ;;
  openclaude) update_openclaude ;;
  openclaw) update_openclaw ;;
  openspec) update_openspec ;;
  pi) update_pi ;;
  qwen-code) update_qwen_code ;;
  *) log_warn "Unknown AI tool: --$1"; return 2 ;;
  esac
}

_reinstall_ai_tool() {
  case "$1" in
  claude-code) reinstall_claude_code ;;
  opencode) reinstall_opencode ;;
  kilocode-cli) reinstall_kilocode_cli ;;
  cline) reinstall_cline ;;
  antigravity-cli) reinstall_antigravity_cli ;;
  codegraph) reinstall_codegraph ;;
  codex) reinstall_codex ;;
  command-code) reinstall_command_code ;;
  ctx7) reinstall_ctx7 ;;
  engram) reinstall_engram ;;
  freebuff) reinstall_freebuff ;;
  gemini-cli) reinstall_gemini_cli ;;
  gentle-ai) reinstall_gentle_ai ;;
  gga) reinstall_gga ;;
  hermes-agent) reinstall_hermes_agent ;;
  kimchi) reinstall_kimchi ;;
  kimi-code) reinstall_kimi_code ;;
  mimocode) reinstall_mimocode ;;
  minimax-cli) reinstall_minimax_cli ;;
  mistral-vibe) reinstall_mistral_vibe ;;
  ollama) reinstall_ollama ;;
  openclaude) reinstall_openclaude ;;
  openclaw) reinstall_openclaw ;;
  openspec) reinstall_openspec ;;
  pi) reinstall_pi ;;
  qwen-code) reinstall_qwen_code ;;
  *) log_warn "Unknown AI tool: --$1"; return 2 ;;
  esac
}

_run_all_ai_tools() {
  local action="$1"
  local success_count=0
  local failed_count=0
  local tool

  for tool in "${AI_TOOLS[@]}"; do
    "_${action}_ai_tool" "$tool"
    case $? in
    0) ((success_count++)) ;;
    1) ((failed_count++)) ;;
    esac
  done

  return 0
}

install_all_ai_tools() {
  _run_all_ai_tools install
}

uninstall_all_ai_tools() {
  _run_all_ai_tools uninstall
}

update_all_ai_tools() {
  _run_all_ai_tools update
}

reinstall_all_ai_tools() {
  _run_all_ai_tools reinstall
}