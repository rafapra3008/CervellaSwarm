"""Structured JSON Logging for CervellaSwarm.

This module provides structured logging in JSON format for better observability
and analysis of swarm operations. Each log entry is a single-line JSON object.

Features:
    - Structured JSON logging (JSON Lines format)
    - Distributed tracing with trace_id and span_id
    - Console + file output
    - Context manager for span management

Usage:
    # Basic usage
    logger = SwarmLogger('backend-worker')
    logger.info("Task started", task_id="task-001", extra={"files": 3})

    # With distributed tracing
    logger = SwarmLogger('orchestrator', trace_id="abc123")
    with logger.span("process_task") as span_logger:
        span_logger.info("Processing...")
"""

__version__ = "2.0.0"
__version_date__ = "2026-01-14"

import json
import logging
import sys
import uuid
from contextlib import contextmanager
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, Optional, Generator
from enum import Enum


class LogLevel(Enum):
    """Log levels."""
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNING = "WARNING"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"


class SwarmLogger:
    """Structured JSON logger for CervellaSwarm with distributed tracing.

    Logs to both file (JSON Lines format) and console (human-readable).
    Each log entry includes: timestamp, level, agent, task_id, trace_id, span_id, message, extra fields.

    Distributed Tracing:
        - trace_id: Unique ID for an entire operation (e.g., a session, a pipeline)
        - span_id: Unique ID for each sub-operation within a trace
        - parent_span_id: Links child spans to parent span

    Attributes:
        agent: Agent name (e.g., 'backend-worker', 'frontend-worker')
        task_id: Optional task ID for tracking
        trace_id: Trace ID for distributed tracing (auto-generated if not provided)
        span_id: Span ID for current operation (auto-generated)
        parent_span_id: Parent span ID (for nested spans)
        log_dir: Directory for log files
    """

    def __init__(
        self,
        agent: str,
        task_id: Optional[str] = None,
        trace_id: Optional[str] = None,
        span_id: Optional[str] = None,
        parent_span_id: Optional[str] = None,
        log_dir: Optional[Path] = None,
        console_output: bool = True
    ):
        """Initialize SwarmLogger.

        Args:
            agent: Agent identifier
            task_id: Optional task ID for correlation
            trace_id: Trace ID for distributed tracing (auto-generated if None)
            span_id: Span ID for this logger instance (auto-generated if None)
            parent_span_id: Parent span ID for nested spans
            log_dir: Directory for log files (default: logs/)
            console_output: Whether to also log to console
        """
        self.agent = agent
        self.task_id = task_id
        self.trace_id = trace_id or self._generate_id()
        self.span_id = span_id or self._generate_id()
        self.parent_span_id = parent_span_id
        self.log_dir = log_dir or Path("logs")
        self.console_output = console_output

        # Create log directory if it doesn't exist
        self.log_dir.mkdir(parents=True, exist_ok=True)

        # Log file path: logs/swarm_YYYY-MM-DD.jsonl
        today = datetime.now().strftime("%Y-%m-%d")
        self.log_file = self.log_dir / f"swarm_{today}.jsonl"

        # Console logger for human-readable output
        if console_output:
            self._console_logger = logging.getLogger(f"swarm.{agent}")
            if not self._console_logger.handlers:
                handler = logging.StreamHandler(sys.stdout)
                formatter = logging.Formatter(
                    "%(asctime)s [%(levelname)s] %(name)s: %(message)s"
                )
                handler.setFormatter(formatter)
                self._console_logger.addHandler(handler)
                self._console_logger.setLevel(logging.DEBUG)

    @staticmethod
    def _generate_id() -> str:
        """Generate a short unique ID for trace/span.

        Returns:
            8-character hex string (e.g., 'a1b2c3d4')
        """
        return uuid.uuid4().hex[:8]

    def _create_log_entry(
        self,
        level: LogLevel,
        message: str,
        **extra: Any
    ) -> Dict[str, Any]:
        """Create structured log entry with tracing.

        Args:
            level: Log level
            message: Log message
            **extra: Additional fields to include

        Returns:
            Dictionary with log entry including trace_id and span_id
        """
        entry = {
            "timestamp": datetime.now().isoformat(),
            "level": level.value,
            "agent": self.agent,
            "trace_id": self.trace_id,
            "span_id": self.span_id,
            "message": message
        }

        # Add parent span if exists (for nested spans)
        if self.parent_span_id:
            entry["parent_span_id"] = self.parent_span_id

        if self.task_id:
            entry["task_id"] = self.task_id

        # Add extra fields
        if extra:
            entry["extra"] = extra

        return entry

    def _write_log(self, entry: Dict[str, Any]) -> None:
        """Write log entry to file.

        Args:
            entry: Log entry dictionary
        """
        try:
            with open(self.log_file, "a", encoding="utf-8") as f:
                f.write(json.dumps(entry, ensure_ascii=False) + "\n")
        except Exception as e:
            # Fallback to stderr if file writing fails
            print(f"Failed to write log: {e}", file=sys.stderr)

    def _log(
        self,
        level: LogLevel,
        message: str,
        **extra: Any
    ) -> None:
        """Internal logging method.

        Args:
            level: Log level
            message: Log message
            **extra: Additional fields
        """
        entry = self._create_log_entry(level, message, **extra)
        self._write_log(entry)

        # Also log to console if enabled
        if self.console_output:
            log_method = getattr(
                self._console_logger,
                level.value.lower()
            )
            extra_str = f" | {extra}" if extra else ""
            log_method(f"{message}{extra_str}")

    def debug(self, message: str, **extra: Any) -> None:
        """Log DEBUG level message.

        Args:
            message: Log message
            **extra: Additional fields
        """
        self._log(LogLevel.DEBUG, message, **extra)

    def info(self, message: str, **extra: Any) -> None:
        """Log INFO level message.

        Args:
            message: Log message
            **extra: Additional fields
        """
        self._log(LogLevel.INFO, message, **extra)

    def warning(self, message: str, **extra: Any) -> None:
        """Log WARNING level message.

        Args:
            message: Log message
            **extra: Additional fields
        """
        self._log(LogLevel.WARNING, message, **extra)

    def error(self, message: str, **extra: Any) -> None:
        """Log ERROR level message.

        Args:
            message: Log message
            **extra: Additional fields
        """
        self._log(LogLevel.ERROR, message, **extra)

    def critical(self, message: str, **extra: Any) -> None:
        """Log CRITICAL level message.

        Args:
            message: Log message
            **extra: Additional fields
        """
        self._log(LogLevel.CRITICAL, message, **extra)

    def set_task_id(self, task_id: str) -> None:
        """Update task ID for all subsequent logs.

        Args:
            task_id: New task ID
        """
        self.task_id = task_id

    def set_trace_id(self, trace_id: str) -> None:
        """Update trace ID for all subsequent logs.

        Args:
            trace_id: New trace ID
        """
        self.trace_id = trace_id

    def new_span(self) -> str:
        """Generate a new span ID and update this logger.

        Returns:
            The new span ID
        """
        old_span = self.span_id
        self.parent_span_id = old_span
        self.span_id = self._generate_id()
        return self.span_id

    @contextmanager
    def span(self, operation: str) -> Generator["SwarmLogger", None, None]:
        """Create a child span for a sub-operation.

        Creates a new SwarmLogger instance with the same trace_id but a new span_id,
        linked to the current span as parent. Useful for tracking nested operations.

        Args:
            operation: Name of the operation (logged as span_name)

        Yields:
            New SwarmLogger instance for the child span

        Example:
            logger = SwarmLogger("orchestrator")
            with logger.span("process_files") as span_logger:
                span_logger.info("Processing files...")
                with span_logger.span("validate") as validate_logger:
                    validate_logger.info("Validating...")
        """
        child_logger = SwarmLogger(
            agent=self.agent,
            task_id=self.task_id,
            trace_id=self.trace_id,
            span_id=self._generate_id(),
            parent_span_id=self.span_id,
            log_dir=self.log_dir,
            console_output=self.console_output
        )

        child_logger.debug(f"Span started: {operation}", span_name=operation)

        try:
            yield child_logger
        except Exception as e:
            child_logger.error(
                f"Span failed: {operation}",
                span_name=operation,
                error=str(e),
                error_type=type(e).__name__
            )
            raise
        finally:
            child_logger.debug(f"Span ended: {operation}", span_name=operation)

    def child_logger(self, agent: Optional[str] = None) -> "SwarmLogger":
        """Create a child logger with same trace but new span.

        Useful when passing logger to worker agents.

        Args:
            agent: Optional new agent name (defaults to same agent)

        Returns:
            New SwarmLogger with same trace_id, new span_id
        """
        return SwarmLogger(
            agent=agent or self.agent,
            task_id=self.task_id,
            trace_id=self.trace_id,
            span_id=self._generate_id(),
            parent_span_id=self.span_id,
            log_dir=self.log_dir,
            console_output=self.console_output
        )


