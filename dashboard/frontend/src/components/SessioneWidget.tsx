import { useEffect, useState } from 'react';
import type { SessioneAttiva, LogMessage } from '../types';

interface SessioneWidgetProps { sessione?: SessioneAttiva; loading?: boolean; }

const mockLogs: LogMessage[] = [
  { timestamp: '21:15:23', message: 'Task avviato: Dashboard Design V2', type: 'info' },
  { timestamp: '21:16:05', message: 'Analisi completata', type: 'success' },
  { timestamp: '21:16:30', message: 'Applicando stile Jony Ive...', type: 'info' },
  { timestamp: '21:17:15', message: 'Glassmorphism configurato', type: 'success' },
];

const mockSessione: SessioneAttiva = {
  taskId: 'TASK_DESIGN_DASHBOARD_V2',
  taskNome: 'Dashboard Design V2',
  workerAssegnato: 'cervella-frontend',
  inizioTimestamp: '2026-01-07T21:15:23',
  durataSecondi: 180,
  outputFile: '.swarm/tasks/TASK_DESIGN_output.md',
  logs: mockLogs,
  isActive: true,
};

function formatDuration(s: number): string {
  return `${Math.floor(s / 60)}:${(s % 60).toString().padStart(2, '0')}`;
}

export function SessioneWidget({ sessione = mockSessione }: SessioneWidgetProps) {
  const [duration, setDuration] = useState(sessione.durataSecondi);

  useEffect(() => {
    if (!sessione.isActive) return;
    const interval = setInterval(() => setDuration((p) => p + 1), 1000);
    return () => clearInterval(interval);
  }, [sessione.isActive]);

  if (!sessione.isActive) {
    return (
      <div className="glass-card p-8">
        <div className="flex items-center gap-3 mb-6">
          <div className="w-8 h-8 rounded-lg bg-bg-tertiary flex items-center justify-center">💻</div>
          <span className="text-sm font-semibold tracking-wider uppercase text-text-secondary">Sessione Attiva</span>
        </div>
        <div className="text-center py-12">
          <span className="text-5xl mb-4 block opacity-50">😴</span>
          <p className="text-text-secondary">Nessun task in esecuzione</p>
        </div>
      </div>
    );
  }

  return (
    <div className="glass-card p-8 border-accent/30">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-lg bg-accent/20 flex items-center justify-center">🐝</div>
          <span className="text-sm font-semibold tracking-wider uppercase text-text-secondary">Sessione Attiva</span>
        </div>
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-accent/10 border border-accent/20">
          <span className="status-dot status-working" />
          <span className="text-accent text-sm font-medium">In esecuzione</span>
        </div>
      </div>

      <div className="rounded-xl bg-bg-secondary/50 p-5 mb-6 border border-bg-tertiary">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-5">
          <div>
            <span className="text-xs text-text-muted uppercase">Task</span>
            <p className="text-text-primary font-medium mt-1">{sessione.taskNome}</p>
          </div>
          <div>
            <span className="text-xs text-text-muted uppercase">Worker</span>
            <p className="text-accent font-medium mt-1">{sessione.workerAssegnato}</p>
          </div>
          <div>
            <span className="text-xs text-text-muted uppercase">Durata</span>
            <p className="text-text-primary font-mono text-xl mt-1">{formatDuration(duration)}</p>
          </div>
          <div>
            <span className="text-xs text-text-muted uppercase">Output</span>
            <p className="text-text-secondary text-sm truncate mt-1">{sessione.outputFile}</p>
          </div>
        </div>
      </div>

      <div>
        <div className="flex items-center justify-between mb-3">
          <span className="text-xs text-text-muted uppercase">Log</span>
        </div>
        <div className="rounded-xl bg-bg-primary/60 p-4 max-h-44 overflow-y-auto font-mono text-xs">
          {sessione.logs.slice(-7).map((log, i) => (
            <div key={i} className="flex items-start gap-3 py-1">
              <span className="text-text-muted/50">{log.timestamp}</span>
              <span className={log.type === 'success' ? 'text-success' : 'text-text-muted'}>{log.message}</span>
            </div>
          ))}
        </div>
      </div>

      <div className="mt-6 flex gap-3">
        <button className="btn-secondary flex-1">Vedi Log</button>
        <button className="px-5 py-2.5 rounded-xl bg-error/10 hover:bg-error/20 border border-error/20 text-error text-sm font-medium">Ferma</button>
      </div>
    </div>
  );
}
