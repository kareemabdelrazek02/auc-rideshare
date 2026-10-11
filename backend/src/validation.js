const { z } = require('zod');
const { badRequest } = require('./errors');

const aucId = z.string().trim().regex(/^\d{9}$/, 'AUC ID must be 9 digits');
const phone = z
  .string()
  .trim()
  .regex(/^\+?\d{10,15}$/, 'Phone number must be 10-15 digits, optionally starting with +');
const id = z.coerce.number().int().positive();

const schemas = {
  register: z.object({
    aucId,
    firstName: z.string().trim().min(1).max(50),
    lastName: z.string().trim().min(1).max(50),
    phoneNumber: phone,
    password: z.string().min(8, 'Password must be at least 8 characters').max(128),
    isDriver: z.boolean().default(false),
  }),
  login: z.object({ aucId, password: z.string().min(1).max(128) }),
  sendCode: z.object({ phone }),
  verifyCode: z.object({ phone, code: z.string().regex(/^\d{6}$/) }),
  rideParams: z.object({ rideId: id }),
  rate: z.object({ score: z.number().int().min(1).max(5) }),
  friendRequest: z.object({ receiverId: aucId }),
  requestParams: z.object({ requestId: id }),
  userParams: z.object({ userId: aucId }),
  location: z.object({
    lat: z.number().min(-90).max(90),
    lng: z.number().min(-180).max(180),
  }),
};

/** Parse `data` with `schema`, turning failures into a 400 with field errors. */
function parse(schema, data) {
  const result = schema.safeParse(data ?? {});
  if (!result.success) {
    throw badRequest('Invalid input', z.flattenError(result.error).fieldErrors);
  }
  return result.data;
}

module.exports = { schemas, parse };
