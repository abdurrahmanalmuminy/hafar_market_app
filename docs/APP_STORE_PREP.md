# App Store Preparation Checklist

## Android (Google Play)
- App bundle (AAB) built (release)
- Unique applicationId set: `com.newuniverse.hafarmarket`
- Release signing configured (android/key.properties)
- ProGuard/R8 enabled; Crashlytics/Performance working in release
- Screenshots (7-inch, 10-inch tablets, phone)
- App icon and feature graphics
- Short and full descriptions (AR/EN)
- Content rating questionnaire
- Privacy policy URL
- Firebase Analytics and Crashlytics verified

## iOS (App Store)
- Archive build succeeds (release, no codesign in CI)
- Bundle identifier: `com.newuniverse.hafarmarket`
- Push notifications entitlement set to production
- App icon, launch screens
- Screenshots for all required sizes
- App metadata (title, subtitle, keywords) (AR/EN)
- App Privacy details (data types, usage)
- TestFlight beta group created

## Dynamic Links
- Dynamic links domain: `hafarmarket.page.link`
- Offer share links open app to offer page

## Payments
- Moyasar publishable key set via `.env`
- Apple Pay merchant (iOS) configured and verified

## Policies
- Terms of Service and Privacy Policy hosted and linked

## Store Listings Assets (suggested paths)
- `store_assets/android/` and `store_assets/ios/` for screenshots and graphics

## Release Process
1. Bump version in `pubspec.yaml`
2. Build Android AAB, iOS archive
3. Upload to Play Console and App Store Connect
4. Roll out staged release (Android) / Submit for review (iOS)

