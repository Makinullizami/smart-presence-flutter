# Smart Presence Mobile App Deployment Guide

## Prerequisites

- Flutter SDK (3.x)
- Android Studio (for Android builds)
- Xcode (for iOS builds, macOS only)
- Java JDK 17+
- Git

## Quick Build Commands

### Android APK/AAB
```bash
# Build APK
flutter build apk --release

# Build AAB (Google Play)
flutter build appbundle --release

# Build with specific platforms
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
```

### iOS (macOS only)
```bash
# Build for iOS
flutter build ios --release

# Build IPA for TestFlight/App Store
flutter build ipa --release
```

### Using Build Script
```bash
# Make executable
chmod +x build_release.sh

# Build Android
./build_release.sh android production

# Build iOS
./build_release.sh ios production

# Build both platforms
./build_release.sh both production
```

## Android Deployment

### 1. Configure Signing
Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../keys/upload-keystore.jks
```

### 2. Generate Keystore
```bash
# Generate upload keystore
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 3. Update build.gradle
```gradle
android {
    signingConfigs {
        release {
            storeFile file('upload-keystore.jks')
            storePassword System.getenv('STORE_PASSWORD')
            keyAlias System.getenv('KEY_ALIAS')
            keyPassword System.getenv('KEY_PASSWORD')
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 4. Google Play Console Setup
1. Create app in Google Play Console
2. Upload AAB file
3. Configure store listing
4. Set up internal/external testing
5. Publish to production

## iOS Deployment

### 1. Configure Xcode
1. Open `ios/Runner.xcworkspace`
2. Select team in Signing & Capabilities
3. Configure bundle identifier
4. Set version and build number

### 2. Create App Store Connect App
1. Go to App Store Connect
2. Create new app
3. Configure bundle ID, name, etc.

### 3. Build and Upload
```bash
# Build IPA
flutter build ipa --release

# Upload to App Store (using Transporter or Xcode)
xcrun altool --upload-app --type ios --file build/ios/ipa/smart_presence.ipa --username your-apple-id --password your-app-password
```

### 4. TestFlight Distribution
1. Upload build to TestFlight
2. Configure testers
3. Submit for review

## Firebase Configuration

### 1. Push Notifications Setup
1. Create Firebase project
2. Add Android/iOS apps
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place files in respective directories

### 2. Update pubspec.yaml
```yaml
dependencies:
  firebase_core: ^2.0.0
  firebase_messaging: ^14.0.0
  flutter_local_notifications: ^15.0.0
```

### 3. Configure FCM
```dart
// Initialize Firebase
await Firebase.initializeApp();

// Request permissions
final messaging = FirebaseMessaging.instance;
await messaging.requestPermission();

// Get token
final token = await messaging.getToken();
```

## Environment Configuration

### 1. Create Environment Files
```dart
// lib/config/env.dart
class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.smartpresence.com',
  );

  static const String firebaseServerKey = String.fromEnvironment(
    'FIREBASE_SERVER_KEY',
    defaultValue: 'your-firebase-key',
  );

  static const bool isProduction = bool.fromEnvironment(
    'PRODUCTION',
    defaultValue: false,
  );
}
```

### 2. Build with Environment Variables
```bash
# Android
flutter build apk --release --dart-define=API_BASE_URL=https://api.smartpresence.com --dart-define=PRODUCTION=true

# iOS
flutter build ios --release --dart-define=API_BASE_URL=https://api.smartpresence.com --dart-define=PRODUCTION=true
```

## App Store Optimization

### 1. Screenshots and Assets
- Main screenshot (1280x720)
- Feature screenshots (1080x1920)
- App icon (1024x1024)
- Feature graphics

### 2. Store Listing
- App name and description
- Keywords for search
- Category and age rating
- Privacy policy URL
- Support URL

### 3. App Review Guidelines
- Test all features thoroughly
- Ensure no crashes
- Verify network connectivity
- Test offline functionality
- Validate face recognition
- Check push notifications

## CI/CD Setup (Optional)

### GitHub Actions Example
```yaml
name: Build and Release
on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

## Testing Before Release

### 1. Functional Testing
- [ ] Login/logout functionality
- [ ] Face recognition enrollment
- [ ] Attendance check-in/check-out
- [ ] Leave request submission
- [ ] Notification reception
- [ ] Offline mode
- [ ] Profile management

### 2. Performance Testing
- [ ] App startup time
- [ ] Face detection speed
- [ ] API response times
- [ ] Memory usage
- [ ] Battery consumption

### 3. Compatibility Testing
- [ ] Android API 21+ (Android 5.0+)
- [ ] iOS 11.0+
- [ ] Various screen sizes
- [ ] Different network conditions

## Post-Release Monitoring

### 1. Crash Reporting
```yaml
dependencies:
  firebase_crashlytics: ^3.0.0
```

### 2. Analytics
```yaml
dependencies:
  firebase_analytics: ^10.0.0
```

### 3. User Feedback
- In-app feedback form
- App store reviews monitoring
- Support ticket system

## Troubleshooting

### Common Build Issues

1. **Android Build Fails**
```bash
# Clean and rebuild
flutter clean
flutter pub cache repair
cd android && ./gradlew clean && cd ..
flutter build apk --release
```

2. **iOS Build Fails**
```bash
# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
```

3. **Firebase Issues**
- Ensure `google-services.json` is in `android/app/`
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Check package names match Firebase configuration

4. **Permission Issues**
- Camera permissions for face recognition
- Location permissions for geofencing
- Notification permissions for push notifications

## Security Checklist

- [ ] Code obfuscation enabled
- [ ] API keys secured
- [ ] Certificate pinning implemented
- [ ] Data encryption for sensitive data
- [ ] Secure local storage
- [ ] Input validation
- [ ] SQL injection prevention

## Support and Maintenance

### Version Management
- Semantic versioning (MAJOR.MINOR.PATCH)
- Changelog maintenance
- Backward compatibility checks

### Update Strategy
- Forced updates for critical security fixes
- Optional updates for feature enhancements
- Staged rollout for major changes

### Monitoring
- App performance metrics
- User engagement analytics
- Crash reports and error tracking
- Server monitoring and alerts