"""
CervellaSwarm Common Utilities
==============================

Moduli condivisi da tutti gli script dello sciame.

Versione: 2.0.0 (W4 Polish - DRY Centralization)
Data: 19 Gennaio 2026
"""

# === PATHS ===
from .paths import (
    # Core functions
    get_agents_path,
    get_data_dir,
    get_db_path,
    get_logs_dir,
    get_scripts_dir,

    # Convenience constants
    PROJECT_ROOT,
    AGENTS_PATH,
    DATA_DIR,
    DB_PATH,
    LOGS_DIR,
    SCRIPTS_DIR,

    # Utility functions
    ensure_data_dir,
    ensure_logs_dir,
    get_agent_file,
    list_agents,
    print_paths,
)

# === DATABASE ===
from .db import (
    connect_db,
    connect_db_safe,
    DatabaseNotFoundError,
    DatabaseConnectionError,
)

# === COLORS ===
from .colors import (
    Colors,
    RED,
    GREEN,
    YELLOW,
    BLUE,
    MAGENTA,
    CYAN,
    RESET,
    BOLD,
    DIM,
    get_severity_color,
    colorize,
    success,
    error,
    warning,
    info,
)

# === CONFIG ===
from .config import (
    SIMILARITY_THRESHOLD,
    MIN_PATTERN_OCCURRENCES,
    DEFAULT_EVENT_LIMIT,
    WEEK_DAYS,
    DB_FILENAME,
    WORKER_TIMEOUT,
    VERSION,
)

__all__ = [
    # Paths - Functions
    'get_agents_path',
    'get_data_dir',
    'get_db_path',
    'get_logs_dir',
    'get_scripts_dir',
    'ensure_data_dir',
    'ensure_logs_dir',
    'get_agent_file',
    'list_agents',
    'print_paths',

    # Paths - Constants
    'PROJECT_ROOT',
    'AGENTS_PATH',
    'DATA_DIR',
    'DB_PATH',
    'LOGS_DIR',
    'SCRIPTS_DIR',

    # Database
    'connect_db',
    'connect_db_safe',
    'DatabaseNotFoundError',
    'DatabaseConnectionError',

    # Colors
    'Colors',
    'RED',
    'GREEN',
    'YELLOW',
    'BLUE',
    'MAGENTA',
    'CYAN',
    'RESET',
    'BOLD',
    'DIM',
    'get_severity_color',
    'colorize',
    'success',
    'error',
    'warning',
    'info',

    # Config
    'SIMILARITY_THRESHOLD',
    'MIN_PATTERN_OCCURRENCES',
    'DEFAULT_EVENT_LIMIT',
    'WEEK_DAYS',
    'DB_FILENAME',
    'WORKER_TIMEOUT',
    'VERSION',
]

__version__ = "2.0.0"
