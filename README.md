# Its Pass - Users App

A Flutter-based Uber clone application for users to book rides, with Firebase integration and real-time features. Built with **Clean Architecture** and **BLoC pattern** for maintainable, testable, and scalable code.

## Features

- **User Authentication**: Phone number and Google Sign-In authentication with BLoC state management
- **Real-time Location**: GPS-based location tracking and mapping
- **Ride Booking**: Search destinations and book rides
- **Payment System**: Cash-only payment system (Stripe integration removed)
- **Firebase Integration**: Real-time database, authentication, and storage
- **Google Maps**: Interactive maps with route planning
- **Multi-platform**: Supports Android, iOS, Web, macOS, Linux, and Windows
- **Clean Architecture**: Domain, Data, and Presentation layers with dependency injection

## Recent Updates & Fixes

### Clean Architecture Implementation (September 2025) ✨
- **Architecture Overhaul**: Complete Clean Architecture implementation with BLoC pattern
- **Authentication Refactor**: Replaced Provider-based auth with BLoC state management
- **Dependency Injection**: Implemented with get_it and injectable for better testability
- **New Authentication Screens**: Modern UI with country picker, OTP verification, and profile completion
- **Comprehensive Testing**: BLoC unit tests with 85% coverage
- **Error Handling**: Functional error handling with Either<Failure, T> pattern

### Compatibility Fixes (September 2025)
- **Gradle Compatibility**: Updated Gradle wrapper to version 8.4 for Java 21 compatibility
- **Android Gradle Plugin**: Upgraded to version 8.1.0 for modern Android SDK support
- **Payment System**: Removed Stripe integration, converted to cash-only payments
- **Plugin Updates**: Temporarily removed incompatible plugins (`flutter_geofire`, `restart_app`, `rounded_loading_button`)
- **Android Theme Fix**: Resolved Theme.MaterialComponents compatibility issue

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

### Clean Architecture Structure
```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # App constants
│   ├── errors/             # Exception and failure classes
│   └── utils/              # Utility functions and typedefs
├── features/               # Feature-based modules
│   └── authentication/     # Authentication feature
│       ├── domain/         # Business logic layer
│       │   ├── entities/   # Domain entities
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/   # Use cases
│       ├── data/           # Data layer
│       │   ├── datasources/ # Remote/local data sources
│       │   ├── models/     # Data models
│       │   └── repositories/ # Repository implementations
│       └── presentation/   # UI layer
│           ├── bloc/       # BLoC state management
│           └── pages/      # UI screens
├── injection/              # Dependency injection setup
├── appInfo/               # Legacy app information (to be migrated)
├── authentication/        # Legacy auth screens (deprecated)
├── pages/                 # Legacy main app screens
├── widgets/               # Reusable UI components
└── main.dart              # App entry point with DI initialization
```

## Key Dependencies

### Core Architecture
- `flutter_bloc`: BLoC state management pattern
- `get_it`: Service locator for dependency injection
- `injectable`: Code generation for dependency injection
- `dartz`: Functional programming (Either, Option types)
- `equatable`: Value equality for objects

### Firebase & Authentication
- `firebase_auth`: User authentication
- `firebase_database`: Real-time database
- `firebase_storage`: File storage
- `google_sign_in`: Google authentication

### UI & Navigation
- `google_maps_flutter`: Interactive maps
- `country_picker`: Country selection for phone auth
- `pinput`: PIN/OTP input widget

### Utilities
- `geolocator`: Location services
- `http`: API requests
- `permission_handler`: Device permissions

### Testing
- `mockito`: Mocking for unit tests
- `build_runner`: Code generation

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
- **Legacy Code Migration**: Migrate remaining features to Clean Architecture
- **Remove Legacy Code**: Clean up deprecated Provider-based authentication
- **Driver Location Tracking**: Re-implement with compatible plugin
- **App Restart Functionality**: Add alternative restart mechanism
- **Firebase Updates**: Update to latest Firebase SDK versions
- **Push Notifications**: Implement real-time notifications
- **Ride History & Ratings**: Add user feedback system

## Architecture Benefits

### Clean Architecture Advantages
- **Separation of Concerns**: Clear boundaries between business logic, data, and UI
- **Testability**: Easy to unit test business logic independently
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new features following established patterns
- **Dependency Inversion**: High-level modules don't depend on low-level modules

### BLoC Pattern Benefits
- **Predictable State Management**: Clear state transitions and event handling
- **Reactive Programming**: UI automatically updates based on state changes
- **Testing**: Easy to test business logic with mock events and states
- **Debugging**: Clear event/state flow for easier debugging

## Development Notes

- **Architecture**: Clean Architecture with BLoC pattern for authentication
- **Payment System**: Cash-only payments (Stripe integration removed)
- **Legacy Code**: Some features still use Provider pattern (to be migrated)
- **Compatibility**: Android Gradle Plugin 8.1.0 and Gradle 8.4
- **Java Support**: Compilation with Java 21
- **Testing**: Comprehensive BLoC unit tests with 85% coverage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is part of the ITS Pass taxi service implementation.
