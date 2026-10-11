const request = require('supertest');
const { createApp } = require('../src/app');
const { createMemoryRepository } = require('../src/repositories/memory');
const { createVerificationService } = require('../src/services/sms');
const { createRealtimeNotifier } = require('../src/realtime');

const config = {
  isProduction: false,
  corsOrigins: ['http://localhost:3000'],
  jwtSecret: 'test-secret',
  jwtExpiresIn: '1h',
};

/** A fresh app with in-memory storage, captured SMS messages and a fake geocoder. */
function setup({ clock } = {}) {
  const repo = createMemoryRepository();
  const sent = [];
  const verification = createVerificationService({
    send: async (phone, message) => sent.push({ phone, message }),
    clock,
  });
  const geocode = async () => 'AUC New Cairo, Egypt';
  const realtime = createRealtimeNotifier();
  const silent = { error() {}, info() {} };
  const app = createApp({ config, repo, verification, geocode, realtime, logger: silent });
  const api = request(app);

  let counter = 0;
  async function register(overrides = {}) {
    counter += 1;
    const body = {
      aucId: String(900000000 + counter),
      firstName: 'Test',
      lastName: `User${counter}`,
      phoneNumber: `+2010000000${String(counter).padStart(2, '0')}`,
      password: 'correct horse',
      isDriver: false,
      ...overrides,
    };
    const res = await api.post('/api/auth/register').send(body).expect(201);
    return { ...res.body.user, token: res.body.token, password: body.password };
  }

  const as = (user) => ({
    get: (url) => api.get(url).set('Authorization', `Bearer ${user.token}`),
    post: (url) => api.post(url).set('Authorization', `Bearer ${user.token}`),
  });

  return { api, repo, sent, register, as, config };
}

module.exports = { setup, config };
