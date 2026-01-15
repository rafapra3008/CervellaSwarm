/**
 * Agent Spawner
 *
 * Launches specialized agents to execute tasks.
 * Uses claude CLI with agent-specific prompts.
 *
 * "16 agenti. 1 comando. Il tuo team AI."
 */

import { spawn } from 'child_process';
import { existsSync } from 'fs';
import { homedir } from 'os';
import { join } from 'path';

/**
 * Find claude CLI binary
 */
function findClaudeBin() {
  // Check common locations
  const possiblePaths = [
    '/usr/local/bin/claude',
    '/opt/homebrew/bin/claude',
    join(homedir(), '.local/bin/claude'),
    join(homedir(), '.nvm/versions/node', '*', 'bin/claude'),
  ];

  // Try which command first
  try {
    const which = spawn('which', ['claude'], { stdio: ['pipe', 'pipe', 'pipe'] });
    return new Promise((resolve) => {
      let output = '';
      which.stdout.on('data', (data) => { output += data.toString(); });
      which.on('close', (code) => {
        if (code === 0 && output.trim()) {
          resolve(output.trim());
        } else {
          // Fallback to checking paths
          for (const p of possiblePaths) {
            if (!p.includes('*') && existsSync(p)) {
              resolve(p);
              return;
            }
          }
          resolve(null);
        }
      });
    });
  } catch {
    return Promise.resolve(null);
  }
}

/**
 * Get agent-specific prompt
 */
function getAgentPrompt(agent, context) {
  const projectName = context?.name || 'this project';
  const projectDescription = context?.description || '';

  const prompts = {
    'cervella-backend': `Sei CERVELLA-BACKEND, specialista Python, FastAPI, Database, API REST, logica business.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: Backend, API, database, server-side logic.
Stile: Codice pulito, ben documentato, testabile.`,

    'cervella-frontend': `Sei CERVELLA-FRONTEND, specialista React, CSS, Tailwind, UI/UX, componenti.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: UI, componenti, styling, user experience.
Stile: Componenti riutilizzabili, accessibili, responsive.`,

    'cervella-tester': `Sei CERVELLA-TESTER, specialista Testing, Debug, QA, validazione.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: Test unitari, integration test, bug hunting.
Stile: Test completi, edge cases, coverage alta.`,

    'cervella-docs': `Sei CERVELLA-DOCS, specialista Documentazione, README, guide, tutorial.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: Documentazione chiara, esempi pratici, getting started.
Stile: Conciso ma completo, utente-first.`,

    'cervella-devops': `Sei CERVELLA-DEVOPS, specialista Deploy, CI/CD, Docker, infrastruttura.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: Deployment, automation, monitoring, infrastructure.
Stile: Sicuro, scalabile, automatizzato.`,

    'cervella-data': `Sei CERVELLA-DATA, specialista SQL, analytics, query, database design.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: Query ottimizzate, schema design, data integrity.
Stile: Performance-first, normalization quando serve.`,

    'cervella-security': `Sei CERVELLA-SECURITY, specialista sicurezza, audit, vulnerabilità.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: Security audit, vulnerabilities, best practices.
Stile: Defense in depth, zero trust, secure by default.`,

    'cervella-researcher': `Sei CERVELLA-RESEARCHER, specialista ricerca tecnica, studi, analisi.
Lavori su: ${projectName}${projectDescription ? ` - ${projectDescription}` : ''}
Focus: Ricerca approfondita, comparazioni, best practices.
Stile: Fonti affidabili, analisi critica, raccomandazioni chiare.`,
  };

  return prompts[agent] || prompts['cervella-backend'];
}

/**
 * Spawn an agent to execute a task
 */
export async function spawnAgent(agent, description, context) {
  const claudeBin = await findClaudeBin();

  if (!claudeBin) {
    console.log('');
    console.log('  Claude CLI not found.');
    console.log('  Install: npm install -g @anthropic-ai/claude-code');
    console.log('');
    return {
      success: false,
      error: 'Claude CLI not found',
      filesModified: [],
      nextStep: 'Install Claude CLI first'
    };
  }

  const agentPrompt = getAgentPrompt(agent, context);

  return new Promise((resolve) => {
    const startTime = Date.now();
    let output = '';
    let errorOutput = '';

    // Run claude with -p (print mode) and agent prompt
    const claude = spawn(claudeBin, [
      '-p',
      '--append-system-prompt', agentPrompt,
      description
    ], {
      cwd: process.cwd(),
      env: {
        ...process.env,
        // Use Claude Max account, not API key
        ANTHROPIC_API_KEY: undefined
      },
      stdio: ['pipe', 'pipe', 'pipe']
    });

    // Capture output
    claude.stdout.on('data', (data) => {
      const text = data.toString();
      output += text;
      // Stream output to console
      process.stdout.write(text);
    });

    claude.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    claude.on('close', (code) => {
      const duration = Math.round((Date.now() - startTime) / 1000);

      if (code === 0) {
        resolve({
          success: true,
          output: output.trim(),
          duration: `${duration}s`,
          filesModified: extractFilesModified(output),
          nextStep: suggestNextStep(agent, description)
        });
      } else {
        resolve({
          success: false,
          error: errorOutput || `Exit code: ${code}`,
          output: output.trim(),
          filesModified: [],
          nextStep: 'Review the error and try again'
        });
      }
    });

    claude.on('error', (err) => {
      resolve({
        success: false,
        error: err.message,
        filesModified: [],
        nextStep: 'Check if Claude CLI is properly installed'
      });
    });
  });
}

/**
 * Extract files modified from claude output
 */
function extractFilesModified(output) {
  const files = [];
  const patterns = [
    /(?:Created|Modified|Updated|Wrote):\s*([^\n]+)/gi,
    /Writing to ([^\n]+)/gi,
    /Editing ([^\n]+)/gi
  ];

  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(output)) !== null) {
      const file = match[1].trim();
      if (file && !files.includes(file)) {
        files.push(file);
      }
    }
  }

  return files;
}

/**
 * Suggest next step based on agent and task
 */
function suggestNextStep(agent, description) {
  const suggestions = {
    'cervella-backend': 'Test the API endpoint or write unit tests',
    'cervella-frontend': 'Preview in browser or run visual tests',
    'cervella-tester': 'Run the full test suite',
    'cervella-docs': 'Review documentation for clarity',
    'cervella-devops': 'Test the deployment in staging',
    'cervella-data': 'Verify query performance',
    'cervella-security': 'Run security scan on changes',
    'cervella-researcher': 'Apply findings to your project'
  };

  return suggestions[agent] || 'Continue with your next task';
}
