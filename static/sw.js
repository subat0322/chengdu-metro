// Service Worker — 离线缓存支持 (PWA)
const CACHE_NAME = 'chengdu-metro-v2';

const PRECACHE_URLS = [
    '/',
    '/static/manifest.json',
];

// 安装：预缓存核心资源
self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME).then(cache => {
            return cache.addAll(PRECACHE_URLS);
        })
    );
    self.skipWaiting();
});

// 激活：清理旧缓存
self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(keys => {
            return Promise.all(
                keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
            );
        })
    );
    self.clients.claim();
});

// 请求：缓存优先策略（API请求走网络）
self.addEventListener('fetch', event => {
    const url = new URL(event.request.url);
    // API请求走网络
    if (url.pathname.startsWith('/api/')) {
        return;
    }
    // 静态资源：缓存优先
    event.respondWith(
        caches.match(event.request).then(cached => {
            const fetchPromise = fetch(event.request).then(response => {
                if (response && response.status === 200) {
                    const clone = response.clone();
                    caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone));
                }
                return response;
            }).catch(() => cached);
            return cached || fetchPromise;
        })
    );
});
