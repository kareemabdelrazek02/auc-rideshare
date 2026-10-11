const express = require('express');
const helmet = require('helmet');
const { requireAuth } = require('./auth');
const { HttpError } = require('./errors');
const { authRouter } = require('./routes/auth');
const { ridesRouter } = require('./routes/rides');
const { friendsRouter } = require('./routes/friends');
const { usersRouter } = require('./routes/users');

/**
 * Build the Express app from its dependencies (dependency injection keeps it testable:
 * tests pass the in-memory repository and fake SMS/geocoding services).
 */
function createApp({ config, repo, verification, geocode, realtime, logger = console }) {
  const app = express();
  app.disable('x-powered-by');
  app.use(helmet());
  app.use(express.json({ limit: '100kb' }));
  app.use((req, res, next) => {
    const origin = req.get('origin');
    if (origin && config.corsOrigins.includes(origin)) {
      res.set('Access-Control-Allow-Origin', origin);
      res.set('Vary', 'Origin');
      res.set('Access-Control-Allow-Headers', 'Authorization, Content-Type');
      res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    }
    if (req.method === 'OPTIONS') return res.sendStatus(204);
    next();
  });

  const auth = requireAuth({ config, repo });

  app.get('/health', (_req, res) => res.json({ status: 'ok' }));
  app.use('/api/auth', authRouter({ config, repo, verification }));
  app.use('/api/rides', ridesRouter({ repo, auth, realtime }));
  app.use('/api/friends', friendsRouter({ repo, auth }));
  app.use('/api/users', usersRouter({ repo, auth, geocode }));

  app.use((_req, _res, next) => next(new HttpError(404, 'Route not found')));

  // Express 5 forwards rejected promises from async handlers here automatically.
  app.use((err, _req, res, _next) => {
    if (err.type === 'entity.parse.failed') {
      return res.status(400).json({ error: 'Malformed JSON body' });
    }
    if (err instanceof HttpError) {
      return res.status(err.status).json({ error: err.message, details: err.details });
    }
    logger.error(err);
    res.status(500).json({ error: 'Internal server error' });
  });

  return app;
}

module.exports = { createApp };
