#!/bin/bash
# ============================================================================
# CervellaSwarm - Worker Timeout Monitor
# ============================================================================
# Monitora i worker e li termina se superano il timeout.
#
# Uso:
#   ./worker-timeout.sh                    # Check con default 30 min
#   ./worker-timeout.sh --timeout 15       # Timeout 15 minuti
#   ./worker-timeout.sh --dry-run          # Mostra cosa farebbe
#   ./worker-timeout.sh --daemon           # Esegui in background
#
# Versione: 1.0.0
# Data: 2026-01-09
# ============================================================================

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/common.sh" ]]; then
    source "${SCRIPT_DIR}/common.sh"
else
    # Fallback
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
    print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
    print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
    print_error() { echo -e "${RED}[X]${NC} $1"; }
    print_info() { echo -e "${BLUE}[i]${NC} $1"; }
fi

# ============================================================================
# CONFIGURAZIONE
# ============================================================================

TIMEOUT_MINUTES=30
DRY_RUN=false
DAEMON_MODE=false
CHECK_INTERVAL=60  # seconds for daemon mode

# Trova project root
find_project_root() {
    local search_dir="$(pwd)"
    for i in {1..5}; do
        if [ -d "${search_dir}/.swarm" ]; then
            echo "${search_dir}"
            return 0
        fi
        if [ "${search_dir}" = "/" ]; then
            break
        fi
        search_dir="$(dirname "${search_dir}")"
    done
    return 1
}

# ============================================================================
# FUNZIONI
# ============================================================================

get_worker_age_minutes() {
    local start_file="$1"
    if [[ ! -f "$start_file" ]]; then
        echo 0
        return
    fi

    local start_time=$(cat "$start_file" 2>/dev/null)
    local now=$(date +%s)
    local age_seconds=$((now - start_time))
    echo $((age_seconds / 60))
}

kill_tmux_session() {
    local session_file="$1"
    local session_name=$(cat "$session_file" 2>/dev/null)

    if [[ -z "$session_name" ]]; then
        return 1
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would kill session: $session_name"
        else
            tmux kill-session -t "$session_name" 2>/dev/null
            print_warning "Killed session: $session_name"
        fi
        return 0
    fi
    return 1
}

cleanup_worker_files() {
    local status_dir="$1"
    local worker_name="$2"

    if $DRY_RUN; then
        print_info "[DRY-RUN] Would cleanup files for: $worker_name"
        return
    fi

    rm -f "${status_dir}/worker_${worker_name}.pid"
    rm -f "${status_dir}/worker_${worker_name}.start"
    rm -f "${status_dir}/worker_${worker_name}.session"
    rm -f "${status_dir}/worker_${worker_name}.task"
}

check_workers() {
    local project_root="$1"
    local status_dir="${project_root}/.swarm/status"

    if [[ ! -d "$status_dir" ]]; then
        print_info "No status directory found"
        return 0
    fi

    local checked=0
    local killed=0

    # Check each worker start file
    for start_file in "$status_dir"/worker_*.start; do
        [[ -f "$start_file" ]] || continue

        # Extract worker name from filename
        local basename=$(basename "$start_file")
        local worker_name="${basename#worker_}"
        worker_name="${worker_name%.start}"

        ((checked++))

        local age_minutes=$(get_worker_age_minutes "$start_file")

        if [[ $age_minutes -gt $TIMEOUT_MINUTES ]]; then
            print_warning "Worker $worker_name: ${age_minutes}m > ${TIMEOUT_MINUTES}m TIMEOUT!"

            # Try to kill tmux session
            local session_file="${status_dir}/worker_${worker_name}.session"
            if [[ -f "$session_file" ]]; then
                kill_tmux_session "$session_file"
            fi

            # Cleanup files
            cleanup_worker_files "$status_dir" "$worker_name"

            ((killed++))
        else
            print_info "Worker $worker_name: ${age_minutes}m OK (limit: ${TIMEOUT_MINUTES}m)"
        fi
    done

    echo ""
    print_success "Checked: $checked workers"
    if [[ $killed -gt 0 ]]; then
        print_warning "Killed: $killed workers (timeout)"
    fi
}

daemon_loop() {
    local project_root="$1"

    print_info "Starting daemon mode (check every ${CHECK_INTERVAL}s, timeout: ${TIMEOUT_MINUTES}m)"
    print_info "Press Ctrl+C to stop"
    echo ""

    while true; do
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---"
        check_workers "$project_root"
        echo ""
        sleep $CHECK_INTERVAL
    done
}

show_usage() {
    echo "CervellaSwarm Worker Timeout Monitor"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --timeout MINUTES   Worker timeout in minutes (default: 30)"
    echo "  --dry-run           Show what would be done without doing it"
    echo "  --daemon            Run in background, checking periodically"
    echo "  --interval SECONDS  Check interval for daemon mode (default: 60)"
    echo "  --help              Show this help"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --timeout)
                shift
                TIMEOUT_MINUTES="$1"
                ;;
            --interval)
                shift
                CHECK_INTERVAL="$1"
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --daemon)
                DAEMON_MODE=true
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
        shift
    done

    # Find project root
    local project_root
    if ! project_root=$(find_project_root); then
        print_error "Not in a CervellaSwarm project!"
        exit 1
    fi

    echo "CervellaSwarm Worker Timeout Monitor"
    echo "====================================="
    echo "  Project: $project_root"
    echo "  Timeout: ${TIMEOUT_MINUTES} minutes"
    $DRY_RUN && echo "  Mode: DRY-RUN"
    $DAEMON_MODE && echo "  Mode: DAEMON"
    echo ""

    if $DAEMON_MODE; then
        daemon_loop "$project_root"
    else
        check_workers "$project_root"
    fi
}

main "$@"
