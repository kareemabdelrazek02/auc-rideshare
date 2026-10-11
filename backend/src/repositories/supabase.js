const { createClient } = require('@supabase/supabase-js');

// Postgres unique_violation
const UNIQUE_VIOLATION = '23505';

const toUser = (r) =>
  r && {
    aucId: r.auc_id,
    firstName: r.first_name,
    lastName: r.last_name,
    phoneNumber: r.phone_number,
    isDriver: r.is_driver,
    isBanned: r.is_banned,
    phoneVerified: r.phone_verified,
    passwordHash: r.password_hash,
    lastKnownAddress: r.last_known_address,
  };

const toRide = (r) =>
  r && {
    rideId: r.ride_id,
    riderId: r.rider_id,
    driverId: r.driver_id,
    status: r.status,
    requestedAt: r.requested_at,
    acceptedAt: r.accepted_at,
    completedAt: r.completed_at,
    canceledAt: r.canceled_at,
    canceledBy: r.canceled_by,
  };

const RIDE_COLUMNS = {
  driverId: 'driver_id',
  status: 'status',
  acceptedAt: 'accepted_at',
  completedAt: 'completed_at',
  canceledAt: 'canceled_at',
  canceledBy: 'canceled_by',
};

const toFriendRequest = (r) =>
  r && {
    id: r.id,
    senderId: r.sender_id,
    receiverId: r.receiver_id,
    status: r.status,
    sentAt: r.sent_at,
  };

function check(error) {
  if (error) throw new Error(`Database error: ${error.message}`);
}

