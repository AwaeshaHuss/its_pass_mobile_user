# Its Pass - Users App

A Flutter-based Uber clone application for users to book rides, with Firebase integration and real-time features.

## Features

- **User Authentication**: Phone number and Google Sign-In authentication
- **Real-time Location**: GPS-based location tracking and mapping
- **Ride Booking**: Search destinations and book rides
- **Payment System**: Cash-only payment system (Stripe integration removed)
- **Firebase Integration**: Real-time database, authentication, and storage
- **Google Maps**: Interactive maps with route planning
- **Multi-platform**: Supports Android, iOS, Web, macOS, Linux, and Windows

## Recent Updates & Fixes

### Compatibility Fixes (September 2025)
- **Gradle Compatibility**: Updated Gradle wrapper to version 8.4 for Java 21 compatibility
- **Android Gradle Plugin**: Upgraded to version 8.1.0 for modern Android SDK support
- **Payment System**: Removed Stripe integration, converted to cash-only payments
- **Plugin Updates**: Temporarily removed incompatible plugins (`flutter_geofire`, `restart_app`, `rounded_loading_button`)

### Removed Dependencies
- `flutter_stripe`: Removed due to cash-only payment requirement
- `flutter_geofire`: Temporarily removed due to namespace compatibility issues with AGP 8.1.0+
- `restart_app`: Temporarily removed due to namespace compatibility issues
- `rounded_loading_button`: Removed due to API compatibility issues with current Flutter version

## Prerequisites

- Flutter SDK 3.32.5 or higher
- Dart 3.8.1 or higher
- Android Studio with Android SDK
- Java 21 (OpenJDK Runtime Environment)
- Firebase project setup

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd uber_users_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Add your `google-services.json` file to `android/app/`
   - Configure Firebase Authentication, Realtime Database, and Storage
   - Update Firebase configuration in the app

4. **Google Maps Setup**
   - Add your Google Maps API key to the project
   - Enable required Google Maps APIs in Google Cloud Console

## Running the App

### Development Mode
```bash
flutter run
```

### Specific Device
```bash
flutter run -d "device-name"
```

### Build APK
```bash
flutter build apk --debug
```

## Project Structure

```
lib/
├── appInfo/           # App information and authentication providers
├── authentication/    # Login, registration, and user info screens
├── config/           # Configuration files
├── global/           # Global variables and constants
├── methods/          # Common methods and utilities
├── models/           # Data models
├── pages/            # Main app screens
├── widgets/          # Reusable UI components
└── main.dart         # App entry point
```

## Key Dependencies

- `firebase_auth`: User authentication
- `firebase_database`: Real-time database
- `firebase_storage`: File storage
- `google_maps_flutter`: Interactive maps
- `geolocator`: Location services
- `provider`: State management
- `http`: API requests
- `permission_handler`: Device permissions

## Known Issues & TODOs

### Temporarily Disabled Features
1. **Geofire Integration**: Driver location tracking temporarily disabled
   - Location: `lib/pages/home_page.dart` (lines 393-450, 556)
   - Reason: Namespace compatibility with AGP 8.1.0+
   - TODO: Replace with compatible alternative or update plugin

2. **App Restart Functionality**: Auto-restart after payment temporarily disabled
   - Location: `lib/pages/home_page.dart` (line 584)
   - Reason: Plugin compatibility issues
   - TODO: Implement alternative restart mechanism

### Future Enhancements
- Re-implement driver location tracking with compatible plugin
- Add app restart functionality
- Update to latest Firebase SDK versions
- Implement push notifications
- Add ride history and ratings

## Development Notes

- The app uses cash-only payments (Stripe integration removed)
- Some real-time driver tracking features are temporarily disabled
- Compatible with Android Gradle Plugin 8.1.0 and Gradle 8.4
- Supports compilation with Java 21

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is part of the ITS Pass taxi service implementation.
