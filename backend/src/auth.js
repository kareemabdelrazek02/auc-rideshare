const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { unauthorized, forbidden } = require('./errors');

// 12 rounds in real use; the test suite uses the minimum so it stays fast.
const BCRYPT_ROUNDS = process.env.NODE_ENV === 'test' ? 4 : 12;

const hashPassword = (password) => bcrypt.hash(password, BCRYPT_ROUNDS);
const verifyPassword = (password, hash) => bcrypt.compare(password, hash);

function signToken(user, config) {
  return jwt.sign({ sub: user.aucId, isDriver: user.isDriver }, config.jwtSecret, {
    expiresIn: config.jwtExpiresIn,
  });
}

function verifyToken(token, config) {
  return jwt.verify(token, config.jwtSecret);
}

/**
 * Express middleware: requires a valid `Authorization: Bearer <token>` header,
 * then loads the user so banned or deleted accounts are rejected immediately.
 */
function requireAuth({ config, repo }) {
  return async (req, _res, next) => {
    const header = req.get('authorization') || '';
    const [scheme, token] = header.split(' ');
    if (scheme !== 'Bearer' || !token) throw unauthorized();

    let payload;
    try {
      payload = verifyToken(token, config);
    } catch {
      throw unauthorized('Invalid or expired token');
    }

    const user = await repo.findUser(payload.sub);
    if (!user) throw unauthorized('Account no longer exists');
    if (user.isBanned) throw forbidden('This account is banned');
    req.user = user;
    next();
  };
}

function requireDriver(req, _res, next) {
  if (!req.user.isDriver) throw forbidden('Only drivers can do this');
  next();
}

function requireRider(req, _res, next) {
  if (req.user.isDriver) throw forbidden('Only riders can do this');
  next();
}

module.exports = {
  hashPassword,
  verifyPassword,
  signToken,
  verifyToken,
  requireAuth,
  requireDriver,
  requireRider,
};