def read_logs(
    log_file: Path,
    agent: Optional[str] = None,
    level: Optional[LogLevel] = None,
    task_id: Optional[str] = None,
    trace_id: Optional[str] = None,
    span_id: Optional[str] = None
) -> list[Dict[str, Any]]:
    """Read and filter logs from JSONL file.

    Args:
        log_file: Path to log file
        agent: Filter by agent name
        level: Filter by log level
        task_id: Filter by task ID
        trace_id: Filter by trace ID (for distributed tracing)
        span_id: Filter by span ID

    Returns:
        List of matching log entries

    Example:
        >>> # Get all logs for a specific trace
        >>> logs = read_logs(
        ...     Path("logs/swarm_2026-01-14.jsonl"),
        ...     trace_id="a1b2c3d4"
        ... )
        >>> # Get errors from backend worker
        >>> logs = read_logs(
        ...     Path("logs/swarm_2026-01-14.jsonl"),
        ...     agent="backend-worker",
        ...     level=LogLevel.ERROR
        ... )
    """
    if not log_file.exists():
        return []

    matching_logs = []

    with open(log_file, "r", encoding="utf-8") as f:
        for line in f:
            try:
                entry = json.loads(line.strip())

                # Apply filters
                if agent and entry.get("agent") != agent:
                    continue
                if level and entry.get("level") != level.value:
                    continue
                if task_id and entry.get("task_id") != task_id:
                    continue
                if trace_id and entry.get("trace_id") != trace_id:
                    continue
                if span_id and entry.get("span_id") != span_id:
                    continue

                matching_logs.append(entry)

            except json.JSONDecodeError:
                # Skip malformed lines
                continue

    return matching_logs


