import type { Nord } from '../types';

interface NordWidgetProps { nord?: Nord; loading?: boolean; }

const mockNord: Nord = {
  obiettivo: "LIBERTA' GEOGRAFICA",
  descrizione: "Quando l'avremo raggiunta, Rafa scattera una foto da un posto speciale nel mondo.",
  progressoGenerale: 15,
  sessioneCorrente: 117,
  frase: "L'idea e' fare il mondo meglio su di come riusciamo a fare."
};

export function NordWidget({ nord = mockNord, loading = false }: NordWidgetProps) {
  if (loading) {
    return <div className="glass-card p-8 animate-pulse"><div className="h-12 bg-bg-tertiary rounded-lg"></div></div>;
  }

  return (
    <div className="glass-card p-8 hover-lift group">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-accent to-accent-light flex items-center justify-center">
            <span className="text-lg">⭐</span>
          </div>
          <span className="text-sm font-semibold tracking-wider uppercase text-text-secondary">Il Nord</span>
        </div>
        <div className="px-3 py-1 rounded-full bg-bg-tertiary">
          <span className="text-xs text-text-muted">Sessione <span className="text-accent font-medium">{nord.sessioneCorrente}</span></span>
        </div>
      </div>

      <div className="relative mb-6 p-6 rounded-xl bg-gradient-to-br from-bg-tertiary to-bg-secondary border border-accent/20 group-hover:border-accent/30 transition-colors">
        <h3 className="text-2xl font-bold text-center mb-3 gradient-text">{nord.obiettivo}</h3>
        <p className="text-sm text-text-secondary text-center leading-relaxed">{nord.descrizione}</p>
      </div>

      <div className="mb-6">
        <div className="flex justify-between items-center mb-3">
          <span className="text-sm text-text-secondary">Progresso Generale</span>
          <span className="text-sm font-semibold text-accent">{nord.progressoGenerale}%</span>
        </div>
        <div className="progress-bar">
          <div className="progress-bar-fill" style={{ width: `${nord.progressoGenerale}%` }} />
        </div>
      </div>

      {nord.frase && (
        <blockquote className="relative pl-4 border-l-2 border-accent/30">
          <p className="text-sm text-text-muted italic leading-relaxed">"{nord.frase}"</p>
        </blockquote>
      )}
    </div>
  );
}
