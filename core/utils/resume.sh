#!/data/data/com.termux/files/usr/bin/bash

# W8BDCR-Core-Termux — Resume system
#
# If Termux is killed or the power goes out mid-work, the next `core`
# command picks up where the last one stopped: stopped services are
# restarted, and an interrupted install continues from its checkpoint
# instead of starting over. `core resume` is the explicit one-command
# way to do the same thing on purpose.
#
# State lives in the RUNTIME data dir (CORE_DATA), never in the repo
# checkout — core-fix can wipe the checkout, the state must survive that.
# Every write is atomic (temp file + sync + rename + dir sync) so a
# power cut mid-write can never leave a half-written state file.

import "@/utils/log"

# Known services Core can restart. Format: "name|probe-url|starter".
# OmniRoute is the separate W8BDCR-OmniRoute-Own gateway (dashboard + API).
_RESUME_GATEWAY_URL="http://127.0.0.1:20128/"
_RESUME_OPENCODE_URL="http://127.0.0.1:4096/"

# How long a failed restart attempt blocks the next one (auto mode only).
# A broken service must not slow down every `core` command.
_RESUME_RETRY_BACKOFF=600

_resume_state_file() {
  local data_dir="${CORE_DATA:-$HOME/.local/share/core-termux-data}"
  printf '%s/resume.state' "$data_dir"
}

_resume_state_tmp() {
  printf '%s.tmp' "$(_resume_state_file)"
}

_resume_defaults() {
  RESUME_VERSION=1
  LAST_COMMAND=""
  LAST_COMMAND_TS=0
  LAST_CWD=""
  SERVICES=""
  INSTALL_STATUS="idle"
  INSTALL_MODULE=""
  INSTALL_TOOLS=""
  INSTALL_DONE=""
  INSTALL_CURRENT=""
  INSTALL_STARTED_TS=0
  INSTALLED_MODULES=""
  LAST_RESTORED_SERVICES=""
  LAST_RESTORED_TS=0
  LAST_RESTORE_FAIL_TS=0
}

# Load state. Only a complete, current-version file is trusted — a corrupt
# file falls back to defaults instead of crashing the shell.
resume_state_load() {
  _resume_defaults
  local state_file
  state_file="$(_resume_state_file)"
  if [[ -f "$state_file" ]] && grep -q '^RESUME_VERSION=1$' "$state_file" 2>/dev/null; then
    # shellcheck disable=SC1090
    source "$state_file"
  fi
}

# Atomic save: write temp file, flush it to disk, rename over the state,
# flush the directory. A power cut at any point leaves either the old
# state or the new state — never a half-written one.
resume_state_save() {
  local state_file tmp_file state_dir
  state_file="$(_resume_state_file)"
  tmp_file="$(_resume_state_tmp)"
  state_dir="$(dirname "$state_file")"
  mkdir -p "$state_dir" 2>/dev/null || return 1
  {
    printf 'RESUME_VERSION=1\n'
    printf 'LAST_COMMAND=%q\n' "$LAST_COMMAND"
    printf 'LAST_COMMAND_TS=%s\n' "$LAST_COMMAND_TS"
    printf 'LAST_CWD=%q\n' "$LAST_CWD"
    printf 'SERVICES=%q\n' "$SERVICES"
    printf 'INSTALL_STATUS=%q\n' "$INSTALL_STATUS"
    printf 'INSTALL_MODULE=%q\n' "$INSTALL_MODULE"
    printf 'INSTALL_TOOLS=%q\n' "$INSTALL_TOOLS"
    printf 'INSTALL_DONE=%q\n' "$INSTALL_DONE"
    printf 'INSTALL_CURRENT=%q\n' "$INSTALL_CURRENT"
    printf 'INSTALL_STARTED_TS=%s\n' "$INSTALL_STARTED_TS"
    printf 'INSTALLED_MODULES=%q\n' "$INSTALLED_MODULES"
    printf 'LAST_RESTORED_SERVICES=%q\n' "$LAST_RESTORED_SERVICES"
    printf 'LAST_RESTORED_TS=%s\n' "$LAST_RESTORED_TS"
    printf 'LAST_RESTORE_FAIL_TS=%s\n' "$LAST_RESTORE_FAIL_TS"
  } > "$tmp_file" || return 1
  command -v sync >/dev/null 2>&1 && sync "$tmp_file" 2>/dev/null
  mv -f "$tmp_file" "$state_file" || return 1
  command -v sync >/dev/null 2>&1 && sync "$state_dir" 2>/dev/null
  return 0
}

# Record every invocation (cheap atomic write, called from bin/core).
resume_record_command() {
  resume_state_load
  LAST_COMMAND="$*"
  LAST_COMMAND_TS="$(date +%s 2>/dev/null || echo 0)"
  LAST_CWD="$PWD"
  resume_state_save || true
}

# --- Install checkpoints -------------------------------------------------

