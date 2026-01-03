#!/usr/bin/env python3
"""
CervellaSwarm Dashboard - Monitoring in tempo reale dello sciame

Dashboard ASCII minimale per monitorare lo stato dello swarm.
Visualizza workers, task queue, e attività recenti.

Usage:
    ./dashboard.py              # Visualizzazione singola
    ./dashboard.py --watch      # Refresh continuo (2s)
    ./dashboard.py --json       # Output JSON per script
    ./dashboard.py --help       # Mostra help
"""

__version__ = "1.0.0"
__version_date__ = "2026-01-03"

import sys
import json
import time
import argparse
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional
from collections import defaultdict

# Import task_manager dal nostro sistema
try:
    from task_manager import list_tasks, get_task_status, get_ack_status, TASKS_DIR
except ImportError:
    # Fallback se non siamo nella directory giusta
    sys.path.insert(0, str(Path(__file__).parent))
    from task_manager import list_tasks, get_task_status, get_ack_status, TASKS_DIR


# ========== COLORI ANSI ==========

class Colors:
    """Codici colore ANSI per terminale."""
    RESET = '\033[0m'
    BOLD = '\033[1m'
    DIM = '\033[2m'

    # Colori base
    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'

    # Colori bright
    BRIGHT_BLACK = '\033[90m'
    BRIGHT_RED = '\033[91m'
    BRIGHT_GREEN = '\033[92m'
    BRIGHT_YELLOW = '\033[93m'
    BRIGHT_BLUE = '\033[94m'
    BRIGHT_MAGENTA = '\033[95m'
    BRIGHT_CYAN = '\033[96m'
    BRIGHT_WHITE = '\033[97m'

    # Background
    BG_BLACK = '\033[40m'
    BG_RED = '\033[41m'
    BG_GREEN = '\033[42m'
    BG_YELLOW = '\033[43m'
    BG_BLUE = '\033[44m'

    @staticmethod
    def strip(text: str) -> str:
        """Rimuove tutti i codici colore da una stringa."""
        import re
        ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
        return ansi_escape.sub('', text)


def colorize(text: str, color: str) -> str:
    """Applica colore a un testo."""
    return f"{color}{text}{Colors.RESET}"


# ========== WORKERS CONFIGURAZIONE ==========

WORKERS = [
    {'name': 'cervella-orchestrator', 'emoji': '👑', 'type': 'regina'},
    {'name': 'cervella-guardiana-qualita', 'emoji': '🛡️', 'type': 'guardiana'},
    {'name': 'cervella-guardiana-ops', 'emoji': '🛡️', 'type': 'guardiana'},
    {'name': 'cervella-guardiana-ricerca', 'emoji': '🛡️', 'type': 'guardiana'},
    {'name': 'cervella-backend', 'emoji': '⚙️', 'type': 'worker'},
    {'name': 'cervella-frontend', 'emoji': '🎨', 'type': 'worker'},
    {'name': 'cervella-tester', 'emoji': '🧪', 'type': 'worker'},
    {'name': 'cervella-reviewer', 'emoji': '📋', 'type': 'worker'},
    {'name': 'cervella-researcher', 'emoji': '🔬', 'type': 'worker'},
    {'name': 'cervella-scienziata', 'emoji': '🔬', 'type': 'worker'},
    {'name': 'cervella-ingegnera', 'emoji': '👷‍♀️', 'type': 'worker'},
    {'name': 'cervella-marketing', 'emoji': '📈', 'type': 'worker'},
    {'name': 'cervella-devops', 'emoji': '🚀', 'type': 'worker'},
    {'name': 'cervella-docs', 'emoji': '📝', 'type': 'worker'},
    {'name': 'cervella-data', 'emoji': '📊', 'type': 'worker'},
    {'name': 'cervella-security', 'emoji': '🔒', 'type': 'worker'},
]


# ========== FUNZIONI DI RACCOLTA DATI ==========

def get_worker_status(worker_name: str, tasks: List[Dict]) -> Dict:
    """
    Determina lo stato di un worker basandosi sui task assegnati.

    Args:
        worker_name: Nome del worker
        tasks: Lista di tutti i task

    Returns:
        Dict con: status ('active', 'idle'), current_task, task_count
    """
    worker_tasks = [t for t in tasks if t['agent'] == worker_name]

    # Cerca task in working
    working_tasks = [t for t in worker_tasks if t['status'] == 'working']
    if working_tasks:
        task = working_tasks[0]  # Prendi il primo task working
        return {
            'status': 'active',
            'current_task': f"{task['task_id']}: {get_task_description(task['task_id'])}",
            'task_count': len(worker_tasks)
        }

    # Cerca task ready
    ready_tasks = [t for t in worker_tasks if t['status'] == 'ready']
    if ready_tasks:
        return {
            'status': 'ready',
            'current_task': f"{len(ready_tasks)} task pending",
            'task_count': len(worker_tasks)
        }

    # Altrimenti idle
    return {
        'status': 'idle',
        'current_task': '-',
        'task_count': len(worker_tasks)
    }


