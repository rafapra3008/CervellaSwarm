/**
 * Config Manager
 *
 * Centralized configuration management for CervellaSwarm CLI.
 * Uses `conf` for persistent storage with schema validation.
 *
 * Two config levels:
 * 1. GLOBAL (user home) - API key, defaults, preferences
 * 2. PROJECT (.sncp/) - Project-specific settings
 *
 * "Define once, use everywhere."
 *
 * Copyright 2026 Rafa & Cervella
 * Licensed under the Apache License, Version 2.0
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Conf from 'conf';

// Schema for global config validation
const globalSchema = {
  apiKey: {
    type: 'string',
    default: ''
  },
  defaultModel: {
    type: 'string',
    enum: ['claude-sonnet-4-20250514', 'claude-opus-4-5-20251101'],
    default: 'claude-sonnet-4-20250514'
  },
  timeout: {
    type: 'number',
    minimum: 10000,
    maximum: 600000,
    default: 120000
  },
  maxRetries: {
    type: 'number',
    minimum: 1,
    maximum: 10,
    default: 3
  },
  verbose: {
    type: 'boolean',
    default: false
  },
  telemetry: {
    type: 'boolean',
    default: false
  },
  // Billing/Subscription fields
  tier: {
    type: 'string',
    enum: ['free', 'pro', 'team', 'enterprise'],
    default: 'free'
  },
  customerId: {
    type: 'string',
    default: ''
  },
  subscriptionId: {
    type: 'string',
    default: ''
  },
  email: {
    type: 'string',
    default: ''
  },
  lastSync: {
    type: 'number',
    default: 0
  }
};

// Global config instance (singleton)
let globalConfig = null;

/**
 * Get global config instance
 * Creates it on first call with schema validation
 */
function getGlobalConfig() {
  if (!globalConfig) {
    globalConfig = new Conf({
      projectName: 'cervellaswarm',
      schema: globalSchema,
      defaults: {
        apiKey: '',
        defaultModel: 'claude-sonnet-4-20250514',
        timeout: 120000,
        maxRetries: 3,
        verbose: false,
        telemetry: false,
        tier: 'free',
        customerId: '',
        subscriptionId: '',
        email: '',
        lastSync: 0
      }
    });
  }
  return globalConfig;
}

// ============================================
// API KEY MANAGEMENT
// ============================================

/**
 * Get API key from config or environment
 * Priority: 1. Environment variable, 2. Saved config
 */
export function getApiKey() {
  // Environment variable takes priority (for CI/CD, containers, etc)
  const envKey = process.env.ANTHROPIC_API_KEY;
  if (envKey) {
    return envKey;
  }

  // Fall back to saved config
  const config = getGlobalConfig();
  const savedKey = config.get('apiKey');
  return savedKey || null;
}

/**
 * Save API key to config
 */
export function setApiKey(key) {
  if (!key || typeof key !== 'string') {
    throw new Error('API key must be a non-empty string');
  }

  // Basic validation - Anthropic keys start with 'sk-ant-'
  if (!key.startsWith('sk-ant-')) {
    throw new Error('Invalid API key format. Anthropic keys start with sk-ant-');
  }

  const config = getGlobalConfig();
  config.set('apiKey', key);
  return true;
}

/**
 * Check if API key is configured (either env or saved)
 */
export function hasApiKey() {
  return getApiKey() !== null;
}

/**
 * Clear saved API key from config
 */
export function clearApiKey() {
  const config = getGlobalConfig();
  config.set('apiKey', '');
  return true;
}

/**
 * Get API key source (for diagnostics)
 */
export function getApiKeySource() {
  if (process.env.ANTHROPIC_API_KEY) {
    return 'environment';
  }
  const config = getGlobalConfig();
  if (config.get('apiKey')) {
    return 'config';
  }
  return 'none';
}

// ============================================
// MODEL & AGENT SETTINGS
// ============================================

/**
 * Get default model
 */
