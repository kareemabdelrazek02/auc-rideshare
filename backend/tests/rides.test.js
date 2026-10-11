const { setup } = require('./helpers');

async function world() {
  const ctx = setup();
  const rider = await ctx.register();
  const driver = await ctx.register({ isDriver: true });
  const driver2 = await ctx.register({ isDriver: true });
  const stranger = await ctx.register();
  return { ...ctx, rider, driver, driver2, stranger };
}

async function acceptedRide(w) {
  const { body } = await w.as(w.rider).post('/api/rides').expect(201);
  await w.as(w.driver).post(`/api/rides/${body.ride.rideId}/accept`).expect(200);
  return body.ride.rideId;
}

describe('ride lifecycle', () => {
  it('runs request → accept → complete', async () => {
    const w = await world();
    const { body } = await w.as(w.rider).post('/api/rides').expect(201);
    expect(body.ride).toMatchObject({ riderId: w.rider.aucId, status: 'requested' });

    const available = await w.as(w.driver).get('/api/rides/available').expect(200);
    expect(available.body.rides.map((r) => r.rideId)).toContain(body.ride.rideId);

    const id = body.ride.rideId;
    const accepted = await w.as(w.driver).post(`/api/rides/${id}/accept`).expect(200);
    expect(accepted.body.ride).toMatchObject({ status: 'accepted', driverId: w.driver.aucId });

    const done = await w.as(w.driver).post(`/api/rides/${id}/complete`).expect(200);
    expect(done.body.ride.status).toBe('completed');
    expect(done.body.ride.completedAt).toBeTruthy();
  });

  it('only riders can request and only drivers can see or accept rides', async () => {
    const w = await world();
    await w.as(w.driver).post('/api/rides').expect(403);
    await w.as(w.rider).get('/api/rides/available').expect(403);
    const { body } = await w.as(w.rider).post('/api/rides').expect(201);
    await w.as(w.stranger).post(`/api/rides/${body.ride.rideId}/accept`).expect(403);
  });

  it('prevents a rider from having two active rides', async () => {
    const w = await world();
    await w.as(w.rider).post('/api/rides').expect(201);
    await w.as(w.rider).post('/api/rides').expect(409);
  });

  it('lets only one driver accept a ride', async () => {
    const w = await world();
    const { body } = await w.as(w.rider).post('/api/rides').expect(201);
    const id = body.ride.rideId;
    const results = await Promise.all([
      w.as(w.driver).post(`/api/rides/${id}/accept`),
      w.as(w.driver2).post(`/api/rides/${id}/accept`),
    ]);
    expect(results.map((r) => r.status).sort()).toEqual([200, 409]);
  });

  it('only the assigned driver can complete, and only accepted rides', async () => {
    const w = await world();
    const { body } = await w.as(w.rider).post('/api/rides').expect(201);
    const id = body.ride.rideId;
    await w.as(w.driver).post(`/api/rides/${id}/complete`).expect(403);
    await w.as(w.driver).post(`/api/rides/${id}/accept`).expect(200);
    await w.as(w.driver2).post(`/api/rides/${id}/complete`).expect(403);
    await w.as(w.driver).post(`/api/rides/${id}/complete`).expect(200);
    await w.as(w.driver).post(`/api/rides/${id}/complete`).expect(409);
  });

  it('lets participants cancel, records who canceled, and blocks strangers', async () => {
    const w = await world();
    const id = await acceptedRide(w);
    await w.as(w.stranger).post(`/api/rides/${id}/cancel`).expect(403);
    const res = await w.as(w.rider).post(`/api/rides/${id}/cancel`).expect(200);
    expect(res.body.ride).toMatchObject({ status: 'canceled', canceledBy: w.rider.aucId });
    await w.as(w.driver).post(`/api/rides/${id}/cancel`).expect(409);
  });

  it('hides ride details from non-participants and returns 404 for unknown rides', async () => {
    const w = await world();
    const id = await acceptedRide(w);
    await w.as(w.rider).get(`/api/rides/${id}`).expect(200);
    await w.as(w.stranger).get(`/api/rides/${id}`).expect(403);
    await w.as(w.rider).get('/api/rides/9999').expect(404);
    await w.as(w.rider).get('/api/rides/abc').expect(400);
  });

  it('returns the current active ride', async () => {
    const w = await world();
    const id = await acceptedRide(w);
    const res = await w.as(w.driver).get('/api/rides/current').expect(200);
    expect(res.body.ride.rideId).toBe(id);
  });
});

describe('ratings', () => {
  it('lets each participant rate the other once after completion', async () => {
    const w = await world();
    const id = await acceptedRide(w);
    await w.as(w.rider).post(`/api/rides/${id}/rating`).send({ score: 5 }).expect(409); // not done yet
    await w.as(w.driver).post(`/api/rides/${id}/complete`).expect(200);

    await w.as(w.rider).post(`/api/rides/${id}/rating`).send({ score: 4 }).expect(201);
    await w.as(w.rider).post(`/api/rides/${id}/rating`).send({ score: 5 }).expect(409);
    await w.as(w.driver).post(`/api/rides/${id}/rating`).send({ score: 5 }).expect(201);
    await w.as(w.stranger).post(`/api/rides/${id}/rating`).send({ score: 1 }).expect(403);
    await w.as(w.rider).post(`/api/rides/${id}/rating`).send({ score: 9 }).expect(400);

    const res = await w.as(w.stranger).get(`/api/users/${w.driver.aucId}/rating`).expect(200);
    expect(res.body.rating).toEqual({ average: 4, count: 1 });
  });
});
