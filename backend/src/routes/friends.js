const express = require('express');
const { schemas, parse } = require('../validation');
const { badRequest, conflict, forbidden, notFound } = require('../errors');

function friendsRouter({ repo, auth }) {
  const router = express.Router();
  router.use(auth);

  router.get('/', async (req, res) => {
    res.json({ friends: await repo.listFriends(req.user.aucId) });
  });

  router.post('/requests', async (req, res) => {
    const { receiverId } = parse(schemas.friendRequest, req.body);
    const senderId = req.user.aucId;
    if (receiverId === senderId) throw badRequest('You cannot add yourself');
    if (!(await repo.findUser(receiverId))) throw notFound('User not found');
    const existing = await repo.findFriendRequestBetween(senderId, receiverId);
    if (existing) {
      throw conflict(existing.status === 'Accepted' ? 'Already friends' : 'Request already pending');
    }
    const request = await repo.createFriendRequest(senderId, receiverId);
    res.status(201).json({ request });
  });

  // An empty list is a normal result, so this returns 200 [] instead of the old 404.
  router.get('/requests', async (req, res) => {
    res.json({ requests: await repo.listPendingRequests(req.user.aucId) });
  });

  const respond = (toStatus) => async (req, res) => {
    const { requestId } = parse(schemas.requestParams, req.params);
    const request = await repo.getFriendRequest(requestId);
    if (!request) throw notFound('Friend request not found');
    if (request.receiverId !== req.user.aucId) throw forbidden();
    const updated = await repo.updateFriendRequestStatus(requestId, 'Pending', toStatus);
    if (!updated) throw conflict('This request was already answered');
    res.json({ request: updated });
  };
  router.post('/requests/:requestId/accept', respond('Accepted'));
  router.post('/requests/:requestId/decline', respond('Declined'));

  return router;
}

module.exports = { friendsRouter };