export function getDefaultModel() {
  const config = getGlobalConfig();
  return config.get('defaultModel');
}

/**
 * Set default model
 */
export function setDefaultModel(model) {
  const validModels = ['claude-sonnet-4-20250514', 'claude-opus-4-5-20251101'];
  if (!validModels.includes(model)) {
    throw new Error(`Invalid model. Choose from: ${validModels.join(', ')}`);
  }
  const config = getGlobalConfig();
  config.set('defaultModel', model);
  return true;
}

/**
 * Get timeout setting (ms)
 */
export function getTimeout() {
  const config = getGlobalConfig();
  return config.get('timeout');
}

/**
 * Set timeout (ms)
 */
export function setTimeout(ms) {
  if (ms < 10000 || ms > 600000) {
    throw new Error('Timeout must be between 10000ms (10s) and 600000ms (10min)');
  }
  const config = getGlobalConfig();
  config.set('timeout', ms);
  return true;
}

/**
 * Get max retries
 */
export function getMaxRetries() {
  const config = getGlobalConfig();
  return config.get('maxRetries');
}

/**
 * Set max retries
 */
export function setMaxRetries(retries) {
  if (retries < 1 || retries > 10) {
    throw new Error('Max retries must be between 1 and 10');
  }
  const config = getGlobalConfig();
  config.set('maxRetries', retries);
  return true;
}

// ============================================
// PREFERENCES
// ============================================

/**
 * Get verbose mode
 */
export function isVerbose() {
  const config = getGlobalConfig();
  return config.get('verbose');
}

/**
 * Set verbose mode
 */
export function setVerbose(enabled) {
  const config = getGlobalConfig();
  config.set('verbose', !!enabled);
  return true;
}

/**
 * Get telemetry setting
 */
export function isTelemetryEnabled() {
  const config = getGlobalConfig();
  return config.get('telemetry');
}

/**
 * Set telemetry setting
 */
export function setTelemetry(enabled) {
  const config = getGlobalConfig();
  config.set('telemetry', !!enabled);
  return true;
}

// ============================================
// BULK OPERATIONS
// ============================================

/**
 * Get all global config as object
 */
export function getAllConfig() {
  const config = getGlobalConfig();
  return {
    apiKey: config.get('apiKey') ? '***configured***' : 'not set',
    apiKeySource: getApiKeySource(),
    defaultModel: config.get('defaultModel'),
    timeout: config.get('timeout'),
    maxRetries: config.get('maxRetries'),
    verbose: config.get('verbose'),
    telemetry: config.get('telemetry')
  };
}

/**
 * Reset all config to defaults
 */
export function resetConfig() {
  const config = getGlobalConfig();
  config.clear();
  return true;
}

/**
 * Get config file path (for diagnostics)
 */
export function getConfigPath() {
  const config = getGlobalConfig();
  return config.path;
}

// ============================================
// DIAGNOSTIC / DOCTOR
// ============================================

/**
 * Run diagnostic checks
 * Returns object with status of each check
 */
export function runDiagnostics() {
  const results = {
    configFile: { status: 'ok', path: getConfigPath() },
    apiKey: { status: 'missing', source: 'none' },
    model: { status: 'ok', value: getDefaultModel() }
  };

  // Check API key
  const apiKey = getApiKey();
  if (apiKey) {
    results.apiKey.status = 'ok';
    results.apiKey.source = getApiKeySource();
    // Mask the key for display
    results.apiKey.preview = `${apiKey.substring(0, 10)}...${apiKey.substring(apiKey.length - 4)}`;
  }

  return results;
}

/**
 * Validate API key by making a test call
 * Returns { valid: boolean, error?: string }
 */
