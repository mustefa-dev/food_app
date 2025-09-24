# Orange Eats (Offline-First, EN/AR, Mock/Real API)

Run (real API default; replace URL):
```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```
Mock mode (loads from assets/mock):
```bash
flutter run --dart-define=USE_MOCK_API=true
```

- Offline-first with Hive caching.
- Bilingual EN/AR (RTL) with profile toggle.
- Auth screens always available; returning users can log in offline.
- QR → Favorites drawer (set default, remove) + auto-open last.
- Restaurant → Cart → Checkout.
- Orders with offline PENDING_SYNC and auto-sync.
- Shimmer loaders + connectivity banners.
