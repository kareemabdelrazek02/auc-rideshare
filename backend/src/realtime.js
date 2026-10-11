const { Server } = require('socket.io');
const { verifyToken } = require('./auth');
const { schemas } = require('./validation');

/**
 * Notifier used by the REST routes. Methods are no-ops until a Socket.IO server is attached,
 * so the HTTP app works (and is tested) without real-time support.
 */
function createRealtimeNotifier() {
  return { notifyDrivers() {}, toRide() {} };
}

const rideRoom = (rideId) => `ride:${rideId}`;

/**
 * Socket.IO server for live ride updates and driver location tracking.
 * Clients connect with `auth: { token }`; only ride participants can join a ride's room
 * and only the assigned driver can broadcast its location.
 */
function attachRealtime(httpServer, { config, repo, notifier }) {
  const io = new Server(httpServer, { cors: { origin: config.corsOrigins } });

  io.use(async (socket, next) => {
    try {
      const payload = verifyToken(socket.handshake.auth?.token, config);
      const user = await repo.findUser(payload.sub);
      if (!user || user.isBanned) return next(new Error('unauthorized'));
      socket.data.user = user;
      next();
    } catch {
      next(new Error('unauthorized'));
    }
  });

  io.on('connection', (socket) => {
    const { user } = socket.data;
    if (user.isDriver) socket.join('drivers');

    const loadOwnRide = async (rideId) => {
      const parsed = schemas.rideParams.safeParse({ rideId });
      if (!parsed.success) return null;
      const ride = await repo.getRide(parsed.data.rideId);
      return ride && [ride.riderId, ride.driverId].includes(user.aucId) ? ride : null;
    };

    socket.on('join-ride', async (rideId, ack = () => {}) => {
      const ride = await loadOwnRide(rideId);
      if (!ride) return ack({ ok: false, error: 'forbidden' });
      socket.join(rideRoom(ride.rideId));
      ack({ ok: true });
    });

    socket.on('driver-location', async (data = {}, ack = () => {}) => {
      const ride = await loadOwnRide(data.rideId);
      const location = schemas.location.safeParse({ lat: data.lat, lng: data.lng });
      if (!ride || ride.driverId !== user.aucId || ride.status !== 'accepted' || !location.success) {
        return ack({ ok: false, error: 'forbidden' });
      }
      socket.to(rideRoom(ride.rideId)).emit('location-update', {
        rideId: ride.rideId,
        ...location.data,
      });
      ack({ ok: true });
    });
  });

  notifier.notifyDrivers = (event, payload) => io.to('drivers').emit(event, payload);
  notifier.toRide = (rideId, event, payload) => io.to(rideRoom(rideId)).emit(event, payload);
  return io;
}

module.exports = { createRealtimeNotifier, attachRealtime };
