/**
 * CervellaSwarm Billing API
 *
 * Express server for Stripe webhook handling and checkout sessions.
 * Deployed on Fly.io.
 *
 * Copyright 2026 Rafa & Cervella
 */

import "dotenv/config";
import express, { Request, Response, NextFunction } from "express";
import cors from "cors";

import checkoutRoutes from "./routes/checkout.js";
import portalRoutes from "./routes/portal.js";
import subscriptionRoutes from "./routes/subscription.js";
import webhookRoutes from "./routes/webhooks.js";

const app = express();
const PORT = process.env.PORT || 3001;

// ============================================
// Middleware
// ============================================

// CORS - allow CLI from anywhere
app.use(cors());

// IMPORTANT: Webhook route MUST receive raw body for signature verification!
// This must come BEFORE express.json()
app.use(
  "/webhooks/stripe",
  express.raw({ type: "application/json" })
);

// JSON parsing for all other routes
app.use(express.json());

// Request logging
app.use((req: Request, _res: Response, next: NextFunction) => {
  console.log(`${new Date().toISOString()} ${req.method} ${req.path}`);
  next();
});

// ============================================
// Routes
// ============================================

// Health check
app.get("/health", (_req: Request, res: Response) => {
  res.json({
    status: "ok",
    service: "cervellaswarm-api",
    timestamp: new Date().toISOString(),
  });
});

// API routes
app.use("/api", checkoutRoutes);
app.use("/api", portalRoutes);
app.use("/api", subscriptionRoutes);

// Webhook routes (already receives raw body)
app.use("/webhooks", webhookRoutes);

// 404 handler
app.use((_req: Request, res: Response) => {
  res.status(404).json({ error: "Not found" });
});

// Error handler
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error("Unhandled error:", err);
  res.status(500).json({ error: "Internal server error" });
});

// ============================================
// Start Server
// ============================================

app.listen(PORT, () => {
  console.log(`
+================================================+
|   CervellaSwarm Billing API                    |
|                                                |
|   Port: ${PORT}                                    |
|   Environment: ${process.env.NODE_ENV || "development"}                   |
|                                                |
|   Endpoints:                                   |
|   - POST /api/create-checkout-session          |
|   - POST /api/create-portal-session            |
|   - GET  /api/subscription/:customerId         |
|   - GET  /api/subscription/by-email/:email     |
|   - POST /webhooks/stripe                      |
|   - GET  /health                               |
+================================================+
  `);
});

export default app;
