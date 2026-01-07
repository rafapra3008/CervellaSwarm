// Types per il SwarmWidget

export type NodeRole = 'regina' | 'guardiana' | 'worker';
export type NodeStatus = 'idle' | 'working';

export interface SwarmNode {
  id: string;
  name: string;
  emoji: string;
  role: NodeRole;
  description: string;
  status: NodeStatus;
  currentTask?: string;
}

export interface Position {
  x: number;
  y: number;
}

export interface NodeWithPosition extends SwarmNode {
  position: Position;
  radius: number;
}

export interface SwarmConnection {
  from: string;
  to: string;
}

// Calcola posizione su cerchio dato angolo e raggio
export function getCirclePosition(index: number, total: number, radius: number): Position {
  // Start from top (-PI/2) and go clockwise
  const angle = (index / total) * 2 * Math.PI - Math.PI / 2;
  return {
    x: Math.cos(angle) * radius,
    y: Math.sin(angle) * radius,
  };
}

// Dati famiglia statici
export const FAMIGLIA_DATA: SwarmNode[] = [
  // Regina
  { id: 'regina', name: 'cervella-orchestrator', emoji: '👑', role: 'regina', description: 'La Regina - Coordina tutto', status: 'idle' },
  // Guardiane
  { id: 'g-qualita', name: 'cervella-guardiana-qualita', emoji: '🛡️', role: 'guardiana', description: 'Verifica output agenti', status: 'idle' },
  { id: 'g-ops', name: 'cervella-guardiana-ops', emoji: '🛡️', role: 'guardiana', description: 'Supervisiona devops/security', status: 'idle' },
  { id: 'g-ricerca', name: 'cervella-guardiana-ricerca', emoji: '🛡️', role: 'guardiana', description: 'Verifica qualita ricerche', status: 'idle' },
  // Worker
  { id: 'frontend', name: 'cervella-frontend', emoji: '🎨', role: 'worker', description: 'React, CSS, UI/UX', status: 'idle' },
  { id: 'backend', name: 'cervella-backend', emoji: '⚙️', role: 'worker', description: 'Python, FastAPI, API', status: 'idle' },
  { id: 'tester', name: 'cervella-tester', emoji: '🧪', role: 'worker', description: 'Testing, Debug, QA', status: 'idle' },
  { id: 'reviewer', name: 'cervella-reviewer', emoji: '📋', role: 'worker', description: 'Code review', status: 'idle' },
  { id: 'researcher', name: 'cervella-researcher', emoji: '🔬', role: 'worker', description: 'Ricerca TECNICA', status: 'idle' },
  { id: 'scienziata', name: 'cervella-scienziata', emoji: '🔬', role: 'worker', description: 'Ricerca STRATEGICA', status: 'idle' },
  { id: 'ingegnera', name: 'cervella-ingegnera', emoji: '👷', role: 'worker', description: 'Analisi codebase', status: 'idle' },
  { id: 'marketing', name: 'cervella-marketing', emoji: '📈', role: 'worker', description: 'Marketing, UX strategy', status: 'idle' },
  { id: 'devops', name: 'cervella-devops', emoji: '🚀', role: 'worker', description: 'Deploy, CI/CD, Docker', status: 'idle' },
  { id: 'docs', name: 'cervella-docs', emoji: '📝', role: 'worker', description: 'Documentazione', status: 'idle' },
  { id: 'data', name: 'cervella-data', emoji: '📊', role: 'worker', description: 'SQL, analytics, query', status: 'idle' },
  { id: 'security', name: 'cervella-security', emoji: '🔒', role: 'worker', description: 'Audit sicurezza', status: 'idle' },
];
