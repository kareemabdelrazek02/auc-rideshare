const http = require('node:http');
const { io: connect } = require('socket.io-client');
const { createApp } = require('../src/app');
const { createMemoryRepository } = require('../src/repositories/memory');
const { createVerificationService } = require('../src/services/sms');
const { createRealtimeNotifier, attachRealtime } = require('../src/realtime');
const { signToken } = require('../src/auth');
const { config } = require('./helpers');

describe('realtime', () => {
  let server, io, url, repo, sockets;

  beforeEach(async () => {
    repo = createMemoryRepository();
    const realtime = createRealtimeNotifier();
    const app = createApp({
      config,
      repo,
      verification: createVerificationService({ send: async () => {} }),
      geocode: async () => null,
      realtime,
    });
    server = http.createServer(app);
    io = attachRealtime(server, { config, repo, notifier: realtime });
    await new Promise((resolve) => server.listen(0, resolve));
    url = `http://localhost:${server.address().port}`;
    sockets = [];
  });

  afterEach(async () => {
    sockets.forEach((s) => s.close());
    io.close();
    await new Promise((resolve) => server.close(resolve));
  });

  async function user(aucId, isDriver) {
    await repo.createUser({
      aucId,
      firstName: 'T',
      lastName: aucId,
      phoneNumber: `+20${aucId}0`,
      isDriver,
      passwordHash: 'x',
    });
    return { aucId, isDriver };
  }

  function client(u) {
    const token = u ? signToken(u, config) : 'bad';
    const socket = connect(url, { auth: { token }, transports: ['websocket'], forceNew: true });
    sockets.push(socket);
    return socket;
  }

  const emit = (socket, event, data) => new Promise((resolve) => socket.emit(event, data, resolve));
  const once = (socket, event) => new Promise((resolve) => socket.once(event, resolve));

  it('rejects connections without a valid token', async () => {
    const err = await once(client(null), 'connect_error');
    expect(err.message).toBe('unauthorized');
  });

  it('streams the assigned driver location to the rider and blocks everyone else', async () => {
    const rider = await user('900000001', false);
    const driver = await user('900000002', true);
    const stranger = await user('900000003', true);
    const ride = await repo.createRide(rider.aucId);
    await repo.transitionRide(ride.rideId, ['requested'], {
      driverId: driver.aucId,
      status: 'accepted',
    });

    const riderSocket = client(rider);
    const driverSocket = client(driver);
    const strangerSocket = client(stranger);
    await Promise.all([riderSocket, driverSocket, strangerSocket].map((s) => once(s, 'connect')));

    expect(await emit(riderSocket, 'join-ride', ride.rideId)).toEqual({ ok: true });
    expect(await emit(strangerSocket, 'join-ride', ride.rideId)).toMatchObject({ ok: false });
    expect(
      await emit(strangerSocket, 'driver-location', { rideId: ride.rideId, lat: 1, lng: 1 }),
    ).toMatchObject({ ok: false });

    const update = once(riderSocket, 'location-update');
    const ack = await emit(driverSocket, 'driver-location', {
      rideId: ride.rideId,
      lat: 30.02,
      lng: 31.5,
    });
    expect(ack).toEqual({ ok: true });
    expect(await update).toEqual({ rideId: ride.rideId, lat: 30.02, lng: 31.5 });
  });
});