def get_task_description(task_id: str) -> str:
    """
    Estrae la descrizione breve di un task dal file.

    Args:
        task_id: ID del task

    Returns:
        Descrizione breve (prime 40 char del titolo)
    """
    try:
        task_file = Path(TASKS_DIR) / f"{task_id}.md"
        if not task_file.exists():
            return "Unknown task"

        content = task_file.read_text()
        lines = content.split('\n')

        # Prima riga dovrebbe essere "# TASK: Descrizione"
        if lines and lines[0].startswith('# TASK:'):
            desc = lines[0].replace('# TASK:', '').strip()
            # Tronca a 40 caratteri
            if len(desc) > 40:
                desc = desc[:37] + '...'
            return desc

        return "No description"
    except Exception:
        return "Error reading task"


def get_task_queue_stats(tasks: List[Dict]) -> Dict:
    """
    Calcola statistiche della task queue.

    Args:
        tasks: Lista di tutti i task

    Returns:
        Dict con: pending, in_progress, completed, failed
    """
    stats = {
        'pending': 0,
        'ready': 0,
        'in_progress': 0,
        'completed': 0,
        'failed': 0
    }

    for task in tasks:
        status = task['status']
        if status == 'created':
            stats['pending'] += 1
        elif status == 'ready':
            stats['ready'] += 1
        elif status == 'working':
            stats['in_progress'] += 1
        elif status == 'done':
            stats['completed'] += 1
        # Non abbiamo status 'failed' nel task_manager, ma lo teniamo per futuro

    return stats


def get_recent_activity(tasks: List[Dict], limit: int = 5) -> List[Dict]:
    """
    Ottiene l'attività recente dai file task.

    Args:
        tasks: Lista di tutti i task
        limit: Numero massimo di eventi da mostrare

    Returns:
        Lista di dict con: timestamp, agent, action, task_id
    """
    activities = []

    tasks_path = Path(TASKS_DIR)

    # Raccogli tutti i file marker con timestamp
    for task_file in tasks_path.glob("TASK_*"):
        if task_file.suffix in ['.done', '.working', '.ready', '.ack_received', '.ack_understood']:
            task_id = task_file.stem
            if task_file.suffix in ['.ack_received', '.ack_understood']:
                # Rimuovi il suffisso per ottenere task_id
                task_id = task_file.name.replace('.ack_received', '').replace('.ack_understood', '')

            action_map = {
                '.done': 'Completed',
                '.working': 'Started',
                '.ready': 'Ready',
                '.ack_received': 'Received',
                '.ack_understood': 'Understood'
            }

            # Cerca agent dal task
            agent = 'unknown'
            for t in tasks:
                if t['task_id'] == task_id:
                    agent = t['agent'].replace('cervella-', '')
                    break

            activities.append({
                'timestamp': task_file.stat().st_mtime,
                'agent': agent,
                'action': action_map.get(task_file.suffix, 'Unknown'),
                'task_id': task_id
            })

    # Ordina per timestamp decrescente e prendi solo limit
    activities.sort(key=lambda x: x['timestamp'], reverse=True)
    return activities[:limit]


def calculate_session_duration() -> str:
    """
    Calcola la durata della sessione corrente.

    Returns:
        Stringa con durata (es. "45m")
    """
    # Per ora ritorniamo un valore fisso
    # In futuro potremmo leggere da un file di session start
    return "N/A"


# ========== RENDERING DASHBOARD ==========

def render_header() -> str:
    """Renderizza l'header della dashboard."""
    lines = []
    lines.append("╔══════════════════════════════════════════════════════════════════════════════════════╗")
    lines.append("║" + colorize("                         🐝 CERVELLASWARM DASHBOARD                                  ", Colors.BOLD) + "║")
    lines.append("╠══════════════════════════════════════════════════════════════════════════════════════╣")
    return '\n'.join(lines)


