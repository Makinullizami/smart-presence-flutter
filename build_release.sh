#!/bin/bash

# Smart Presence Flutter App Build Script
# Usage: ./build_release.sh [platform] [environment]

set -e

PLATFORM=${1:-android}
ENVIRONMENT=${2:-production}
VERSION_NAME="1.0.0"
VERSION_CODE="1"

echo "🚀 Building Smart Presence Flutter App"
echo "Platform: $PLATFORM"
echo "Environment: $ENVIRONMENT"
echo "Version: $VERSION_NAME ($VERSION_CODE)"

# Function to check prerequisites
check_prerequisites() {
    echo "🔍 Checking prerequisites..."

    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        echo "❌ Flutter is not installed or not in PATH"
        exit 1
    fi

    # Check Flutter version
    FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
    echo "✅ Flutter version: $FLUTTER_VERSION"

    # Check platform specific tools
    case $PLATFORM in
        android)
            if ! command -v java &> /dev/null; then
                echo "❌ Java JDK is required for Android builds"
                exit 1
            fi
            echo "✅ Java version: $(java -version 2>&1 | head -n 1)"
            ;;
        ios)
            if ! command -v xcodebuild &> /dev/null; then
                echo "❌ Xcode is required for iOS builds (macOS only)"
                exit 1
            fi
            echo "✅ Xcode version: $(xcodebuild -version | head -n 1)"
            ;;
    esac

    echo "✅ Prerequisites check passed"
}

# Function to clean project
clean_project() {
    echo "🧹 Cleaning project..."

    flutter clean
    flutter pub get

    # Clean platform specific
    case $PLATFORM in
        android)
            cd android
            ./gradlew clean
            cd ..
            ;;
        ios)
            flutter build ios --clean
            ;;
    esac

    echo "✅ Project cleaned"
}

# Function to setup environment
setup_environment() {
    echo "🔧 Setting up environment..."

    # Create environment file if needed
    if [ ! -f "lib/config/env.dart" ]; then
        echo "Creating environment configuration..."
        mkdir -p lib/config

        cat > lib/config/env.dart << EOF
class Environment {
  static const String apiBaseUrl = '${ENVIRONMENT}_API_URL';
  static const String appName = 'Smart Presence';
  static const String version = '$VERSION_NAME';
  static const int versionCode = $VERSION_CODE;
  static const bool isProduction = ${ENVIRONMENT} == 'production';
}
EOF
    fi

    echo "✅ Environment setup complete"
}

# Function to build Android APK/AAB
build_android() {
    echo "🤖 Building Android app..."

    # Update version in pubspec.yaml
    sed -i.bak "s/version: .*/version: $VERSION_NAME+$VERSION_CODE/" pubspec.yaml

    # Build APK
    echo "Building APK..."
    flutter build apk --release --target-platform android-arm,android-arm64,android-x64

    # Build AAB (for Google Play)
    echo "Building AAB..."
    flutter build appbundle --release --target-platform android-arm,android-arm64,android-x64

    echo "✅ Android builds completed"
    echo "📦 APK: build/app/outputs/flutter-apk/app-release.apk"
    echo "📦 AAB: build/app/outputs/bundle/release/app-release.aab"
}

# Function to build iOS
build_ios() {
    echo "🍎 Building iOS app..."

    # Update version in pubspec.yaml
    sed -i.bak "s/version: .*/version: $VERSION_NAME+$VERSION_CODE/" pubspec.yaml

    # Build iOS
    flutter build ios --release --no-codesign

    echo "✅ iOS build completed"
    echo "📦 IPA: build/ios/iphoneos/Runner.app"
}

