import type { SwarmNode } from './types';
import styles from './swarm.module.css';

interface SwarmTooltipProps {
  node: SwarmNode | null;
  position: { x: number; y: number };
  visible: boolean;
}

export function SwarmTooltip({ node, position, visible }: SwarmTooltipProps) {
  if (!node) return null;

  const isWorking = node.status === 'working';

  return (
    <div
      className={`${styles.tooltip} ${visible ? styles.tooltipVisible : ''}`}
      style={{
        left: position.x,
        top: position.y,
      }}
    >
      <div className={styles.tooltipHeader}>
        <span className={styles.tooltipEmoji}>{node.emoji}</span>
        <span className={styles.tooltipName}>{node.name.replace('cervella-', '')}</span>
      </div>

      <div className={styles.tooltipRole}>{node.description}</div>

      <div className={styles.tooltipStatus}>
        <span
          className={`${styles.tooltipStatusDot} ${
            isWorking ? styles.tooltipStatusDotWorking : styles.tooltipStatusDotIdle
          }`}
        />
        <span className={styles.tooltipStatusLabel}>
          {isWorking ? 'Working' : 'Idle'}
        </span>
      </div>

      {isWorking && node.currentTask && (
        <div className={styles.tooltipTask}>
          <div className={styles.tooltipTaskLabel}>Task corrente</div>
          <div className={styles.tooltipTaskName}>{node.currentTask}</div>
        </div>
      )}
    </div>
  );
}
