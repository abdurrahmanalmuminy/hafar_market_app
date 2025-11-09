# Hafar Market App

Marketplace app for Hafar Al-Batin with Firebase backend, Algolia search, Moyasar payments, Dynamic Links, and Push Notifications.

## Features
- Firebase Auth, Firestore, Storage, Crashlytics, Performance
- Push Notifications (FCM)
- Algolia search
- Moyasar payments
- Dynamic links for sharing offers
- Arabic/English localization

## Prerequisites
- Flutter SDK (stable)
- Firebase project configured (Android/iOS)
- Algolia app ID and Search API key
- Moyasar publishable key (and Apple Pay merchant for iOS)

## Setup
1. Copy `env.example` to `.env` and fill values:
```
ALGOLIA_APP_ID=...
ALGOLIA_API_KEY=...
MOYASAR_PUBLISHABLE_KEY=...
MOYASAR_APPLE_MERCHANT_ID=...
DYNAMIC_LINK_DOMAIN=hafarmarket.page.link
APP_LINK_HOST=https://hafarmarket.app
```
2. Place `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`.
3. (Android) Optional signing: copy `android/key.properties.example` to `android/key.properties` and set keystore values.
4. Install:
```
flutter pub get
```

## Run
```
flutter run
```

## Build
- Android AAB:
```
flutter build appbundle --release
```
- iOS (no codesign):
```
flutter build ios --release --no-codesign
```

## Localization
- ARB files under `lib/l10/`.
- To generate localizations (optional):
```
flutter gen-l10n
```

## CI/CD
GitHub Actions workflows:
- `.github/workflows/test.yml` runs analyze and tests
- `.github/workflows/build_android.yml` builds AAB
- `.github/workflows/build_ios.yml` builds iOS archive (no codesign)

## Security
- `.env` and signing keys are gitignored
- ProGuard enabled for Android release
- Storage rules should restrict uploads to authenticated users

## Project Structure
- `lib/controllers/` business logic
- `lib/ui/` widgets and screens
- `lib/services/` platform services (dynamic links, notifications, storage)
- `lib/models/` data models
- `test/` unit & widget tests

