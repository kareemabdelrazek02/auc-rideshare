require('dotenv').config({ quiet: true });

const isProduction = process.env.NODE_ENV === 'production';

function required(name) {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

/**
 * Central configuration. In production every secret must be set explicitly;
 * in development the app falls back to an in-memory database and console SMS.
 */
function loadConfig(env = process.env) {
  const dataStore = env.DATA_STORE || (env.SUPABASE_URL ? 'supabase' : 'memory');
  return {
    port: Number(env.PORT) || 3000,
    isProduction,
    corsOrigins: (env.CORS_ORIGINS || 'http://localhost:3000').split(',').map((s) => s.trim()),
    jwtSecret: isProduction ? required('JWT_SECRET') : env.JWT_SECRET || 'dev-only-secret-change-me',
    jwtExpiresIn: env.JWT_EXPIRES_IN || '7d',
    dataStore,
    supabaseUrl: env.SUPABASE_URL,
    // The backend is a trusted server, so it uses the service-role key.
    // Never ship this key in the mobile app.
    supabaseServiceKey: env.SUPABASE_SERVICE_ROLE_KEY,
    smsProvider: env.SMS_PROVIDER || 'console',
    textbeltKey: env.TEXTBELT_KEY,
    geocodeEnabled: env.GEOCODE_ENABLED !== 'false',
  };
}

module.exports = { loadConfig };
