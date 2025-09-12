import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_users_app/core/errors/exceptions.dart';
import 'package:uber_users_app/core/network/api_service.dart';
import 'package:uber_users_app/features/authentication/data/datasources/auth_api_data_source.dart';
import 'package:uber_users_app/features/authentication/data/models/user_model.dart';

import 'auth_api_data_source_test.mocks.dart';

@GenerateMocks([ApiService, GoogleSignIn, SharedPreferences])
void main() {
  late AuthApiDataSourceImpl dataSource;
  late MockApiService mockApiService;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockApiService = MockApiService();
    mockGoogleSignIn = MockGoogleSignIn();
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthApiDataSourceImpl(
      apiService: mockApiService,
      googleSignIn: mockGoogleSignIn,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('AuthApiDataSource', () {
    group('signInWithPhone', () {
      test('should call apiService.sendOtp with correct phone number', () async {
        // arrange
        const phoneNumber = '+1234567890';
        when(mockApiService.sendOtp(phoneNumber: anyNamed('phoneNumber')))
            .thenAnswer((_) async => {'success': true});

        // act
        await dataSource.signInWithPhone(phoneNumber: phoneNumber);

        // assert
        verify(mockApiService.sendOtp(phoneNumber: phoneNumber));
      });

      test('should throw ServerException when apiService throws exception', () async {
        // arrange
        const phoneNumber = '+1234567890';
        when(mockApiService.sendOtp(phoneNumber: anyNamed('phoneNumber')))
            .thenThrow(Exception('Network error'));

        // act & assert
        expect(
          () => dataSource.signInWithPhone(phoneNumber: phoneNumber),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('verifyOTP', () {
      test('should return UserModel when OTP verification succeeds', () async {
        // arrange
        const phoneNumber = '+1234567890';
        const otp = '123456';
        const token = 'jwt_token_here';
        final userData = {
          'id': 'user_id',
          'name': 'John Doe',
          'email': 'john@example.com',
          'phone': phoneNumber,
          'blockStatus': 'no',
        };
        final apiResponse = {
          'token': token,
          'user': userData,
        };

        when(mockApiService.verifyOtp(
          phoneNumber: anyNamed('phoneNumber'),
          otp: anyNamed('otp'),
        )).thenAnswer((_) async => apiResponse);

        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        // act
        final result = await dataSource.verifyOTP(
          phoneNumber: phoneNumber,
          otp: otp,
        );

        // assert
        expect(result, isA<UserModel>());
        expect(result.id, equals('user_id'));
        expect(result.name, equals('John Doe'));
        expect(result.email, equals('john@example.com'));
        expect(result.phone, equals(phoneNumber));
        verify(mockApiService.verifyOtp(phoneNumber: phoneNumber, otp: otp));
        verify(mockSharedPreferences.setString('auth_token', token));
      });

      test('should throw ServerException when token is missing', () async {
        // arrange
        const phoneNumber = '+1234567890';
        const otp = '123456';
        final apiResponse = {
          'user': {
            'id': 'user_id',
            'name': 'John Doe',
            'email': 'john@example.com',
            'phone': phoneNumber,
            'blockStatus': 'no',
          },
        };

        when(mockApiService.verifyOtp(
          phoneNumber: anyNamed('phoneNumber'),
          otp: anyNamed('otp'),
        )).thenAnswer((_) async => apiResponse);

        // act & assert
        expect(
          () => dataSource.verifyOTP(phoneNumber: phoneNumber, otp: otp),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('saveUserData', () {
      test('should call apiService.createUser with user data', () async {
        // arrange
        const userModel = UserModel(
          id: 'user_id',
          name: 'John Doe',
          email: 'john@example.com',
          phone: '+1234567890',
          blockStatus: 'no',
        );

        when(mockApiService.createUser(userData: anyNamed('userData')))
            .thenAnswer((_) async => {'success': true});
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        // act
        await dataSource.saveUserData(user: userModel);

        // assert
        verify(mockApiService.createUser(userData: userModel.toMap()));
        verify(mockSharedPreferences.setString('user_data', userModel.toJson()));
      });
    });

    group('checkUserExists', () {
      test('should return result from apiService', () async {
        // arrange
        const email = 'john@example.com';
        when(mockApiService.checkUserExists(email: anyNamed('email')))
            .thenAnswer((_) async => true);

        // act
        final result = await dataSource.checkUserExists(email: email);

        // assert
        expect(result, isTrue);
        verify(mockApiService.checkUserExists(email: email));
      });
    });

    group('signOut', () {
      test('should call logout services and clear local data', () async {
        // arrange
        when(mockApiService.logout()).thenAnswer((_) async {});
        when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
        when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

        // act
        await dataSource.signOut();

        // assert
        verify(mockApiService.logout());
        verify(mockGoogleSignIn.signOut());
        verify(mockSharedPreferences.remove('auth_token'));
        verify(mockSharedPreferences.remove('refresh_token'));
        verify(mockSharedPreferences.remove('user_data'));
      });

      test('should clear local data even when server logout fails', () async {
        // arrange
        when(mockApiService.logout()).thenThrow(Exception('Server error'));
        when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
        when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

        // act & assert
        expect(() => dataSource.signOut(), throwsA(isA<ServerException>()));
        
        // Verify local data is still cleared
        verify(mockSharedPreferences.remove('auth_token'));
        verify(mockSharedPreferences.remove('refresh_token'));
        verify(mockSharedPreferences.remove('user_data'));
      });
    });
  });
}