def render_workers(tasks: List[Dict]) -> str:
    """Renderizza la tabella workers."""
    lines = []
    lines.append("║                                                                                      ║")
    lines.append("║  " + colorize("WORKERS STATUS", Colors.BOLD) + "                                                                      ║")
    lines.append("║  ┌────────────────────────────┬──────────┬─────────────────────────────────────────┐ ║")
    lines.append("║  │ Worker                     │ Status   │ Current Task                            │ ║")
    lines.append("║  ├────────────────────────────┼──────────┼─────────────────────────────────────────┤ ║")

    for worker in WORKERS:
        status_info = get_worker_status(worker['name'], tasks)

        # Formatta nome worker con emoji
        worker_display = f"{worker['emoji']} {worker['name'].replace('cervella-', '')}"

        # Formatta status con colore
        status = status_info['status']
        if status == 'active':
            status_display = colorize("● ACTIVE", Colors.BRIGHT_GREEN)
        elif status == 'ready':
            status_display = colorize("◐ READY ", Colors.BRIGHT_YELLOW)
        else:
            status_display = colorize("○ IDLE  ", Colors.BRIGHT_BLACK)

        # Tronca current_task a 40 caratteri
        current_task = status_info['current_task']
        if len(current_task) > 40:
            current_task = current_task[:37] + '...'

        # Calcola padding per allineare colonne
        # Nota: dobbiamo considerare i codici colore ANSI nel calcolo
        worker_clean = Colors.strip(worker_display)
        status_clean = Colors.strip(status_display)

        worker_pad = 27 - len(worker_clean)
        status_pad = 9 - len(status_clean)
        task_pad = 40 - len(current_task)

        line = f"║  │ {worker_display}{' ' * worker_pad}│ {status_display}{' ' * status_pad}│ {current_task}{' ' * task_pad}│ ║"
        lines.append(line)

    lines.append("║  └────────────────────────────┴──────────┴─────────────────────────────────────────┘ ║")
    return '\n'.join(lines)


def render_stats(tasks: List[Dict]) -> str:
    """Renderizza le statistiche task queue e metrics."""
    lines = []

    stats = get_task_queue_stats(tasks)
    duration = calculate_session_duration()

    lines.append("║                                                                                      ║")
    lines.append("║  " + colorize("TASK QUEUE", Colors.BOLD) + "                          " + colorize("METRICS", Colors.BOLD) + "                                      ║")
    lines.append("║  ┌──────────────────────┐           ┌──────────────────────┐                        ║")

    # Task Queue
    pending = colorize(f"{stats['pending'] + stats['ready']}", Colors.BRIGHT_YELLOW)
    in_progress = colorize(f"{stats['in_progress']}", Colors.BRIGHT_GREEN)
    completed = colorize(f"{stats['completed']}", Colors.BRIGHT_CYAN)

    # Metrics
    failed = colorize(f"{stats['failed']}", Colors.BRIGHT_RED if stats['failed'] > 0 else Colors.BRIGHT_GREEN)

    # Calcola padding
    pending_clean = Colors.strip(pending)
    in_progress_clean = Colors.strip(in_progress)
    completed_clean_left = Colors.strip(completed)
    completed_clean_right = Colors.strip(completed)
    failed_clean = Colors.strip(failed)

    pending_pad = 3 - len(pending_clean)
    in_progress_pad = 2 - len(in_progress_clean)
    completed_pad_left = 2 - len(completed_clean_left)
    completed_pad_right = 2 - len(completed_clean_right)
    failed_pad = 4 - len(failed_clean)

    lines.append(f"║  │ Pending:    {pending}{' ' * pending_pad}        │           │ Completed: {completed}{' ' * completed_pad_right}        │                        ║")
    lines.append(f"║  │ In Progress: {in_progress}{' ' * in_progress_pad}       │           │ Failed:    {failed}{' ' * failed_pad}        │                        ║")
    lines.append(f"║  │ Completed:  {completed}{' ' * completed_pad_left}        │           │ Duration:  {duration}        │                        ║")
    lines.append("║  └──────────────────────┘           └──────────────────────┘                        ║")

    return '\n'.join(lines)


