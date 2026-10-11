const express = require('express');
const { schemas, parse } = require('../validation');
const { requireDriver, requireRider } = require('../auth');
const { conflict, forbidden, notFound } = require('../errors');

/**
 * Ride lifecycle:  requested ──accept──▶ accepted ──complete──▶ completed
 *                      └──────cancel──────────┴──▶ canceled
 * Every transition is a compare-and-set on the current status, so concurrent
 * requests (e.g. two drivers accepting the same ride) cannot both succeed.
 */
function ridesRouter({ repo, auth, realtime }) {
  const router = express.Router();
  router.use(auth);

  const loadRide = async (req) => {
    const { rideId } = parse(schemas.rideParams, req.params);
    const ride = await repo.getRide(rideId);
    if (!ride) throw notFound('Ride not found');
    return ride;
  };
  const isParticipant = (ride, user) => [ride.riderId, ride.driverId].includes(user.aucId);

  router.post('/', requireRider, async (req, res) => {
    if (await repo.findActiveRideForUser(req.user.aucId)) {
      throw conflict('You already have an active ride');
    }
    const ride = await repo.createRide(req.user.aucId);
    realtime?.notifyDrivers('ride-requested', ride);
    res.status(201).json({ ride });
  });

  router.get('/available', requireDriver, async (_req, res) => {
    res.json({ rides: await repo.listRidesByStatus('requested') });
  });

  router.get('/current', async (req, res) => {
    res.json({ ride: await repo.findActiveRideForUser(req.user.aucId) });
  });

  router.get('/:rideId', async (req, res) => {
    const ride = await loadRide(req);
    if (!isParticipant(ride, req.user)) throw forbidden();
    res.json({ ride });
  });

  router.post('/:rideId/accept', requireDriver, async (req, res) => {
    const ride = await loadRide(req);
    if (await repo.findActiveRideForUser(req.user.aucId)) {
      throw conflict('You already have an active ride');
    }
    const updated = await repo.transitionRide(ride.rideId, ['requested'], {
      driverId: req.user.aucId,
      status: 'accepted',
      acceptedAt: new Date().toISOString(),
    });
    if (!updated) throw conflict('This ride is no longer available');
    realtime?.toRide(updated.rideId, 'ride-updated', updated);
    res.json({ ride: updated });
  });

  router.post('/:rideId/cancel', async (req, res) => {
    const ride = await loadRide(req);
    if (!isParticipant(ride, req.user)) throw forbidden();
    const updated = await repo.transitionRide(ride.rideId, ['requested', 'accepted'], {
      status: 'canceled',
      canceledAt: new Date().toISOString(),
      canceledBy: req.user.aucId,
    });
    if (!updated) throw conflict(`Cannot cancel a ride that is ${ride.status}`);
    realtime?.toRide(updated.rideId, 'ride-updated', updated);
    res.json({ ride: updated });
  });

  router.post('/:rideId/complete', requireDriver, async (req, res) => {
    const ride = await loadRide(req);
    if (ride.driverId !== req.user.aucId) throw forbidden('Only the assigned driver can complete');
    const updated = await repo.transitionRide(ride.rideId, ['accepted'], {
      status: 'completed',
      completedAt: new Date().toISOString(),
    });
    if (!updated) throw conflict(`Cannot complete a ride that is ${ride.status}`);
    realtime?.toRide(updated.rideId, 'ride-updated', updated);
    res.json({ ride: updated });
  });

  // Replaces the old PUT /update-rating, which let anyone set anyone's rating directly.
  router.post('/:rideId/rating', async (req, res) => {
    const ride = await loadRide(req);
    const { score } = parse(schemas.rate, req.body);
    if (!isParticipant(ride, req.user)) throw forbidden();
    if (ride.status !== 'completed') throw conflict('You can only rate completed rides');
    const rateeId = req.user.aucId === ride.riderId ? ride.driverId : ride.riderId;
    const rating = await repo.addRating({
      rideId: ride.rideId,
      raterId: req.user.aucId,
      rateeId,
      score,
    });
    if (!rating) throw conflict('You already rated this ride');
    res.status(201).json({ rating });
  });

  return router;
}

module.exports = { ridesRouter };
