const crypto = require('node:crypto');

const CODE_TTL_MS = 5 * 60 * 1000;
const MAX_ATTEMPTS = 5;

/** SMS senders. "console" is for local development only; it never returns the code to the client. */
function createSmsSender(config, { fetchImpl = fetch, logger = console } = {}) {
  if (config.smsProvider === 'textbelt') {
    if (!config.textbeltKey) throw new Error('TEXTBELT_KEY is required for SMS_PROVIDER=textbelt');
    return async (phone, message) => {
      const res = await fetchImpl('https://textbelt.com/text', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ phone, message, key: config.textbeltKey }),
      });
      const body = await res.json();
      if (!body.success) throw new Error(`SMS provider error: ${body.error || 'unknown'}`);
    };
  }
  if (config.smsProvider === 'console') {
    if (config.isProduction) throw new Error('SMS_PROVIDER=console is not allowed in production');
    return async (phone, message) => logger.info(`[dev sms] to ${phone}: ${message}`);
  }
  throw new Error(`Unknown SMS_PROVIDER: ${config.smsProvider}`);
}

const hash = (code) => crypto.createHash('sha256').update(code).digest('hex');

/**
 * One-time phone verification codes.
 * Codes are stored hashed, expire after 5 minutes and lock after 5 wrong attempts.
 * (In-memory: fine for a single instance; use Redis or a DB table when scaling out.)
 */
function createVerificationService({ send, clock = Date.now }) {
  const pending = new Map();

  return {
    async start(phone) {
      const code = crypto.randomInt(100000, 1000000).toString();
      pending.set(phone, { hash: hash(code), expiresAt: clock() + CODE_TTL_MS, attempts: 0 });
      await send(phone, `Your AUC Rideshare code is ${code}. It expires in 5 minutes.`);
    },
    /** Returns 'ok' | 'missing' | 'expired' | 'locked' | 'invalid'. */
    check(phone, code) {
      const record = pending.get(phone);
      if (!record) return 'missing';
      if (clock() > record.expiresAt) {
        pending.delete(phone);
        return 'expired';
      }
      if (record.attempts >= MAX_ATTEMPTS) return 'locked';
      const ok = crypto.timingSafeEqual(Buffer.from(record.hash), Buffer.from(hash(code)));
      if (!ok) {
        record.attempts += 1;
        return 'invalid';
      }
      pending.delete(phone);
      return 'ok';
    },
  };
}

module.exports = { createSmsSender, createVerificationService, CODE_TTL_MS, MAX_ATTEMPTS };
