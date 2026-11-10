#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/resume"

# core resume — the one command to run after a power cut or a killed Termux.
# Restarts stopped services, shows what was picked up, and continues the
# interrupted install from its checkpoint instead of starting over.
# (Every `core` command already restores stopped services silently in the
# background — this command is the explicit, visible way to pick up work.)
resume_main() {
  if [[ "${1:-}" == "--help" ]]; then
    echo
    log_info "Usage: core resume"
    log_info "Pick up where you left off after a power cut or a killed Termux:"
    log_info "  - restarts stopped services (OmniRoute gateway, OpenCode server)"
    log_info "  - continues the interrupted install from its checkpoint"
    echo
    return 0
  fi

  # Explicit resume: restart services even if a recent auto-restore gave up.
  resume_restore --force || true

  resume_print_summary

  resume_state_load
  if [[ "$INSTALL_STATUS" == "in_progress" && -n "$INSTALL_MODULE" ]]; then
    log_info "Continuing the interrupted install…"
    echo
    if _resume_continue_install; then
      echo
      log_success "Install finished — you are back where you left off."
    else
      echo
      log_warn "The install still needs attention — run 'core resume' again to continue it."
      return 1
    fi
  fi
}
