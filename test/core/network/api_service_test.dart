import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uber_users_app/core/errors/exceptions.dart';
import 'package:uber_users_app/core/network/api_client.dart';
import 'package:uber_users_app/core/network/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([ApiClient, Dio])
void main() {
  late ApiService apiService;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    apiService = ApiService(mockApiClient);
  });

  group('ApiService', () {
    group('sendOtp', () {
      test('should return success response when OTP is sent successfully', () async {
        // arrange
        const phoneNumber = '+1234567890';
        final responseData = {'success': true, 'message': 'OTP sent successfully'};
        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(mockApiClient.dio).thenReturn(mockDio);
        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        // act
        final result = await apiService.sendOtp(phoneNumber: phoneNumber);

        // assert
        expect(result, equals(responseData));
        verify(mockDio.post('/auth/send-otp', data: {'phone_number': phoneNumber}));
      });

      test('should throw ServerException when request fails', () async {
        // arrange
        const phoneNumber = '+1234567890';
        final dioException = DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 400,
            data: {'message': 'Invalid phone number'},
            requestOptions: RequestOptions(path: ''),
          ),
        );

        when(mockApiClient.dio).thenReturn(mockDio);
        when(mockDio.post(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // act & assert
        expect(
          () => apiService.sendOtp(phoneNumber: phoneNumber),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('verifyOtp', () {
      test('should return user data when OTP is verified successfully', () async {
        // arrange
        const phoneNumber = '+1234567890';
        const otp = '123456';
        final responseData = {
          'token': 'jwt_token_here',
          'user': {
            'id': 'user_id',
            'name': 'John Doe',
            'email': 'john@example.com',
            'phone': phoneNumber,
            'blockStatus': 'no',
          }
        };
        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(mockApiClient.dio).thenReturn(mockDio);
        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        // act
        final result = await apiService.verifyOtp(
          phoneNumber: phoneNumber,
          otp: otp,
        );

        // assert
        expect(result, equals(responseData));
        verify(mockDio.post('/auth/verify-otp', data: {
          'phone_number': phoneNumber,
          'otp': otp,
        }));
      });
    });

    group('createUser', () {
      test('should create user successfully', () async {
        // arrange
        final userData = {
          'name': 'John Doe',
          'email': 'john@example.com',
          'phone': '+1234567890',
        };
        final responseData = {'success': true, 'user_id': 'user_123'};
        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        );

        when(mockApiClient.dio).thenReturn(mockDio);
        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        // act
        final result = await apiService.createUser(userData: userData);

        // assert
        expect(result, equals(responseData));
        verify(mockDio.post('/users/create', data: userData));
      });
    });

    group('checkUserExists', () {
      test('should return true when user exists', () async {
        // arrange
        const email = 'john@example.com';
        final responseData = {'exists': true};
        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(mockApiClient.dio).thenReturn(mockDio);
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => response);

        // act
        final result = await apiService.checkUserExists(email: email);

        // assert
        expect(result, isTrue);
        verify(mockDio.get('/users/exists', queryParameters: {'email': email}));
      });

      test('should return false when user does not exist', () async {
        // arrange
        const phone = '+1234567890';
        final responseData = {'exists': false};
        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );

        when(mockApiClient.dio).thenReturn(mockDio);
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => response);

        // act
        final result = await apiService.checkUserExists(phone: phone);

        // assert
        expect(result, isFalse);
        verify(mockDio.get('/users/exists', queryParameters: {'phone': phone}));
      });
    });
  });
}
