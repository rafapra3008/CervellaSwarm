"""Multi-Level Progress Bars for CervellaSwarm.

This module provides a 3-level progress tracking system:
- TASK LEVEL: Single task progress (0-100%)
- SPRINT LEVEL: Sprint progress (tasks completed / total)
- PHASE LEVEL: Phase progress (sprints completed / total)

Supports ASCII colored output, in-place updates, and integration with SwarmLogger.

Usage:
    # Single task
    with ProgressBar("Installing dependencies") as pb:
        for i in range(100):
            pb.update(i)
            time.sleep(0.01)

    # Sprint with multiple tasks
    sprint = SprintProgress("Sprint 9.2", total_tasks=10)
    for task in tasks:
        with sprint.task(task.name) as pb:
            # work on task
            pb.update(50)
"""

__version__ = "1.0.0"
__version_date__ = "2026-01-03"

import sys
import time
from typing import Optional, TextIO
from enum import Enum
from contextlib import contextmanager


class BarStyle(Enum):
    """Progress bar visual styles."""
    FILLED = "█"
    EMPTY = "░"
    ARROW = ">"


class BarColor(Enum):
    """Terminal colors for progress bars."""
    RESET = "\033[0m"
    TASK = "\033[94m"      # Blue
    SPRINT = "\033[92m"    # Green
    PHASE = "\033[95m"     # Magenta
    LABEL = "\033[97m"     # White
    PERCENT = "\033[93m"   # Yellow