export async function validateApiKey(key = null) {
  const testKey = key || getApiKey();

  if (!testKey) {
    return { valid: false, error: 'No API key provided' };
  }

  if (!testKey.startsWith('sk-ant-')) {
    return { valid: false, error: 'Invalid key format' };
  }

  try {
    // Dynamic import to avoid loading Anthropic if not needed
    const { default: Anthropic } = await import('@anthropic-ai/sdk');
    const client = new Anthropic({ apiKey: testKey });

    // Minimal test call - just check if key works
    await client.messages.create({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 10,
      messages: [{ role: 'user', content: 'hi' }]
    });

    return { valid: true };
  } catch (error) {
    // Map error codes to user-friendly messages
    if (error.status === 401) {
      return { valid: false, error: 'Invalid API key' };
    }
    if (error.status === 403) {
      return { valid: false, error: 'API key lacks permissions' };
    }
    if (error.status === 429) {
      // Rate limited but key is valid
      return { valid: true, warning: 'Rate limited, but key is valid' };
    }
    return { valid: false, error: error.message || 'Unknown error' };
  }
}

// ============================================
// BILLING / SUBSCRIPTION
// ============================================

// API URL for billing backend
const BILLING_API_URL = process.env.CERVELLASWARM_API_URL || 'https://cervellaswarm-api.fly.dev';

/**
 * Get billing API URL
 */
export function getBillingApiUrl() {
  return BILLING_API_URL;
}

/**
 * Get current tier
 */
export function getTier() {
  const config = getGlobalConfig();
  return config.get('tier');
}

/**
 * Set tier
 */
export function setTier(tier) {
  const validTiers = ['free', 'pro', 'team', 'enterprise'];
  if (!validTiers.includes(tier)) {
    throw new Error(`Invalid tier. Choose from: ${validTiers.join(', ')}`);
  }
  const config = getGlobalConfig();
  config.set('tier', tier);
  return true;
}

/**
 * Get customer ID
 */
export function getCustomerId() {
  const config = getGlobalConfig();
  return config.get('customerId') || null;
}

/**
 * Set customer ID
 */
export function setCustomerId(customerId) {
  const config = getGlobalConfig();
  config.set('customerId', customerId);
  return true;
}

/**
 * Get subscription ID
 */
export function getSubscriptionId() {
  const config = getGlobalConfig();
  return config.get('subscriptionId') || null;
}

/**
 * Set subscription ID
 */
export function setSubscriptionId(subscriptionId) {
  const config = getGlobalConfig();
  config.set('subscriptionId', subscriptionId);
  return true;
}

/**
 * Get email
 */
export function getEmail() {
  const config = getGlobalConfig();
  return config.get('email') || null;
}

/**
 * Set email
 */
export function setEmail(email) {
  const config = getGlobalConfig();
  config.set('email', email);
  return true;
}

/**
 * Get last sync timestamp
 */
export function getLastSync() {
  const config = getGlobalConfig();
  return config.get('lastSync') || 0;
}

/**
 * Set last sync timestamp
 */
export function setLastSync(timestamp = Date.now()) {
  const config = getGlobalConfig();
  config.set('lastSync', timestamp);
  return true;
}

/**
 * Update subscription data from API response
 */
export function updateSubscriptionData(data) {
  const config = getGlobalConfig();
  if (data.tier) config.set('tier', data.tier);
  if (data.customerId) config.set('customerId', data.customerId);
  if (data.subscriptionId) config.set('subscriptionId', data.subscriptionId);
  if (data.email) config.set('email', data.email);
  config.set('lastSync', Date.now());
  return true;
}

/**
 * Get subscription info for display
 */
export function getSubscriptionInfo() {
  const config = getGlobalConfig();
  return {
    tier: config.get('tier'),
    customerId: config.get('customerId') || null,
    subscriptionId: config.get('subscriptionId') || null,
    email: config.get('email') || null,
    lastSync: config.get('lastSync') || 0
  };
}

/**
 * Check if subscription needs sync (older than 24h)
 */
export function needsSync() {
  const lastSync = getLastSync();
  const twentyFourHours = 24 * 60 * 60 * 1000;
  return Date.now() - lastSync > twentyFourHours;
}
