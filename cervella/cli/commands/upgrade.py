"""
cervella upgrade - Gestione tier e upgrade
"""

import os
import click
from pathlib import Path
from rich.console import Console
from rich.table import Table
from rich.panel import Panel

console = Console()


@click.command()
@click.option("--set", "set_tier", type=click.Choice(["free", "pro", "team", "enterprise"]),
              help="Imposta tier (dev/testing)")
def upgrade(set_tier: str):
    """Mostra info tier e opzioni di upgrade.

    Per utenti Free mostra i vantaggi di Pro.
    Per Pro+ mostra lo stato attuale.

    Esempi:

        cervella upgrade              # Mostra info tier

        cervella upgrade --set pro    # Imposta tier (dev mode)
    """
    cwd = os.getcwd()
    sncp_path = Path(cwd) / ".sncp"

    # Check inizializzazione
    if not sncp_path.exists():
        console.print("[red]Errore:[/red] Cervella non inizializzata.")
        console.print("Esegui prima: [cyan]cervella init[/cyan]")
        raise click.Abort()

    from tier.tier_manager import TierManager, TierType, TIER_CONFIGS
    tier_mgr = TierManager(sncp_path)

    # Dev mode: set tier directly
    if set_tier:
        try:
            new_tier = TierType(set_tier)
            tier_mgr.set_tier(new_tier)
            console.print(f"[green]Tier impostato a {new_tier.value}[/green]")
            console.print("[dim]Nota: In produzione questo avverrà via license key[/dim]")
            return
        except ValueError:
            console.print(f"[red]Tier non valido:[/red] {set_tier}")
            raise click.Abort()

    # Mostra stato attuale
    status = tier_mgr.get_status_summary()
    current_tier = tier_mgr.get_tier()

    console.print(Panel.fit(
        f"[bold]Tier attuale:[/bold] {status['tier']} ({status['price']})",
        title="Cervella - Upgrade",
        border_style="blue"
    ))

    # Features attuali
    console.print("\n[bold]Le tue features:[/bold]")
    for feature in status["features"]:
        console.print(f"  [green]✓[/green] {feature}")

    # Se già Pro+, mostra solo conferma
    if current_tier != TierType.FREE:
        console.print(f"\n[green]Sei già su {status['tier']}! Grazie per il supporto.[/green]")
        return

    # Confronto tier per Free users
    console.print("\n")
    table = Table(title="Confronto Tier")
    table.add_column("Feature", style="white")
    table.add_column("Free", style="yellow")
    table.add_column("Pro ($20/mese)", style="green")
    table.add_column("Team ($40/user)", style="cyan")

    # Righe confronto
    table.add_row(
        "Agenti",
        "3 base",
        "[bold]16 tutti[/bold]",
        "[bold]16 tutti[/bold]"
    )
    table.add_row(
        "Task/mese",
        "50",
        "[bold]Illimitati[/bold]",
        "[bold]Illimitati[/bold]"
    )
    table.add_row(
        "API Key",
        "BYOK (tua)",
        "BYOK (tua)",
        "BYOK (tua)"
    )
    table.add_row(
        "Memoria SNCP",
        "✓",
        "✓",
        "✓"
    )
    table.add_row(
        "Supporto",
        "Community",
        "[bold]Email[/bold]",
        "[bold]Prioritario[/bold]"
    )
    table.add_row(
        "Dashboard",
        "-",
        "-",
        "[bold]Team dashboard[/bold]"
    )

    console.print(table)

    # CTA
    console.print("\n[bold]Sblocca tutto il potenziale di Cervella![/bold]")
    console.print("[dim]Upgrade a Pro: https://cervellaswarm.com/upgrade[/dim]")
    console.print("\n[dim]Per testing/dev: cervella upgrade --set pro[/dim]")