class ProgressBar:
    """Single-level progress bar with in-place updates.

    Displays a progress bar with percentage and optional message.
    Supports context manager for automatic completion.

    Attributes:
        label: Task name/description
        total: Total value (default 100 for percentage)
        width: Bar width in characters
        color: Bar color
        file: Output stream (default stdout)

    Example:
        >>> with ProgressBar("Installing deps", total=100) as pb:
        ...     pb.update(50)
        ...     pb.update(100)
        TASK:   ████████████░░░░░░░░  60% | Installing deps...
    """

    def __init__(
        self,
        label: str,
        total: int = 100,
        width: int = 20,
        color: BarColor = BarColor.TASK,
        file: Optional[TextIO] = None,
        show_percent: bool = True
    ):
        """Initialize ProgressBar.

        Args:
            label: Task description
            total: Maximum value for progress
            width: Width of progress bar in characters
            color: Color for the bar
            file: Output stream (default sys.stdout)
            show_percent: Whether to show percentage
        """
        self.label = label
        self.total = total
        self.width = width
        self.color = color
        self.file = file or sys.stdout
        self.show_percent = show_percent
        self.current = 0
        self._completed = False

    def update(self, value: int, message: Optional[str] = None) -> None:
        """Update progress to specific value.

        Args:
            value: Current progress value (0 to total)
            message: Optional status message
        """
        self.current = min(value, self.total)
        self._display(message)

    def increment(self, delta: int = 1, message: Optional[str] = None) -> None:
        """Increment progress by delta.

        Args:
            delta: Amount to increment
            message: Optional status message
        """
        self.update(self.current + delta, message)

    def complete(self, message: Optional[str] = None) -> None:
        """Mark progress as complete.

        Args:
            message: Optional completion message
        """
        self.current = self.total
        self._completed = True
        self._display(message or "Complete!")
        self.file.write("\n")
        self.file.flush()

    def _display(self, message: Optional[str] = None) -> None:
        """Display current progress bar.

        Args:
            message: Optional status message
        """
        # Calculate percentage
        percent = (self.current / self.total * 100) if self.total > 0 else 0

        # Calculate filled and empty portions
        filled_width = int(self.width * self.current / self.total) if self.total > 0 else 0
        empty_width = self.width - filled_width

        # Build bar
        bar = (BarStyle.FILLED.value * filled_width) + (BarStyle.EMPTY.value * empty_width)

        # Build message
        msg = f" | {message}" if message else f" | {self.label}"

        # Build full line
        if self.show_percent:
            line = f"{self.color.value}TASK:   {bar}{BarColor.RESET.value} {percent:3.0f}%{msg}"
        else:
            line = f"{self.color.value}TASK:   {bar}{BarColor.RESET.value}{msg}"

        # Print with carriage return (in-place update)
        self.file.write(f"\r{line}")
        self.file.flush()

    def __enter__(self):
        """Context manager entry."""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit - auto-complete."""
        if not self._completed:
            self.complete()
        return False


class SprintProgress:
    """Sprint-level progress tracker.

    Tracks multiple tasks within a sprint. Displays both task-level
    and sprint-level progress bars.

    Attributes:
        sprint_name: Sprint identifier
        total_tasks: Total number of tasks in sprint
        completed_tasks: Number of completed tasks

    Example:
        >>> sprint = SprintProgress("Sprint 9.2", total_tasks=10)
        >>> with sprint.task("Setup environment") as pb:
        ...     pb.update(100)
        >>> sprint.display()
        SPRINT: ████████░░░░░░░░░░░░  40% | 4/10 tasks
    """

    def __init__(
        self,
        sprint_name: str,
        total_tasks: int,
        width: int = 20,
        file: Optional[TextIO] = None
    ):
        """Initialize SprintProgress.

        Args:
            sprint_name: Sprint identifier
            total_tasks: Total tasks in sprint
            width: Width of progress bar
            file: Output stream
        """
        self.sprint_name = sprint_name
        self.total_tasks = total_tasks
        self.width = width
        self.file = file or sys.stdout
        self.completed_tasks = 0
        self._current_task: Optional[ProgressBar] = None

    @contextmanager
    def task(self, task_name: str):
        """Create and track a task within this sprint.

        Args:
            task_name: Task description

        Yields:
            ProgressBar for the task

        Example:
            >>> with sprint.task("Build frontend") as pb:
            ...     pb.update(50)
        """
        # Create task progress bar
        task_bar = ProgressBar(task_name, file=self.file)
        self._current_task = task_bar

        try:
            yield task_bar
        finally:
            # Ensure task is completed
            if not task_bar._completed:
                task_bar.complete()

            # Increment sprint progress
            self.completed_tasks += 1
            self._current_task = None

            # Show sprint progress
            self.display()

    def display(self) -> None:
        """Display sprint-level progress."""
        percent = (self.completed_tasks / self.total_tasks * 100) if self.total_tasks > 0 else 0
        filled_width = int(self.width * self.completed_tasks / self.total_tasks) if self.total_tasks > 0 else 0
        empty_width = self.width - filled_width

        bar = (BarStyle.FILLED.value * filled_width) + (BarStyle.EMPTY.value * empty_width)

        line = (
            f"{BarColor.SPRINT.value}SPRINT: {bar}{BarColor.RESET.value} "
            f"{percent:3.0f}% | {self.completed_tasks}/{self.total_tasks} tasks"
        )

        self.file.write(f"{line}\n")
        self.file.flush()

    def complete(self) -> None:
        """Mark sprint as complete."""
        self.completed_tasks = self.total_tasks
        self.display()


class PhaseProgress:
    """Phase-level progress tracker.

    Tracks multiple sprints within a phase. Displays all 3 levels:
    task, sprint, and phase progress.

    Attributes:
        phase_name: Phase identifier
        total_sprints: Total number of sprints
        completed_sprints: Number of completed sprints

    Example:
        >>> phase = PhaseProgress("Phase 9", total_sprints=10)
        >>> sprint = phase.sprint("Sprint 9.1", total_tasks=5)
        >>> with sprint.task("Task 1") as pb:
        ...     pb.update(100)
        >>> phase.complete_sprint()
        PHASE:  ██░░░░░░░░░░░░░░░░░░  10% | Sprint 1/10
    """

    def __init__(
        self,
        phase_name: str,
        total_sprints: int,
        width: int = 20,
        file: Optional[TextIO] = None
    ):
        """Initialize PhaseProgress.

        Args:
            phase_name: Phase identifier
            total_sprints: Total sprints in phase
            width: Width of progress bar
            file: Output stream
        """
        self.phase_name = phase_name
        self.total_sprints = total_sprints
        self.width = width
        self.file = file or sys.stdout
        self.completed_sprints = 0
        self._current_sprint: Optional[SprintProgress] = None

    def sprint(self, sprint_name: str, total_tasks: int) -> SprintProgress:
        """Create a new sprint within this phase.

        Args:
            sprint_name: Sprint identifier
            total_tasks: Total tasks in sprint

        Returns:
            SprintProgress instance

        Example:
            >>> sprint = phase.sprint("Sprint 9.2", total_tasks=8)
        """
        sprint = SprintProgress(sprint_name, total_tasks, self.width, self.file)
        self._current_sprint = sprint
        return sprint

    def complete_sprint(self) -> None:
        """Mark current sprint as complete and update phase progress."""
        if self._current_sprint:
            self._current_sprint.complete()

        self.completed_sprints += 1
        self._current_sprint = None
        self.display()

    def display(self) -> None:
        """Display phase-level progress."""
        percent = (self.completed_sprints / self.total_sprints * 100) if self.total_sprints > 0 else 0
        filled_width = int(self.width * self.completed_sprints / self.total_sprints) if self.total_sprints > 0 else 0
        empty_width = self.width - filled_width

        bar = (BarStyle.FILLED.value * filled_width) + (BarStyle.EMPTY.value * empty_width)

        line = (
            f"{BarColor.PHASE.value}PHASE:  {bar}{BarColor.RESET.value} "
            f"{percent:3.0f}% | Sprint {self.completed_sprints}/{self.total_sprints}"
        )

        self.file.write(f"{line}\n")
        self.file.flush()

    def complete(self) -> None:
        """Mark phase as complete."""
        self.completed_sprints = self.total_sprints
        self.display()


if __name__ == "__main__":
    # Example 1: Simple task progress
    print("=== EXAMPLE 1: Single Task ===\n")
    with ProgressBar("Installing dependencies") as pb:
        for i in range(0, 101, 10):
            pb.update(i, f"Package {i//10}/10")
            time.sleep(0.2)

    print("\n" + "="*50 + "\n")

    # Example 2: Sprint with multiple tasks
    print("=== EXAMPLE 2: Sprint Progress ===\n")
    sprint = SprintProgress("Sprint 9.2 - Quick Wins", total_tasks=5)

    tasks = [
        "Setup environment",
        "Install dependencies",
        "Configure linting",
        "Write tests",
        "Update documentation"
    ]

    for task_name in tasks:
        with sprint.task(task_name) as pb:
            for i in range(0, 101, 25):
                pb.update(i)
                time.sleep(0.1)
        time.sleep(0.2)

    print("\n" + "="*50 + "\n")

    # Example 3: Full phase with sprints
    print("=== EXAMPLE 3: Phase Progress ===\n")
    phase = PhaseProgress("Phase 9 - Apple Style", total_sprints=3)

    for sprint_num in range(1, 4):
        sprint = phase.sprint(f"Sprint 9.{sprint_num}", total_tasks=3)

        for task_num in range(1, 4):
            with sprint.task(f"Task {task_num}") as pb:
                for i in range(0, 101, 50):
                    pb.update(i)
                    time.sleep(0.1)

        phase.complete_sprint()
        print()

    print("\n=== ALL EXAMPLES COMPLETE ===")