# Function to create release notes
create_release_notes() {
    echo "📝 Creating release notes..."

    cat > RELEASE_NOTES.md << EOF
# Smart Presence v$VERSION_NAME ($VERSION_CODE)

## Release Date
$(date +%Y-%m-%d)

## Platform
$PLATFORM

## Environment
$ENVIRONMENT

## What's New
- Complete Smart Presence application
- Face recognition attendance
- Multi-role user management
- Real-time notifications
- Offline mode support
- Device binding security

## Technical Details
- Flutter Version: $FLUTTER_VERSION
- Target Platforms: $PLATFORM
- Build Type: Release

## Installation
1. Download the app from the releases section
2. Install on your device
3. Configure backend API URL in settings
4. Login with your credentials

## Requirements
- Android: API 21+ (Android 5.0+)
- iOS: iOS 11.0+
- Internet connection for full functionality
- Camera permissions for face recognition

## Support
For issues or questions, please contact the development team.
EOF

    echo "✅ Release notes created"
}

# Function to create deployment package
create_deployment_package() {
    echo "📦 Creating deployment package..."

    DEPLOY_DIR="deploy/smart_presence_${PLATFORM}_${ENVIRONMENT}_v${VERSION_NAME}"

    mkdir -p "$DEPLOY_DIR"

    # Copy build artifacts
    case $PLATFORM in
        android)
            cp build/app/outputs/flutter-apk/app-release.apk "$DEPLOY_DIR/" 2>/dev/null || true
            cp build/app/outputs/bundle/release/app-release.aab "$DEPLOY_DIR/" 2>/dev/null || true
            ;;
        ios)
            cp -r build/ios/iphoneos/Runner.app "$DEPLOY_DIR/" 2>/dev/null || true
            ;;
    esac

    # Copy documentation
    cp README.md "$DEPLOY_DIR/" 2>/dev/null || true
    cp RELEASE_NOTES.md "$DEPLOY_DIR/" 2>/dev/null || true

    # Create deployment info
    cat > "$DEPLOY_DIR/deployment_info.txt" << EOF
Smart Presence Mobile App
Version: $VERSION_NAME ($VERSION_CODE)
Platform: $PLATFORM
Environment: $ENVIRONMENT
Build Date: $(date)
Flutter Version: $FLUTTER_VERSION

Files:
$(ls -la "$DEPLOY_DIR")

Next Steps:
1. Test the app on target devices
2. Submit to app stores (Google Play, App Store)
3. Configure backend API endpoints
4. Set up push notification services
EOF

    # Create zip archive
    cd deploy
    zip -r "smart_presence_${PLATFORM}_${ENVIRONMENT}_v${VERSION_NAME}.zip" "smart_presence_${PLATFORM}_${ENVIRONMENT}_v${VERSION_NAME}/"
    cd ..

    echo "✅ Deployment package created: deploy/smart_presence_${PLATFORM}_${ENVIRONMENT}_v${VERSION_NAME}.zip"
}

# Main build flow
main() {
    echo "🏗️ Starting Flutter app build process..."

    # Check prerequisites
    check_prerequisites

    # Clean project
    clean_project

    # Setup environment
    setup_environment

    # Build based on platform
    case $PLATFORM in
        android)
            build_android
            ;;
        ios)
            build_ios
            ;;
        both)
            build_android
            build_ios
            ;;
        *)
            echo "❌ Invalid platform. Use: android, ios, or both"
            exit 1
            ;;
    esac

    # Create release notes
    create_release_notes

    # Create deployment package
    create_deployment_package

    echo ""
    echo "🎉 Build completed successfully!"
    echo ""
    echo "📋 Summary:"
    echo "  Version: $VERSION_NAME ($VERSION_CODE)"
    echo "  Platform: $PLATFORM"
    echo "  Environment: $ENVIRONMENT"
    echo "  Build Date: $(date)"
    echo ""
    echo "📦 Deployment package: deploy/smart_presence_${PLATFORM}_${ENVIRONMENT}_v${VERSION_NAME}.zip"
    echo ""
    echo "🚀 Next steps:"
    echo "  1. Test the app on target devices"
    echo "  2. Submit to app stores"
    echo "  3. Configure production backend"
    echo "  4. Set up push notifications"
}

# Run main function
main "$@"