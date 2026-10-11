const { setup } = require('./helpers');

describe('auth', () => {
  it('registers a user, hashes the password and never returns the hash', async () => {
    const { register, repo } = setup();
    const user = await register({ aucId: '900123456' });
    expect(user.token).toBeTruthy();
    expect(user.passwordHash).toBeUndefined();
    const stored = await repo.findUser('900123456');
    expect(stored.passwordHash).toMatch(/^\$2[aby]\$/);
    expect(stored.passwordHash).not.toContain('correct horse');
  });

  it('rejects duplicate AUC IDs and phone numbers', async () => {
    const { api, register } = setup();
    const user = await register();
    const dupeId = { ...user, phoneNumber: '+201099999999', password: 'another pass' };
    await api.post('/api/auth/register').send(dupeId).expect(409);
    const dupePhone = { ...user, aucId: '900999999', password: 'another pass' };
    await api.post('/api/auth/register').send(dupePhone).expect(409);
  });

  it('validates input with field-level errors', async () => {
    const { api } = setup();
    const res = await api
      .post('/api/auth/register')
      .send({ aucId: '12', firstName: '', lastName: 'X', phoneNumber: 'abc', password: 'short' })
      .expect(400);
    expect(Object.keys(res.body.details)).toEqual(
      expect.arrayContaining(['aucId', 'firstName', 'phoneNumber', 'password']),
    );
  });

  it('logs in with the right password only, with one message for both failures', async () => {
    const { api, register } = setup();
    const user = await register();
    const ok = await api
      .post('/api/auth/login')
      .send({ aucId: user.aucId, password: user.password })
      .expect(200);
    expect(ok.body.token).toBeTruthy();

    const wrong = await api
      .post('/api/auth/login')
      .send({ aucId: user.aucId, password: 'wrong password' })
      .expect(401);
    const unknown = await api
      .post('/api/auth/login')
      .send({ aucId: '911111111', password: 'whatever' })
      .expect(401);
    expect(wrong.body.error).toBe(unknown.body.error);
  });

  it('requires a valid token on protected routes', async () => {
    const { api } = setup();
    await api.get('/api/users/me').expect(401);
    await api.get('/api/users/me').set('Authorization', 'Bearer not-a-token').expect(401);
  });

  it('blocks banned users even with a valid token', async () => {
    const { register, repo, as } = setup();
    const user = await register();
    repo._users.get(user.aucId).isBanned = true;
    await as(user).get('/api/users/me').expect(403);
  });

  it('rejects malformed JSON with 400', async () => {
    const { api } = setup();
    await api
      .post('/api/auth/login')
      .set('Content-Type', 'application/json')
      .send('{"aucId":')
      .expect(400);
  });
});

describe('phone verification', () => {
  const codeFrom = (sent) => sent.at(-1).message.match(/\d{6}/)[0];

  it('sends a code by SMS without exposing it in the response', async () => {
    const { api, register, sent } = setup();
    const user = await register();
    const res = await api
      .post('/api/auth/send-sms-code')
      .send({ phone: user.phoneNumber })
      .expect(202);
    expect(JSON.stringify(res.body)).not.toMatch(/\d{6}/);
    expect(sent).toHaveLength(1);

    await api
      .post('/api/auth/verify-sms-code')
      .send({ phone: user.phoneNumber, code: codeFrom(sent) })
      .expect(200);
    const me = await api.get('/api/users/me').set('Authorization', `Bearer ${user.token}`);
    expect(me.body.user.phoneVerified).toBe(true);
  });

  it('does not reveal whether a number is registered', async () => {
    const { api, sent } = setup();
    await api.post('/api/auth/send-sms-code').send({ phone: '+201234567890' }).expect(202);
    expect(sent).toHaveLength(0);
  });

  it('locks a code after 5 wrong attempts', async () => {
    const { api, register, sent } = setup();
    const user = await register();
    await api.post('/api/auth/send-sms-code').send({ phone: user.phoneNumber });
    const right = codeFrom(sent);
    const wrong = right === '111111' ? '222222' : '111111';
    for (let i = 0; i < 5; i++) {
      await api
        .post('/api/auth/verify-sms-code')
        .send({ phone: user.phoneNumber, code: wrong })
        .expect(400);
    }
    const res = await api
      .post('/api/auth/verify-sms-code')
      .send({ phone: user.phoneNumber, code: right })
      .expect(400);
    expect(res.body.error).toMatch(/Too many attempts/);
  });

  it('expires codes after 5 minutes', async () => {
    let now = 1_000_000;
    const { api, register, sent } = setup({ clock: () => now });
    const user = await register();
    await api.post('/api/auth/send-sms-code').send({ phone: user.phoneNumber });
    now += 5 * 60 * 1000 + 1;
    const res = await api
      .post('/api/auth/verify-sms-code')
      .send({ phone: user.phoneNumber, code: codeFrom(sent) })
      .expect(400);
    expect(res.body.error).toMatch(/expired/);
  });
});
