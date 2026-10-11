const { createSmsSender } = require('../src/services/sms');
const { createGeocoder } = require('../src/services/geocode');
const { loadConfig } = require('../src/config');

const fakeFetch = (body, ok = true) => {
  const calls = [];
  const fn = async (url, init) => {
    calls.push({ url: String(url), init });
    return { ok, json: async () => body };
  };
  fn.calls = calls;
  return fn;
};

describe('SMS sender', () => {
  it('sends through Textbelt with the server-side key', async () => {
    const fetchImpl = fakeFetch({ success: true });
    const send = createSmsSender({ smsProvider: 'textbelt', textbeltKey: 'k' }, { fetchImpl });
    await send('+201000000000', 'hello');
    expect(fetchImpl.calls[0].url).toBe('https://textbelt.com/text');
    expect(JSON.parse(fetchImpl.calls[0].init.body)).toEqual({
      phone: '+201000000000',
      message: 'hello',
      key: 'k',
    });
  });

  it('surfaces provider errors', async () => {
    const fetchImpl = fakeFetch({ success: false, error: 'Out of quota' });
    const send = createSmsSender({ smsProvider: 'textbelt', textbeltKey: 'k' }, { fetchImpl });
    await expect(send('+201000000000', 'hi')).rejects.toThrow('Out of quota');
  });

  it('refuses unsafe configurations', () => {
    expect(() => createSmsSender({ smsProvider: 'textbelt' })).toThrow('TEXTBELT_KEY');
    expect(() => createSmsSender({ smsProvider: 'console', isProduction: true })).toThrow();
    expect(() => createSmsSender({ smsProvider: 'pigeon' })).toThrow('Unknown');
  });

  it('logs to the console in development', async () => {
    const lines = [];
    const send = createSmsSender(
      { smsProvider: 'console', isProduction: false },
      { logger: { info: (l) => lines.push(l) } },
    );
    await send('+201000000000', 'code 123456');
    expect(lines[0]).toContain('code 123456');
  });
});

describe('geocoder', () => {
  it('returns the display name with an identifying User-Agent', async () => {
    const fetchImpl = fakeFetch({ display_name: 'New Cairo' });
    const geocode = createGeocoder({ geocodeEnabled: true }, { fetchImpl });
    expect(await geocode(30, 31)).toBe('New Cairo');
    expect(fetchImpl.calls[0].url).toContain('lat=30&lon=31');
    expect(fetchImpl.calls[0].init.headers['User-Agent']).toMatch(/auc-rideshare/);
  });

  it('returns null instead of failing the request', async () => {
    const failing = async () => {
      throw new Error('network down');
    };
    expect(await createGeocoder({ geocodeEnabled: true }, { fetchImpl: failing })(1, 2)).toBeNull();
    expect(await createGeocoder({ geocodeEnabled: true }, { fetchImpl: fakeFetch({}, false) })(1, 2)).toBeNull();
    expect(await createGeocoder({ geocodeEnabled: false })(1, 2)).toBeNull();
  });
});

describe('config', () => {
  it('defaults to the in-memory store and switches to Supabase when configured', () => {
    expect(loadConfig({}).dataStore).toBe('memory');
    expect(loadConfig({ SUPABASE_URL: 'https://x.supabase.co' }).dataStore).toBe('supabase');
    expect(loadConfig({ CORS_ORIGINS: 'a, b' }).corsOrigins).toEqual(['a', 'b']);
  });
});
