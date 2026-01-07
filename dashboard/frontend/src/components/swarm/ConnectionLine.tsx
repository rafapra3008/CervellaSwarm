import type { Position } from './types';
import styles from './swarm.module.css';

interface ConnectionLineProps {
  from: Position;
  to: Position;
}

export function ConnectionLine({ from, to }: ConnectionLineProps) {
  // Curva quadratica Bezier - punto di controllo a meta strada con offset
  const midX = (from.x + to.x) / 2;
  const midY = (from.y + to.y) / 2;

  // Offset per curva (perpendicular to line)
  const dx = to.x - from.x;
  const dy = to.y - from.y;
  const len = Math.sqrt(dx * dx + dy * dy);
  const offsetAmount = len * 0.2; // 20% della lunghezza

  // Punto di controllo (perpendicular offset)
  const controlX = midX - (dy / len) * offsetAmount;
  const controlY = midY + (dx / len) * offsetAmount;

  const pathD = `M ${from.x} ${from.y} Q ${controlX} ${controlY} ${to.x} ${to.y}`;

  return (
    <path
      d={pathD}
      className={styles.connectionLine}
    />
  );
}