# Called when an install starts. A restore re-entering install_main keeps
# the done list and the original start time — finished work is never redone.
resume_checkpoint_install_start() {
  local module="$1"
  shift
  resume_state_load
  local keep_done="" keep_ts=0
  if [[ "${_RESUME_RESTORING:-}" == "1" && "$INSTALL_STATUS" == "in_progress" && "$INSTALL_MODULE" == "$module" ]]; then
    keep_done="$INSTALL_DONE"
    keep_ts="$INSTALL_STARTED_TS"
  fi
  INSTALL_STATUS="in_progress"
  INSTALL_MODULE="$module"
  INSTALL_TOOLS="$*"
  INSTALL_DONE="$keep_done"
  INSTALL_CURRENT=""
  if (( keep_ts > 0 )); then
    INSTALL_STARTED_TS="$keep_ts"
  else
    INSTALL_STARTED_TS="$(date +%s 2>/dev/null || echo 0)"
  fi
  resume_state_save || true
}

resume_checkpoint_tool_start() {
  local tool="$1"
  resume_state_load
  [[ "$INSTALL_STATUS" == "in_progress" ]] || return 0
  INSTALL_CURRENT="$tool"
  resume_state_save || true
}

resume_checkpoint_tool_done() {
  local tool="$1"
  resume_state_load
  [[ "$INSTALL_STATUS" == "in_progress" ]] || return 0
  case " $INSTALL_DONE " in
    *" $tool "*) ;;
    *) INSTALL_DONE="${INSTALL_DONE:+$INSTALL_DONE }$tool" ;;
  esac
  [[ "$INSTALL_CURRENT" == "$tool" ]] && INSTALL_CURRENT=""
  resume_state_save || true
}

resume_checkpoint_install_done() {
  resume_state_load
  [[ "$INSTALL_STATUS" == "in_progress" ]] || return 0
  INSTALL_STATUS="done"
  INSTALL_CURRENT=""
  case " $INSTALLED_MODULES " in
    *" $INSTALL_MODULE "*) ;;
    *) INSTALLED_MODULES="${INSTALLED_MODULES:+$INSTALLED_MODULES }$INSTALL_MODULE" ;;
  esac
  resume_state_save || true
}

# Tools of the interrupted install that are still missing.
_resume_remaining_tools() {
  local tool remaining=""
  for tool in $INSTALL_TOOLS; do
    case " $INSTALL_DONE " in
      *" $tool "*) ;;
      *) remaining="${remaining:+$remaining }$tool" ;;
    esac
  done
  printf '%s' "$remaining"
}

# --- Services --------------------------------------------------------------

_resume_http_up() {
  curl -fsS -m 2 -o /dev/null "$1" 2>/dev/null
}

_resume_service_is_up() {
  case "$1" in
    omniroute) _resume_http_up "$_RESUME_GATEWAY_URL" ;;
    opencode) _resume_http_up "$_RESUME_OPENCODE_URL" ;;
    *) return 1 ;;
  esac
}

# Start a service, then wait until it answers (up to ~$2 seconds).
# Best effort — never fatal, never noisy.
_resume_start_service() {
  local svc="$1" wait_secs="${2:-10}" i
  case "$svc" in
    omniroute)
      command -v omniroute >/dev/null 2>&1 || return 1
      nohup omniroute serve >/dev/null 2>&1 &
      ;;
    opencode)
      if [[ -x "${PREFIX:-}/bin/opencode-start" ]]; then
        nohup "${PREFIX}/bin/opencode-start" >/dev/null 2>&1 &
      elif command -v opencode >/dev/null 2>&1; then
        nohup opencode serve --port 4096 --hostname 127.0.0.1 >/dev/null 2>&1 &
      else
        return 1
      fi
      ;;
    *) return 1 ;;
  esac
  for i in $(seq 1 "$wait_secs"); do
    _resume_service_is_up "$svc" && return 0
    sleep 1
  done
  return 1
}

# --- Restore ----------------------------------------------------------------

# Continue the interrupted install from its checkpoint. Finished tools are
# never redone; a failed tool stays in the checkpoint for the next run.
_resume_continue_install() {
  resume_state_load
  [[ "$INSTALL_STATUS" == "in_progress" ]] || return 0
  [[ -n "$INSTALL_MODULE" ]] || return 0
  local module="$INSTALL_MODULE" rc=0
  import "@/cli/commands/install"

  if [[ -n "$INSTALL_TOOLS" ]]; then
    local remaining
    remaining="$(_resume_remaining_tools)"
    if [[ -z "$remaining" ]]; then
      resume_checkpoint_install_done
      return 0
    fi
    local -a args=("$module")
    local tool
    for tool in $remaining; do args+=("--$tool"); done
    _RESUME_RESTORING=1
    install_main "${args[@]}"
    rc=$?
    unset _RESUME_RESTORING
    return $rc
  fi

  # Interactive single-tool install (ai module): the wrapper checkpoint
  # recorded the tool that was running.
  if [[ "$module" == "ai" && -n "$INSTALL_CURRENT" ]]; then
    case " $INSTALL_DONE " in
      *" $INSTALL_CURRENT "*) resume_checkpoint_install_done; return 0 ;;
    esac
    _RESUME_RESTORING=1
    install_main "$module" "--$INSTALL_CURRENT"
    rc=$?
    unset _RESUME_RESTORING
    return $rc
  fi

  # Whole-module install: re-run the module. Package managers skip what is
  # already installed, so finished work is not redone.
  _RESUME_RESTORING=1
  install_main "$module"
  rc=$?
  unset _RESUME_RESTORING
  return $rc
}

