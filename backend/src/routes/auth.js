const express = require('express');
const rateLimit = require('express-rate-limit');
const { schemas, parse } = require('../validation');
const { hashPassword, verifyPassword, signToken } = require('../auth');
const { conflict, unauthorized, forbidden, badRequest } = require('../errors');

const publicUser = ({ passwordHash: _omit, ...user }) => user;

function authRouter({ config, repo, verification }) {
  const router = express.Router();

  // Throttle credential and SMS endpoints to slow down brute force and SMS abuse.
  const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: config.isProduction ? 20 : 1000,
    standardHeaders: 'draft-8',
    legacyHeaders: false,
  });
  router.use(limiter);

  router.post('/register', async (req, res) => {
    const input = parse(schemas.register, req.body);
    if (await repo.findUserByPhone(input.phoneNumber)) {
      throw conflict('This phone number is already registered');
    }
    const user = await repo.createUser({
      aucId: input.aucId,
      firstName: input.firstName,
      lastName: input.lastName,
      phoneNumber: input.phoneNumber,
      isDriver: input.isDriver,
      passwordHash: await hashPassword(input.password),
    });
    if (!user) throw conflict('A user with this AUC ID already exists');
    res.status(201).json({ user: publicUser(user), token: signToken(user, config) });
  });

  router.post('/login', async (req, res) => {
    const { aucId, password } = parse(schemas.login, req.body);
    const user = await repo.findUser(aucId);
    // Same message for unknown user and wrong password, so the endpoint can't enumerate accounts.
    if (!user || !(await verifyPassword(password, user.passwordHash))) {
      throw unauthorized('Invalid AUC ID or password');
    }
    if (user.isBanned) throw forbidden('This account is banned');
    res.json({ user: publicUser(user), token: signToken(user, config) });
  });

  router.post('/send-sms-code', async (req, res) => {
    const { phone } = parse(schemas.sendCode, req.body);
    // Only send to registered numbers, but answer the same either way.
    if (await repo.findUserByPhone(phone)) await verification.start(phone);
    res.status(202).json({ message: 'If this number is registered, a code has been sent.' });
  });

  router.post('/verify-sms-code', async (req, res) => {
    const { phone, code } = parse(schemas.verifyCode, req.body);
    const result = verification.check(phone, code);
    const errors = {
      missing: 'No code was requested for this number',
      expired: 'The code has expired; request a new one',
      locked: 'Too many attempts; request a new code',
      invalid: 'Invalid code',
    };
    if (result !== 'ok') throw badRequest(errors[result]);
    await repo.setPhoneVerified(phone);
    res.json({ message: 'Phone verified' });
  });

  return router;
}

module.exports = { authRouter, publicUser };
