import type { NodeRole, NodeStatus } from './types';
import styles from './swarm.module.css';

interface SwarmNodeProps {
  x: number;
  y: number;
  emoji: string;
  role: NodeRole;
  status: NodeStatus;
  radius: number;
  onMouseEnter: (e: React.MouseEvent) => void;
  onMouseLeave: () => void;
}

function getNodeClass(role: NodeRole, status: NodeStatus): string {
  const baseClass = {
    regina: styles.reginaNode,
    guardiana: styles.guardianaNode,
    worker: styles.workerNode,
  }[role];

  if (status === 'working') {
    return `${styles.node} ${baseClass} ${styles.nodeWorking}`;
  }

  return `${styles.node} ${baseClass}`;
}

export function SwarmNodeComponent({
  x,
  y,
  emoji,
  role,
  status,
  radius,
  onMouseEnter,
  onMouseLeave,
}: SwarmNodeProps) {
  return (
    <g
      className={getNodeClass(role, status)}
      transform={`translate(${x}, ${y})`}
      onMouseEnter={onMouseEnter}
      onMouseLeave={onMouseLeave}
    >
      <circle
        r={radius}
        className={styles.nodeCircle}
      />
      <text
        className={styles.nodeEmoji}
        dy="0.1em"
      >
        {emoji}
      </text>
    </g>
  );
}
