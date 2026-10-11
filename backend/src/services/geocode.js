/**
 * Reverse geocoding via OpenStreetMap Nominatim.
 * Failures return null instead of breaking the location update.
 * Nominatim's usage policy requires an identifying User-Agent and at most 1 request/second.
 */
function createGeocoder(config, { fetchImpl = fetch, timeoutMs = 3000 } = {}) {
  if (!config.geocodeEnabled) return async () => null;

  return async (lat, lng) => {
    const url = new URL('https://nominatim.openstreetmap.org/reverse');
    url.search = new URLSearchParams({ format: 'json', lat: String(lat), lon: String(lng) });
    try {
      const res = await fetchImpl(url, {
        headers: { 'User-Agent': 'auc-rideshare/1.0 (student project)' },
        signal: AbortSignal.timeout(timeoutMs),
      });
      if (!res.ok) return null;
      const body = await res.json();
      return body.display_name || null;
    } catch {
      return null;
    }
  };
}

module.exports = { createGeocoder };
