const express = require('express');
const { schemas, parse } = require('../validation');
const { notFound } = require('../errors');
const { publicUser } = require('./auth');

function usersRouter({ repo, auth, geocode }) {
  const router = express.Router();
  router.use(auth);

  router.get('/me', async (req, res) => {
    const rating = await repo.getRating(req.user.aucId);
    res.json({ user: publicUser(req.user), rating });
  });

  router.get('/:userId/rating', async (req, res) => {
    const { userId } = parse(schemas.userParams, req.params);
    if (!(await repo.findUser(userId))) throw notFound('User not found');
    res.json({ rating: await repo.getRating(userId) });
  });

  // The user is taken from the token, so you can only update your own location.
  router.post('/me/location', async (req, res) => {
    const { lat, lng } = parse(schemas.location, req.body);
    await repo.upsertLocation(req.user.aucId, lat, lng);
    const address = await geocode(lat, lng);
    if (address) await repo.updateLastKnownAddress(req.user.aucId, address);
    res.json({ message: 'Location updated', address });
  });

  return router;
}

module.exports = { usersRouter };
