"""
cervella task - Delega un task agli agenti
"""

import click
from rich.console import Console
from rich.panel import Panel
from rich.live import Live
from rich.spinner import Spinner

console = Console()


def _sanitize_task(description: str) -> str:
    """Sanitizza input task per sicurezza.

    Rimuove caratteri di controllo e pattern sospetti.
    """
    # Rimuovi caratteri di controllo (mantieni solo printable e whitespace)
    cleaned = "".join(c for c in description if c.isprintable() or c in "\n\t ")

    # Pattern sospetti che potrebbero indicare prompt injection
    suspicious = ["<|endoftext|>", "<|im_end|>", "SYSTEM:", "ASSISTANT:", "Human:"]
    for pattern in suspicious:
        if pattern.lower() in cleaned.lower():
            raise click.ClickException(f"Contenuto non permesso nel task: pattern sospetto rilevato")

    return cleaned.strip()


@click.command()
@click.argument("description", required=True)
@click.option("--agent", "-a", default=None, help="Specifica agente (default: Regina decide)")
@click.option("--dry-run", is_flag=True, help="Mostra cosa farebbe senza eseguire")
def task(description: str, agent: str, dry_run: bool):
    """Delega un task agli agenti Cervella.

    La Regina analizza il task e lo assegna all'agente più adatto.

    Esempi:

        cervella task "Implementa autenticazione JWT"

        cervella task "Scrivi test per il modulo users" --agent tester

        cervella task "Analizza i competitor" --agent scienziata
    """
    # Validazione input
    if not description or not description.strip():
        console.print("[red]Errore:[/red] La descrizione del task non può essere vuota.")
        raise click.Abort()

    # Sanitizza per sicurezza
    description = _sanitize_task(description)

    # Warning se troppo lungo
    if len(description) > 5000:
        console.print(f"[yellow]Warning:[/yellow] Task molto lungo ({len(description)} chars).")
        console.print("[yellow]Potrebbe consumare molti token.[/yellow]")
        if not click.confirm("Continuare?"):
            raise click.Abort()

    console.print(Panel.fit(
        f"[bold]Task:[/bold] {description}",
        title="Cervella",
        border_style="blue"
    ))

    if dry_run:
        console.print("\n[yellow][DRY RUN] Ecco cosa farei:[/yellow]")
        console.print(f"  1. Analizzare il task")
        console.print(f"  2. Scegliere l'agente migliore")
        console.print(f"  3. Delegare e monitorare")
        return

    # Import e esegui
    from agents.runner import AgentRunner
    from api.client import ClaudeClient

    try:
        client = ClaudeClient()
        runner = AgentRunner(client)

        with console.status("[bold blue]Regina sta analizzando...[/bold blue]"):
            result = runner.run_task(description, agent_name=agent)

        console.print("\n[green]Task completato![/green]")
        console.print(Panel(result.output, title="Risultato", border_style="green"))

        if result.files_created:
            console.print("\n[cyan]File creati:[/cyan]")
            for f in result.files_created:
                console.print(f"  - {f}")

    except Exception as e:
        console.print(f"\n[red]Errore:[/red] {e}")
        raise click.Abort()
