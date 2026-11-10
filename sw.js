/**
 * Vandaag — service worker
 * CACHE-naam bevat de versie: bij elke release de VERSION in index.html
 * én deze cache-naam verhogen (bijv. vandaag-v0.1.0 → vandaag-v0.2.0),
 * zodat oude caches automatisch gewist worden.
 */
const CACHE = "vandaag-v0.6.8";
const ASSETS = [
  "index.html",
  "manifest.json",
  "icon.svg",
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

  // ALLE cross-origin verkeer (Apps Script, Google API's) en alle POSTS:
  // NIET aanraken — Safari breekt op respondWith(fetch()) hiervan.
  // De browser doet die requests zelf, direct, zonder service worker.
  if(url.origin !== location.origin || e.request.method !== "GET") return;

  // App-shell (eigen GET's): cache-first, op de achtergrond verversen
  e.respondWith(
    caches.match(e.request).then(cached => {
      const fresh = fetch(e.request).then(res => {
        if(res && res.ok){
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return res;
      }).catch(() => cached);
      return cached || fresh;
    })
  );
});