def render_activity(tasks: List[Dict]) -> str:
    """Renderizza l'attività recente."""
    lines = []

    lines.append("║                                                                                      ║")
    lines.append("║  " + colorize("LAST ACTIVITY", Colors.BOLD) + "                                                                        ║")

    activities = get_recent_activity(tasks, limit=5)

    if not activities:
        lines.append("║  " + colorize("No recent activity", Colors.DIM) + "                                                                         ║")
    else:
        for activity in activities:
            # Formatta timestamp
            dt = datetime.fromtimestamp(activity['timestamp'])
            time_str = dt.strftime("%H:%M:%S")

            # Formatta agent (massimo 12 caratteri)
            agent = activity['agent'][:12]

            # Formatta action con colore
            action = activity['action']
            if action == 'Completed':
                action_display = colorize(action, Colors.BRIGHT_GREEN)
            elif action == 'Started':
                action_display = colorize(action, Colors.BRIGHT_YELLOW)
            else:
                action_display = colorize(action, Colors.BRIGHT_CYAN)

            # Formatta messaggio
            message = f"{activity['task_id']}"

            # Calcola padding
            action_clean = Colors.strip(action_display)
            agent_pad = 12 - len(agent)
            action_pad = 12 - len(action_clean)

            line = f"║  {time_str} | {agent}{' ' * agent_pad}| {action_display}{' ' * action_pad}| {message}"

            # Padding finale per allineamento
            line_clean = Colors.strip(line)
            final_pad = 86 - len(line_clean)
            line += ' ' * final_pad + "║"

            lines.append(line)

    return '\n'.join(lines)


def render_footer() -> str:
    """Renderizza il footer della dashboard."""
    lines = []
    lines.append("║                                                                                      ║")
    lines.append("╚══════════════════════════════════════════════════════════════════════════════════════╝")
    return '\n'.join(lines)


def render_dashboard(tasks: List[Dict]) -> str:
    """
    Renderizza la dashboard completa.

    Args:
        tasks: Lista di tutti i task

    Returns:
        Stringa con dashboard ASCII completa
    """
    sections = [
        render_header(),
        render_workers(tasks),
        render_stats(tasks),
        render_activity(tasks),
        render_footer()
    ]

    return '\n'.join(sections)


# ========== OUTPUT JSON ==========

def render_json(tasks: List[Dict]) -> str:
    """
    Renderizza output in formato JSON.

    Args:
        tasks: Lista di tutti i task

    Returns:
        Stringa JSON
    """
    workers_status = []
    for worker in WORKERS:
        status_info = get_worker_status(worker['name'], tasks)
        workers_status.append({
            'name': worker['name'],
            'emoji': worker['emoji'],
            'type': worker['type'],
            'status': status_info['status'],
            'current_task': status_info['current_task'],
            'task_count': status_info['task_count']
        })

    stats = get_task_queue_stats(tasks)
    activities = get_recent_activity(tasks, limit=10)

    # Formatta activities per JSON
    activities_formatted = []
    for activity in activities:
        activities_formatted.append({
            'timestamp': datetime.fromtimestamp(activity['timestamp']).isoformat(),
            'agent': activity['agent'],
            'action': activity['action'],
            'task_id': activity['task_id']
        })

    data = {
        'timestamp': datetime.now().isoformat(),
        'workers': workers_status,
        'queue_stats': stats,
        'recent_activity': activities_formatted
    }

    return json.dumps(data, indent=2)


# ========== MAIN ==========

def clear_screen():
    """Pulisce lo schermo del terminale."""
    print('\033[2J\033[H', end='')


def main():
    """Entry point principale."""
    parser = argparse.ArgumentParser(
        description='CervellaSwarm Dashboard - Monitoring in tempo reale dello sciame',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s              # Visualizzazione singola
  %(prog)s --watch      # Refresh continuo (2s)
  %(prog)s --json       # Output JSON per script
        """
    )

    parser.add_argument(
        '--watch',
        action='store_true',
        help='Refresh continuo ogni 2 secondi'
    )

    parser.add_argument(
        '--json',
        action='store_true',
        help='Output in formato JSON'
    )

    parser.add_argument(
        '--interval',
        type=int,
        default=2,
        help='Intervallo di refresh in secondi (default: 2)'
    )

    parser.add_argument(
        '--version',
        action='version',
        version=f'%(prog)s {__version__} ({__version_date__})'
    )

    args = parser.parse_args()

    try:
        if args.watch:
            # Watch mode: refresh continuo
            print(colorize("\n🐝 CervellaSwarm Dashboard - Watch Mode (Ctrl+C per uscire)\n", Colors.BRIGHT_CYAN))

            while True:
                tasks = list_tasks()

                clear_screen()

                if args.json:
                    print(render_json(tasks))
                else:
                    print(render_dashboard(tasks))

                time.sleep(args.interval)
        else:
            # Single shot mode
            tasks = list_tasks()

            if args.json:
                print(render_json(tasks))
            else:
                print(render_dashboard(tasks))

    except KeyboardInterrupt:
        print(colorize("\n\n👋 Dashboard chiusa. Arrivederci!\n", Colors.BRIGHT_CYAN))
        sys.exit(0)

    except Exception as e:
        print(colorize(f"\n❌ Errore: {e}\n", Colors.BRIGHT_RED), file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
