import type { ReactNode } from 'react';

interface LayoutProps { children: ReactNode; }

export function Layout({ children }: LayoutProps) {
  return (
    <div className="min-h-screen bg-bg-primary text-text-primary">
      <div className="fixed inset-0 pointer-events-none">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-accent/5 rounded-full blur-3xl" />
        <div className="absolute bottom-0 right-1/4 w-96 h-96 bg-accent/3 rounded-full blur-3xl" />
      </div>

      <header className="relative z-10 glass-card mx-6 mt-6 mb-8 rounded-xl">
        <div className="px-8 py-5 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-accent to-accent-light flex items-center justify-center shadow-glow">
              <span className="text-xl">🐝</span>
            </div>
            <div>
              <h1 className="text-lg font-semibold tracking-wide text-text-primary">CervellaSwarm</h1>
              <p className="text-xs text-text-muted tracking-wider uppercase">Dashboard</p>
            </div>
          </div>
          <div className="flex items-center gap-6">
            <span className="text-sm text-text-secondary">La MAPPA del progetto</span>
            <button className="w-8 h-8 rounded-lg bg-bg-tertiary hover:bg-accent/10 flex items-center justify-center transition-colors">
              <span className="text-text-secondary text-sm">?</span>
            </button>
          </div>
        </div>
      </header>

      <main className="relative z-10 px-6 pb-24">{children}</main>

      <footer className="fixed bottom-0 left-0 right-0 z-10">
        <div className="mx-6 mb-4">
          <div className="glass-card rounded-xl px-6 py-3 flex items-center justify-between text-sm">
            <span className="text-text-muted italic">"Prima la MAPPA, poi il VIAGGIO"</span>
            <span className="text-text-secondary">CervellaSwarm <span className="text-accent">v1.0.0</span></span>
          </div>
        </div>
      </footer>
    </div>
  );
}
