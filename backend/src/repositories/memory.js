/**
 * In-memory implementation of the repository interface.
 * Used by the test suite and for running the API locally without Supabase.
 * Every method mirrors one in ./supabase.js.
 */
function createMemoryRepository() {
  const users = new Map();
  const rides = new Map();
  const ratings = [];
  const friendRequests = new Map();
  const locations = new Map();
  let nextRideId = 1;
  let nextRequestId = 1;

  const clone = (obj) => (obj ? structuredClone(obj) : null);
  const now = () => new Date().toISOString();

  return {
    // ---- users ----
    async findUser(aucId) {
      return clone(users.get(aucId));
    },
    async findUserByPhone(phoneNumber) {
      return clone([...users.values()].find((u) => u.phoneNumber === phoneNumber));
    },
    async createUser(user) {
      if (users.has(user.aucId)) return null;
      const row = { ...user, isBanned: false, phoneVerified: false, lastKnownAddress: null };
      users.set(user.aucId, row);
      return clone(row);
    },
    async setPhoneVerified(phoneNumber) {
      for (const u of users.values()) if (u.phoneNumber === phoneNumber) u.phoneVerified = true;
    },
    async updateLastKnownAddress(aucId, address) {
      const u = users.get(aucId);
      if (u) u.lastKnownAddress = address;
    },
    async getRating(aucId) {
      const scores = ratings.filter((r) => r.rateeId === aucId).map((r) => r.score);
      const average = scores.length ? scores.reduce((a, b) => a + b, 0) / scores.length : null;
      return { average, count: scores.length };
    },

    // ---- rides ----
    async createRide(riderId) {
      const ride = {
        rideId: nextRideId++,
        riderId,
        driverId: null,
        status: 'requested',
        requestedAt: now(),
        acceptedAt: null,
        completedAt: null,
        canceledAt: null,
        canceledBy: null,
      };
      rides.set(ride.rideId, ride);
      return clone(ride);
    },
    async getRide(rideId) {
      return clone(rides.get(rideId));
    },
    async listRidesByStatus(status) {
      return [...rides.values()].filter((r) => r.status === status).map(clone);
    },
    async findActiveRideForUser(aucId) {
      return clone(
        [...rides.values()].find(
          (r) =>
            ['requested', 'accepted'].includes(r.status) &&
            (r.riderId === aucId || r.driverId === aucId),
        ),
      );
    },
    /** Atomically apply `patch` only if the ride is currently in one of `fromStatuses`. */
    async transitionRide(rideId, fromStatuses, patch) {
      const ride = rides.get(rideId);
      if (!ride || !fromStatuses.includes(ride.status)) return null;
      Object.assign(ride, patch);
      return clone(ride);
    },

    // ---- ratings ----
    async addRating({ rideId, raterId, rateeId, score }) {
      if (ratings.some((r) => r.rideId === rideId && r.raterId === raterId)) return null;
      const rating = { rideId, raterId, rateeId, score, createdAt: now() };
      ratings.push(rating);
      return clone(rating);
    },

    // ---- friends ----
    async findFriendRequestBetween(a, b) {
      return clone(
        [...friendRequests.values()].find(
          (r) =>
            ['Pending', 'Accepted'].includes(r.status) &&
            ((r.senderId === a && r.receiverId === b) || (r.senderId === b && r.receiverId === a)),
        ),
      );
    },
    async createFriendRequest(senderId, receiverId) {
      const req = { id: nextRequestId++, senderId, receiverId, status: 'Pending', sentAt: now() };
      friendRequests.set(req.id, req);
      return clone(req);
    },
    async getFriendRequest(id) {
      return clone(friendRequests.get(id));
    },
    async listPendingRequests(receiverId) {
      return [...friendRequests.values()]
        .filter((r) => r.receiverId === receiverId && r.status === 'Pending')
        .map(clone);
    },
    async updateFriendRequestStatus(id, fromStatus, toStatus) {
      const req = friendRequests.get(id);
      if (!req || req.status !== fromStatus) return null;
      req.status = toStatus;
      return clone(req);
    },
    async listFriends(aucId) {
      return [...friendRequests.values()]
        .filter((r) => r.status === 'Accepted' && (r.senderId === aucId || r.receiverId === aucId))
        .map((r) => (r.senderId === aucId ? r.receiverId : r.senderId))
        .map((id) => users.get(id))
        .filter(Boolean)
        .map(({ aucId: id, firstName, lastName }) => ({ aucId: id, firstName, lastName }));
    },

    // ---- locations ----
    async upsertLocation(aucId, lat, lng) {
      locations.set(aucId, { aucId, lat, lng, updatedAt: now() });
    },

    // test helper
    _users: users,
  };
}

module.exports = { createMemoryRepository };