/** Supabase (Postgres) implementation of the repository interface. Schema: supabase/migrations. */
function createSupabaseRepository({ supabaseUrl, supabaseServiceKey }) {
  if (!supabaseUrl || !supabaseServiceKey) {
    throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required for DATA_STORE=supabase');
  }
  const db = createClient(supabaseUrl, supabaseServiceKey, { auth: { persistSession: false } });

  return {
    // ---- users ----
    async findUser(aucId) {
      const { data, error } = await db.from('profiles').select('*').eq('auc_id', aucId).maybeSingle();
      check(error);
      return toUser(data);
    },
    async findUserByPhone(phoneNumber) {
      const { data, error } = await db
        .from('profiles')
        .select('*')
        .eq('phone_number', phoneNumber)
        .maybeSingle();
      check(error);
      return toUser(data);
    },
    async createUser(u) {
      const { data, error } = await db
        .from('profiles')
        .insert({
          auc_id: u.aucId,
          first_name: u.firstName,
          last_name: u.lastName,
          phone_number: u.phoneNumber,
          is_driver: u.isDriver,
          password_hash: u.passwordHash,
        })
        .select()
        .single();
      if (error?.code === UNIQUE_VIOLATION) return null;
      check(error);
      return toUser(data);
    },
    async setPhoneVerified(phoneNumber) {
      const { error } = await db
        .from('profiles')
        .update({ phone_verified: true })
        .eq('phone_number', phoneNumber);
      check(error);
    },
    async updateLastKnownAddress(aucId, address) {
      const { error } = await db
        .from('profiles')
        .update({ last_known_address: address })
        .eq('auc_id', aucId);
      check(error);
    },
    async getRating(aucId) {
      const { data, error } = await db.from('ratings').select('score').eq('ratee_id', aucId);
      check(error);
      const scores = data.map((r) => r.score);
      const average = scores.length ? scores.reduce((a, b) => a + b, 0) / scores.length : null;
      return { average, count: scores.length };
    },

    // ---- rides ----
    async createRide(riderId) {
      const { data, error } = await db
        .from('ride')
        .insert({ rider_id: riderId, status: 'requested' })
        .select()
        .single();
      check(error);
      return toRide(data);
    },
    async getRide(rideId) {
      const { data, error } = await db.from('ride').select('*').eq('ride_id', rideId).maybeSingle();
      check(error);
      return toRide(data);
    },
    async listRidesByStatus(status) {
      const { data, error } = await db
        .from('ride')
        .select('*')
        .eq('status', status)
        .order('requested_at', { ascending: true });
      check(error);
      return data.map(toRide);
    },
    async findActiveRideForUser(aucId) {
      const { data, error } = await db
        .from('ride')
        .select('*')
        .in('status', ['requested', 'accepted'])
        .or(`rider_id.eq.${aucId},driver_id.eq.${aucId}`)
        .limit(1);
      check(error);
      return toRide(data[0]) || null;
    },
    async transitionRide(rideId, fromStatuses, patch) {
      const row = Object.fromEntries(
        Object.entries(patch).map(([key, value]) => [RIDE_COLUMNS[key], value]),
      );
      // The status filter makes this a compare-and-set: two drivers cannot accept the same ride.
      const { data, error } = await db
        .from('ride')
        .update(row)
        .eq('ride_id', rideId)
        .in('status', fromStatuses)
        .select();
      check(error);
      return toRide(data[0]) || null;
    },

    // ---- ratings ----
    async addRating({ rideId, raterId, rateeId, score }) {
      const { data, error } = await db
        .from('ratings')
        .insert({ ride_id: rideId, rater_id: raterId, ratee_id: rateeId, score })
        .select()
        .single();
      if (error?.code === UNIQUE_VIOLATION) return null;
      check(error);
      return { rideId: data.ride_id, raterId, rateeId, score: data.score, createdAt: data.created_at };
    },

    // ---- friends ----
    async findFriendRequestBetween(a, b) {
      const { data, error } = await db
        .from('request')
        .select('*')
        .in('status', ['Pending', 'Accepted'])
        .or(
          `and(sender_id.eq.${a},receiver_id.eq.${b}),and(sender_id.eq.${b},receiver_id.eq.${a})`,
        )
        .limit(1);
      check(error);
      return toFriendRequest(data[0]) || null;
    },
    async createFriendRequest(senderId, receiverId) {
      const { data, error } = await db
        .from('request')
        .insert({ sender_id: senderId, receiver_id: receiverId, status: 'Pending' })
        .select()
        .single();
      check(error);
      return toFriendRequest(data);
    },
    async getFriendRequest(id) {
      const { data, error } = await db.from('request').select('*').eq('id', id).maybeSingle();
      check(error);
      return toFriendRequest(data);
    },
    async listPendingRequests(receiverId) {
      const { data, error } = await db
        .from('request')
        .select('*')
        .eq('receiver_id', receiverId)
        .eq('status', 'Pending');
      check(error);
      return data.map(toFriendRequest);
    },
    async updateFriendRequestStatus(id, fromStatus, toStatus) {
      const { data, error } = await db
        .from('request')
        .update({ status: toStatus })
        .eq('id', id)
        .eq('status', fromStatus)
        .select();
      check(error);
      return toFriendRequest(data[0]) || null;
    },
    async listFriends(aucId) {
      const { data, error } = await db
        .from('request')
        .select('sender_id, receiver_id')
        .eq('status', 'Accepted')
        .or(`sender_id.eq.${aucId},receiver_id.eq.${aucId}`);
      check(error);
      const ids = data.map((r) => (r.sender_id === aucId ? r.receiver_id : r.sender_id));
      if (!ids.length) return [];
      const { data: profiles, error: e2 } = await db
        .from('profiles')
        .select('auc_id, first_name, last_name')
        .in('auc_id', ids);
      check(e2);
      return profiles.map((p) => ({ aucId: p.auc_id, firstName: p.first_name, lastName: p.last_name }));
    },

    // ---- locations ----
    async upsertLocation(aucId, lat, lng) {
      const { error } = await db
        .from('locations')
        .upsert({ user_id: aucId, lat, lng, updated_at: new Date().toISOString() });
      check(error);
    },
  };
}

module.exports = { createSupabaseRepository };
