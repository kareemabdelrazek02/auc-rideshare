const http = require('node:http');
const { loadConfig } = require('./config');
const { createApp } = require('./app');
const { createMemoryRepository } = require('./repositories/memory');
const { createSupabaseRepository } = require('./repositories/supabase');
const { createSmsSender, createVerificationService } = require('./services/sms');
const { createGeocoder } = require('./services/geocode');
const { createRealtimeNotifier, attachRealtime } = require('./realtime');

function buildServer(config = loadConfig()) {
  const repo =
    config.dataStore === 'supabase' ? createSupabaseRepository(config) : createMemoryRepository();
  const verification = createVerificationService({ send: createSmsSender(config) });
  const geocode = createGeocoder(config);
  const realtime = createRealtimeNotifier();

  const app = createApp({ config, repo, verification, geocode, realtime });
  const server = http.createServer(app);
  attachRealtime(server, { config, repo, notifier: realtime });
  return { server, config };
}

if (require.main === module) {
  const { server, config } = buildServer();
  server.listen(config.port, () => {
    console.log(`AUC Rideshare API on http://localhost:${config.port} (data: ${config.dataStore})`);
  });
}

module.exports = { buildServer };
