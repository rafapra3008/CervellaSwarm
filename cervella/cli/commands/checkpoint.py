"""
cervella checkpoint - Salva stato del progetto
"""

import os
import click
from datetime import datetime
from rich.console import Console
from rich.panel import Panel

console = Console()


@click.command()
@click.option("--message", "-m", default=None, help="Messaggio checkpoint")
@click.option("--git", is_flag=True, help="Crea anche commit git")
def checkpoint(message: str, git: bool):
    """Salva lo stato corrente del progetto.

    Crea un checkpoint della memoria SNCP e opzionalmente
    un commit git con le modifiche.

    Esempi:

        cervella checkpoint -m "Fine sprint autenticazione"

        cervella checkpoint --git -m "Feature login completata"
    """
    cwd = os.getcwd()
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")

    console.print(Panel.fit(
        f"[bold blue]Checkpoint[/bold blue] - {timestamp}",
        subtitle="Salvando stato"
    ))

    # Salva stato SNCP
    from sncp.manager import SNSCPManager
    manager = SNSCPManager(cwd)

    checkpoint_msg = message or f"Checkpoint {timestamp}"
    checkpoint_file = manager.create_checkpoint(checkpoint_msg)

    console.print(f"\n[green]Checkpoint salvato:[/green] {checkpoint_file}")

    # Git commit se richiesto
    if git:
        import subprocess
        try:
            # Add all changes
            subprocess.run(["git", "add", "."], cwd=cwd, check=True, capture_output=True)

            # Commit
            commit_msg = f"Checkpoint: {checkpoint_msg}\n\nCo-Authored-By: Cervella <cervella@cervellaswarm.com>"
            subprocess.run(
                ["git", "commit", "-m", commit_msg],
                cwd=cwd,
                check=True,
                capture_output=True
            )

            console.print("[green]Git commit creato![/green]")

        except subprocess.CalledProcessError as e:
            # Distingui tra errori soft e hard
            stderr = e.stderr.decode() if e.stderr else ""
            stdout = e.stdout.decode() if e.stdout else ""
            output = stderr + stdout

            # Errore soft: niente da committare (exit code 1 con messaggio specifico)
            if e.returncode == 1 and ("nothing to commit" in output.lower() or
                                       "niente da sottoporre" in output.lower() or
                                       "no changes added" in output.lower()):
                console.print("[yellow]Nessuna modifica da committare.[/yellow]")
            else:
                # Errore serio: mostra dettagli e interrompi
                console.print(f"[red]Errore Git (code {e.returncode}):[/red]")
                if stderr:
                    console.print(f"[red]{stderr}[/red]")
                if stdout:
                    console.print(f"[dim]{stdout}[/dim]")
                console.print("\n[yellow]Azione richiesta:[/yellow] Risolvi il problema e riprova.")
                raise click.Abort()

    console.print("\n[bold]Stato salvato.[/bold] Buon lavoro!")
