import { useState, useCallback, useMemo, useRef } from 'react';
import { SwarmNodeComponent } from './SwarmNode';
import { SwarmTooltip } from './SwarmTooltip';
import { ConnectionLine } from './ConnectionLine';
import type { SwarmNode, NodeWithPosition } from './types';
import { getCirclePosition, FAMIGLIA_DATA } from './types';
import type { Famiglia } from '../../types';
import styles from './swarm.module.css';

// Dimensioni layout
const REGINA_RADIUS = 40;
const GUARDIANA_RADIUS = 25;
const WORKER_RADIUS = 20;
const GUARDIANA_ORBIT = 100;
const WORKER_ORBIT = 180;
const SVG_SIZE = 450;
const CENTER = SVG_SIZE / 2;

interface SwarmWidgetProps {
  famiglia?: Famiglia;
  loading?: boolean;
}

// Merge famiglia data with static FAMIGLIA_DATA
function mergeWithApiData(apiData?: Famiglia): SwarmNode[] {
  if (!apiData) {
    return FAMIGLIA_DATA;
  }

  // Create lookup for API status
  const statusLookup = new Map<string, { status: 'idle' | 'working'; task?: string }>();

  // Regina
  if (apiData.regina) {
    statusLookup.set(apiData.regina.nome, {
      status: apiData.regina.status === 'working' ? 'working' : 'idle',
      task: apiData.regina.taskCorrente,
    });
  }

  // Guardiane
  apiData.guardiane.forEach((g) => {
    statusLookup.set(g.nome, {
      status: g.status === 'working' ? 'working' : 'idle',
      task: g.taskCorrente,
    });
  });

  // Worker
  apiData.workers.forEach((w) => {
    statusLookup.set(w.nome, {
      status: w.status === 'working' ? 'working' : 'idle',
      task: w.taskCorrente,
    });
  });

  // Update FAMIGLIA_DATA with API status
  return FAMIGLIA_DATA.map((node) => {
    const apiStatus = statusLookup.get(node.name);
    if (apiStatus) {
      return {
        ...node,
        status: apiStatus.status,
        currentTask: apiStatus.task,
      };
    }
    return node;
  });
}

function calculatePositions(nodes: SwarmNode[]): NodeWithPosition[] {
  const result: NodeWithPosition[] = [];

  const regina = nodes.find((n) => n.role === 'regina');
  const guardiane = nodes.filter((n) => n.role === 'guardiana');
  const workers = nodes.filter((n) => n.role === 'worker');

  // Regina al centro
  if (regina) {
    result.push({
      ...regina,
      position: { x: CENTER, y: CENTER },
      radius: REGINA_RADIUS,
    });
  }

  // Guardiane nel primo anello
  guardiane.forEach((g, index) => {
    const pos = getCirclePosition(index, guardiane.length, GUARDIANA_ORBIT);
    result.push({
      ...g,
      position: { x: CENTER + pos.x, y: CENTER + pos.y },
      radius: GUARDIANA_RADIUS,
    });
  });

  // Worker nel secondo anello
  workers.forEach((w, index) => {
    const pos = getCirclePosition(index, workers.length, WORKER_ORBIT);
    result.push({
      ...w,
      position: { x: CENTER + pos.x, y: CENTER + pos.y },
      radius: WORKER_RADIUS,
    });
  });

  return result;
}

export function SwarmWidget({ famiglia, loading = false }: SwarmWidgetProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [hoveredNode, setHoveredNode] = useState<SwarmNode | null>(null);
  const [tooltipPosition, setTooltipPosition] = useState({ x: 0, y: 0 });

  // Merge API data with static data
  const nodes = useMemo(() => mergeWithApiData(famiglia), [famiglia]);

  // Calculate positions
  const nodesWithPositions = useMemo(() => calculatePositions(nodes), [nodes]);

  // Get working nodes for connections
  const workingNodes = useMemo(
    () => nodesWithPositions.filter((n) => n.status === 'working' && n.role !== 'regina'),
    [nodesWithPositions]
  );

  // Regina position
  const reginaPosition = useMemo(
    () => nodesWithPositions.find((n) => n.role === 'regina')?.position ?? { x: CENTER, y: CENTER },
    [nodesWithPositions]
  );

  // Stats
  const activeCount = nodes.filter((n) => n.status === 'working').length;
  const idleCount = nodes.length - activeCount;

  const handleMouseEnter = useCallback(
    (node: SwarmNode) => (e: React.MouseEvent) => {
      const rect = containerRef.current?.getBoundingClientRect();
      if (rect) {
        setTooltipPosition({
          x: e.clientX - rect.left + 15,
          y: e.clientY - rect.top + 15,
        });
      }
      setHoveredNode(node);
    },
    []
  );

  const handleMouseLeave = useCallback(() => {
    setHoveredNode(null);
  }, []);

  if (loading) {
    return (
      <div className="glass-card p-8 animate-pulse">
        <div className="h-[400px] bg-bg-tertiary rounded-lg"></div>
      </div>
    );
  }

  return (
    <div className="glass-card p-8">
      {/* Header */}
      <div className={styles.header}>
        <div className={styles.headerTitle}>
          <div className={styles.headerIcon}>🐝</div>
          <span className={styles.headerLabel}>Lo Sciame</span>
        </div>
        <div className={styles.headerStats}>
          <span className={`${styles.headerStat} ${styles.headerStatActive}`}>
            {activeCount} attivi
          </span>
          <span className={`${styles.headerStat} ${styles.headerStatIdle}`}>
            {idleCount} idle
          </span>
        </div>
      </div>

      {/* Swarm Visualization */}
      <div ref={containerRef} className={styles.swarmContainer}>
        <svg
          className={styles.swarmSvg}
          viewBox={`0 0 ${SVG_SIZE} ${SVG_SIZE}`}
          preserveAspectRatio="xMidYMid meet"
        >
          {/* Connection lines for working nodes */}
          {workingNodes.map((node) => (
            <ConnectionLine
              key={`conn-${node.id}`}
              from={node.position}
              to={reginaPosition}
            />
          ))}

          {/* Nodes */}
          {nodesWithPositions.map((node) => (
            <SwarmNodeComponent
              key={node.id}
              x={node.position.x}
              y={node.position.y}
              emoji={node.emoji}
              role={node.role}
              status={node.status}
              radius={node.radius}
              onMouseEnter={handleMouseEnter(node)}
              onMouseLeave={handleMouseLeave}
            />
          ))}
        </svg>

        {/* Tooltip */}
        <SwarmTooltip
          node={hoveredNode}
          position={tooltipPosition}
          visible={hoveredNode !== null}
        />
      </div>

      {/* Legend */}
      <div className={styles.legend}>
        <div className={styles.legendItem}>
          <span className={`${styles.legendDot} ${styles.legendDotRegina}`} />
          <span>Regina</span>
        </div>
        <div className={styles.legendItem}>
          <span className={`${styles.legendDot} ${styles.legendDotGuardiana}`} />
          <span>Guardiane</span>
        </div>
        <div className={styles.legendItem}>
          <span className={`${styles.legendDot} ${styles.legendDotWorker}`} />
          <span>Worker</span>
        </div>
        <div className={styles.legendItem}>
          <span className={`${styles.legendDot} ${styles.legendDotWorking}`} />
          <span>Working</span>
        </div>
      </div>
    </div>
  );
}