def get_trace(log_file: Path, trace_id: str) -> list[Dict[str, Any]]:
    """Get all logs for a specific trace, sorted by timestamp.

    Useful for debugging a complete operation flow.

    Args:
        log_file: Path to log file
        trace_id: Trace ID to filter

    Returns:
        List of log entries for the trace, sorted chronologically
    """
    logs = read_logs(log_file, trace_id=trace_id)
    return sorted(logs, key=lambda x: x.get("timestamp", ""))


if __name__ == "__main__":
    print("=== SwarmLogger v2.0.0 - Distributed Tracing Demo ===\n")

    # Create main logger (generates trace_id automatically)
    logger = SwarmLogger("orchestrator", task_id="task-001")
    print(f"Trace ID: {logger.trace_id}")
    print(f"Span ID: {logger.span_id}\n")

    logger.info("Pipeline started", pipeline="data-processing")

    # Use context manager for nested spans
    with logger.span("fetch_data") as fetch_logger:
        fetch_logger.info("Fetching data from API", endpoint="/api/data")
        fetch_logger.info("Data fetched", records=100)

    with logger.span("process_data") as process_logger:
        process_logger.info("Processing started")

        # Nested span
        with process_logger.span("validate") as validate_logger:
            validate_logger.info("Validating records")
            validate_logger.warning("Some records invalid", invalid_count=5)

        process_logger.info("Processing completed", processed=95)

    # Create child logger for worker
    worker_logger = logger.child_logger("backend-worker")
    worker_logger.info("Worker processing", batch_size=50)

    logger.info("Pipeline completed", status="success")

    # Read logs
    print("\n--- Reading logs for this trace ---")
    log_file = Path("logs") / f"swarm_{datetime.now().strftime('%Y-%m-%d')}.jsonl"
    trace_logs = get_trace(log_file, logger.trace_id)

    for entry in trace_logs:
        indent = "  " if entry.get("parent_span_id") else ""
        print(f"{indent}[{entry['span_id'][:4]}] {entry['level']}: {entry['message']}")