# Silent safety net, run by bin/core before every command.
#   resume_restore [command...]   — auto mode (backoff on failed restarts)
#   resume_restore --force         — explicit mode (used by `core resume`)
resume_restore() {
  local force=0
  if [[ "${1:-}" == "--force" ]]; then
    force=1
    shift
  fi

  resume_state_load
  local now
  now="$(date +%s 2>/dev/null || echo 0)"

  # Services: record anything that is up, restart what is recorded but down.
  local svc restarted="" failed=0 changed=0
  for svc in omniroute opencode; do
    if _resume_service_is_up "$svc"; then
      case " $SERVICES " in
        *" $svc "*) ;;
        *) SERVICES="${SERVICES:+$SERVICES }$svc"; changed=1 ;;
      esac
      continue
    fi
    case " $SERVICES " in
      *" $svc "*) ;;
      *) continue ;;  # never started by the user — leave it alone
    esac
    if (( force == 0 )) && (( now - LAST_RESTORE_FAIL_TS < _RESUME_RETRY_BACKOFF )); then
      continue  # recent failure — do not slow down this command
    fi
    local wait_secs=10
    (( force == 1 )) && wait_secs=15
    if _resume_start_service "$svc" "$wait_secs"; then
      restarted="${restarted:+$restarted }$svc"
      changed=1
    else
      failed=1
    fi
  done
  if [[ -n "$restarted" ]]; then
    LAST_RESTORED_SERVICES="$restarted"
    LAST_RESTORED_TS="$now"
  fi
  (( failed == 1 )) && LAST_RESTORE_FAIL_TS="$now"
  (( changed == 1 || failed == 1 )) && resume_state_save || true

  # Explicit `core resume` continues the install itself — skip it here.
  (( force == 1 )) && return 0

  # Install resume: not for meta / read-only / destructive commands.
  # (`core resume` is on the list because resume_main continues the
  # install itself, after showing the summary.)
  case " ${1:-} " in
    *" resume "*|*" --version "*|*" --help "*|*" update "*|*" uninstall "*|*" reinstall "*)
      return 0
      ;;
  esac
  resume_state_load
  [[ "$INSTALL_STATUS" == "in_progress" ]] || return 0
  [[ -n "$INSTALL_MODULE" ]] || return 0
  log_info "Resuming interrupted install: core install $INSTALL_MODULE${INSTALL_TOOLS:+ --${INSTALL_TOOLS// / --}}"
  _resume_continue_install || log_warn "Install resume needs attention — run 'core resume' to continue it"
  return 0
}

# --- Summary (for `core resume`) -------------------------------------------

_resume_age() {
  local now diff
  now="$(date +%s 2>/dev/null || echo 0)"
  diff=$(( now - $1 ))
  if (( diff < 60 )); then printf 'just now'; return; fi
  if (( diff < 3600 )); then printf '%dm ago' $(( diff / 60 )); return; fi
  if (( diff < 86400 )); then printf '%dh ago' $(( diff / 3600 )); return; fi
  printf '%dd ago' $(( diff / 86400 ))
}

resume_print_summary() {
  resume_state_load
  local now svc status
  now="$(date +%s 2>/dev/null || echo 0)"
  echo
  log_info "Resume — picking up where you left off"
  echo
  if [[ -n "$LAST_COMMAND" ]]; then
    log_info "Last command: core $LAST_COMMAND ($(_resume_age "$LAST_COMMAND_TS"))"
  fi
  for svc in omniroute opencode; do
    if _resume_service_is_up "$svc"; then
      status="running"
      case " $LAST_RESTORED_SERVICES " in
        *" $svc "*)
          (( now - LAST_RESTORED_TS < 120 )) && status="running (restarted just now)"
          ;;
      esac
    else
      status="not running"
    fi
    if [[ "$svc" == "omniroute" ]]; then
      log_info "OmniRoute gateway (localhost:20128): $status"
    else
      log_info "OpenCode server (localhost:4096): $status"
    fi
  done
  if [[ "$INSTALL_STATUS" == "in_progress" ]]; then
    local remaining
    remaining="$(_resume_remaining_tools)"
    log_warn "Interrupted install: core install $INSTALL_MODULE${INSTALL_TOOLS:+ --${INSTALL_TOOLS// / --}}"
    [[ -n "$INSTALL_DONE" ]] && log_info "  Already done: $INSTALL_DONE"
    [[ -n "$remaining" ]] && log_info "  Still to do: $remaining"
    [[ -n "$INSTALL_CURRENT" ]] && log_info "  Stopped during: $INSTALL_CURRENT"
  else
    log_success "No interrupted install — nothing to redo"
  fi
  echo
}
