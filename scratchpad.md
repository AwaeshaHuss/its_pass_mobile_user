# Scratchpad

## Current Task: Clean Architecture + BLoC Implementation - COMPLETED ✅

### Task Overview
Restructure the Flutter Uber clone app by implementing a Clean Architecture with BLoC pattern, replacing the existing Provider-based authentication system.

### Progress
- [x] Assess current architecture and identify areas for improvement
- [x] Create Clean Architecture folder structure
- [x] Implement domain layer (entities, repositories, use cases)
- [x] Implement data layer (models, data sources, repository implementations)
- [x] Implement presentation layer (BLoC, events, states)
- [x] Set up dependency injection with get_it and injectable
- [x] Create new authentication screens using BLoC pattern
- [x] Update main.dart to integrate new architecture
- [x] Write comprehensive tests for BLoC implementation
- [x] Fix Android compatibility issues
- [x] **COMMIT & PUSH**: Successfully committed to `clean-arch-impl` branch

### 🎉 Implementation Complete
**Branch**: `clean-arch-impl`  
**Commit**: `91d32c6` - feat: Implement Clean Architecture + BLoC for authentication  
**Files Added**: 30 files, 2929 insertions  
**GitHub PR**: https://github.com/AwaeshaHuss/its_pass_mobile_user/pull/new/clean-arch-impl

### Lessons Learned
1. **Clean Architecture Benefits**: Clear separation of concerns makes code more maintainable and testable
2. **BLoC Pattern**: Provides better state management than Provider for complex authentication flows
3. **Dependency Injection**: get_it + injectable makes testing and modularity much easier
4. **Error Handling**: Using Either<Failure, T> pattern provides robust error handling
5. **Testing**: BLoC testing with mockito provides excellent coverage and confidence
6. **Android Compatibility**: Theme.MaterialComponents can cause build issues, use @android:style/Theme.Light.NoTitleBar instead
7. **Git Workflow**: Always create feature branches for major architectural changes
8. **Commit Messages**: Use conventional commit format for better project history

### Architecture Decisions
- Domain layer contains business logic and entities
- Data layer handles external data sources (Firebase)
- Presentation layer manages UI state with BLoC
- Dependency injection centralizes object creation
- Either pattern for functional error handling
- Comprehensive testing strategy with mocks

### Future Enhancements
- Address remaining lint warnings (47 info-level issues)
- Migrate other features to Clean Architecture
- Remove legacy Provider-based code
- Performance optimization
- Deployment preparation

### Clean Architecture Implementation Summary

**Files Created:**
- `lib/injection/injection.dart` - Dependency injection setup
- `lib/injection/firebase_module.dart` - Firebase services module
- `lib/core/errors/exceptions.dart` - Exception classes
- `lib/features/authentication/domain/entities/user_entity.dart` - User domain entity
- `lib/features/authentication/domain/repositories/auth_repository.dart` - Repository interface
- `lib/features/authentication/domain/usecases/` - Use cases (4 files)
- `lib/features/authentication/data/models/user_model.dart` - Data model
- `lib/features/authentication/data/datasources/auth_remote_data_source.dart` - Firebase data source
- `lib/features/authentication/data/repositories/auth_repository_impl.dart` - Repository implementation
- `lib/features/authentication/presentation/bloc/` - BLoC files (3 files)
- `test/features/authentication/presentation/bloc/auth_bloc_test.dart` - Comprehensive tests

**Architecture Benefits:**
- ✅ Separation of concerns (Domain/Data/Presentation layers)
- ✅ Dependency inversion principle
- ✅ Testable business logic
- ✅ Clean error handling with Either types
- ✅ Proper state management with BLoC
- ✅ Firebase abstraction through data sources

### Lessons
- Successfully removed all Stripe payment integration from Flutter app
- Key files modified: pubspec.yaml, main.dart, global_var.dart, payment_dialog.dart
- Deleted stripe_payment_service.dart completely
- Updated PaymentDialog widget to show only cash payment option
- Added comprehensive unit tests for cash-only payment functionality
- Flutter analyze confirmed no Stripe-related errors remain
- Payment system now supports only cash payments as requested

### New Lessons from Device Deployment Task
- Gradle 8.4 is required for Java 21 compatibility (updated gradle-wrapper.properties)
- Android Gradle Plugin 8.1.0+ requires namespace declarations in plugin build.gradle files
- Some older Flutter plugins (flutter_geofire, restart_app) are incompatible with AGP 8.1.0+ due to missing namespace declarations
- rounded_loading_button package has API compatibility issues with current Flutter version (onSurface parameter removed)
- Temporary solution: Comment out incompatible plugin usage and remove dependencies until compatible alternatives are found
- Always update README.md to document compatibility fixes and temporarily disabled features
- TECNO KI5q device connects via WiFi at IP 192.168.0.125:5555
