#!/bin/bash
# ============================================================================
# CervellaSwarm - Log Rotation Script
# ============================================================================
# Ruota i log in .swarm/logs/ per evitare che il disco si riempia.
#
# Uso:
#   ./log-rotate.sh                    # Usa defaults
#   ./log-rotate.sh --max-size 10M     # Max 10MB per file
#   ./log-rotate.sh --max-files 5      # Mantieni solo 5 file
#   ./log-rotate.sh --dry-run          # Mostra cosa farebbe
#
# Versione: 1.0.0
# Data: 2026-01-09
# ============================================================================

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/common.sh" ]]; then
    source "${SCRIPT_DIR}/common.sh"
else
    # Fallback colors and functions
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

# Default values
MAX_SIZE_BYTES=$((5 * 1024 * 1024))  # 5MB default
MAX_SIZE_HUMAN="5M"
MAX_FILES=10
DRY_RUN=false
VERBOSE=false

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

parse_size() {
    local size="$1"
    local num="${size%[KMG]}"
    local unit="${size: -1}"

    case "$unit" in
        K|k) echo $((num * 1024)) ;;
        M|m) echo $((num * 1024 * 1024)) ;;
        G|g) echo $((num * 1024 * 1024 * 1024)) ;;
        *) echo "$size" ;;
    esac
}

get_file_size() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        stat -f %z "$file" 2>/dev/null || echo 0
    else
        stat -c %s "$file" 2>/dev/null || echo 0
    fi
}

human_size() {
    local bytes="$1"
    if [[ $bytes -gt $((1024 * 1024 * 1024)) ]]; then
        echo "$((bytes / 1024 / 1024 / 1024))G"
    elif [[ $bytes -gt $((1024 * 1024)) ]]; then
        echo "$((bytes / 1024 / 1024))M"
    elif [[ $bytes -gt 1024 ]]; then
        echo "$((bytes / 1024))K"
    else
        echo "${bytes}B"
    fi
}

rotate_file() {
    local file="$1"
    local basename="${file%.log}"

    if $DRY_RUN; then
        print_info "[DRY-RUN] Would rotate: $file"
        return 0
    fi

    # Shift existing rotated files
    for i in $(seq $((MAX_FILES - 1)) -1 1); do
        if [[ -f "${basename}.log.${i}" ]]; then
            mv "${basename}.log.${i}" "${basename}.log.$((i + 1))"
        fi
    done

    # Rotate current file
    mv "$file" "${basename}.log.1"

    # Create new empty file
    touch "$file"

    $VERBOSE && print_success "Rotated: $file"
}

cleanup_old_files() {
    local dir="$1"

    # Find and remove files beyond MAX_FILES
    for base in $(ls "$dir"/*.log 2>/dev/null | sed 's/\.log.*//' | sort -u); do
        local count=0
        for rotated in $(ls -t "${base}.log"* 2>/dev/null); do
            ((count++))
            if [[ $count -gt $MAX_FILES ]]; then
                if $DRY_RUN; then
                    print_info "[DRY-RUN] Would remove: $rotated"
                else
                    rm -f "$rotated"
                    $VERBOSE && print_warning "Removed old: $rotated"
                fi
            fi
        done
    done
}

show_usage() {
    echo "CervellaSwarm Log Rotation"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --max-size SIZE     Max log file size before rotation (default: 5M)"
    echo "                      Examples: 1M, 10M, 100K, 1G"
    echo "  --max-files N       Max number of rotated files to keep (default: 10)"
    echo "  --dry-run           Show what would be done without doing it"
    echo "  --verbose           Show detailed output"
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
            --max-size)
                shift
                MAX_SIZE_HUMAN="$1"
                MAX_SIZE_BYTES=$(parse_size "$1")
                ;;
            --max-files)
                shift
                MAX_FILES="$1"
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --verbose|-v)
                VERBOSE=true
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

    local logs_dir="${project_root}/.swarm/logs"

    if [[ ! -d "$logs_dir" ]]; then
        print_info "No logs directory found at $logs_dir"
        exit 0
    fi

    echo "CervellaSwarm Log Rotation"
    echo "=========================="
    echo "  Logs dir: $logs_dir"
    echo "  Max size: $MAX_SIZE_HUMAN ($MAX_SIZE_BYTES bytes)"
    echo "  Max files: $MAX_FILES"
    $DRY_RUN && echo "  Mode: DRY-RUN"
    echo ""

    local rotated=0
    local checked=0

    # Check each log file
    for log_file in "$logs_dir"/*.log; do
        [[ -f "$log_file" ]] || continue
        ((checked++))

        local size=$(get_file_size "$log_file")

        if [[ $size -gt $MAX_SIZE_BYTES ]]; then
            print_warning "$(basename "$log_file"): $(human_size $size) > $MAX_SIZE_HUMAN"
            rotate_file "$log_file"
            ((rotated++))
        elif $VERBOSE; then
            print_info "$(basename "$log_file"): $(human_size $size) OK"
        fi
    done

    # Cleanup old rotated files
    cleanup_old_files "$logs_dir"

    echo ""
    echo "=========================="
    print_success "Checked: $checked files"
    print_success "Rotated: $rotated files"

    if $DRY_RUN; then
        print_info "This was a dry run - no changes made"
    fi
}

main "$@"
