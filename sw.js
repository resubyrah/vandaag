/**
 * Vandaag — service worker
 * CACHE-naam bevat de versie: bij elke release de VERSION in index.html
 * én deze cache-naam verhogen (bijv. vandaag-v0.1.0 → vandaag-v0.2.0),
 * zodat oude caches automatisch gewist worden.
 */
const CACHE = "vandaag-v0.3.1";
const ASSETS = [
  "index.html",
  "manifest.json",
  "sw.js",
  "./"
];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", e => {
  const url = new URL(e.request.url);

  // Apps Script / Google API nooit cachen: altijd door naar het netwerk
  if (url.hostname.endsWith("script.google.com") || url.hostname.endsWith("googleapis.com")) {
    e.respondWith(fetch(e.request));
    return;
  }

  // App-shell: cache-first, op de achtergrond verversen (stale-while-revalidate)
  e.respondWith(
    caches.match(e.request).then(cached => {
      const fresh = fetch(e.request).then(res => {
        if (res && res.ok) {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return res;
      }).catch(() => cached);
      return cached || fresh;
    })
  );
});