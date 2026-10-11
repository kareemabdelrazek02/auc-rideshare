const { setup } = require('./helpers');

describe('friends', () => {
  it('sends, lists and accepts a friend request', async () => {
    const { register, as } = setup();
    const a = await register();
    const b = await register();

    const sent = await as(a).post('/api/friends/requests').send({ receiverId: b.aucId }).expect(201);
    const inbox = await as(b).get('/api/friends/requests').expect(200);
    expect(inbox.body.requests).toHaveLength(1);

    const id = sent.body.request.id;
    await as(a).post(`/api/friends/requests/${id}/accept`).expect(403); // sender can't accept
    await as(b).post(`/api/friends/requests/${id}/accept`).expect(200);
    await as(b).post(`/api/friends/requests/${id}/decline`).expect(409); // already answered

    const friends = await as(a).get('/api/friends').expect(200);
    expect(friends.body.friends).toEqual([
      { aucId: b.aucId, firstName: b.firstName, lastName: b.lastName },
    ]);
  });

  it('rejects self-requests, unknown users and duplicates', async () => {
    const { register, as } = setup();
    const a = await register();
    const b = await register();
    await as(a).post('/api/friends/requests').send({ receiverId: a.aucId }).expect(400);
    await as(a).post('/api/friends/requests').send({ receiverId: '911111111' }).expect(404);
    await as(a).post('/api/friends/requests').send({ receiverId: b.aucId }).expect(201);
    await as(b).post('/api/friends/requests').send({ receiverId: a.aucId }).expect(409);
  });

  it('returns an empty list, not 404, when there are no requests', async () => {
    const { register, as } = setup();
    const a = await register();
    const res = await as(a).get('/api/friends/requests').expect(200);
    expect(res.body.requests).toEqual([]);
  });
});

describe('users', () => {
  it('returns my profile without the password hash', async () => {
    const { register, as } = setup();
    const a = await register();
    const res = await as(a).get('/api/users/me').expect(200);
    expect(res.body.user.aucId).toBe(a.aucId);
    expect(res.body.user.passwordHash).toBeUndefined();
    expect(res.body.rating).toEqual({ average: null, count: 0 });
  });

  it('updates my own location and stores the geocoded address', async () => {
    const { register, as, repo } = setup();
    const a = await register();
    const res = await as(a)
      .post('/api/users/me/location')
      .send({ lat: 30.0195, lng: 31.4998 })
      .expect(200);
    expect(res.body.address).toBe('AUC New Cairo, Egypt');
    expect((await repo.findUser(a.aucId)).lastKnownAddress).toBe('AUC New Cairo, Egypt');
  });

  it('rejects out-of-range coordinates', async () => {
    const { register, as } = setup();
    const a = await register();
    await as(a).post('/api/users/me/location').send({ lat: 200, lng: 0 }).expect(400);
  });
});

describe('app', () => {
  it('has a health check and JSON 404s', async () => {
    const { api } = setup();
    await api.get('/health').expect(200, { status: 'ok' });
    const res = await api.get('/nope').expect(404);
    expect(res.body.error).toBe('Route not found');
  });

  it('only allows CORS from configured origins', async () => {
    const { api } = setup();
    const ok = await api.get('/health').set('Origin', 'http://localhost:3000');
    expect(ok.headers['access-control-allow-origin']).toBe('http://localhost:3000');
    const bad = await api.get('/health').set('Origin', 'https://evil.example');
    expect(bad.headers['access-control-allow-origin']).toBeUndefined();
  });
});
