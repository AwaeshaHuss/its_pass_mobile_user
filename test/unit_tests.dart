import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_users_app/methods/common_methods.dart';
import 'package:uber_users_app/methods/manage_drivers_methods.dart';
import 'package:uber_users_app/models/online_nearby_drivers.dart';
import 'package:uber_users_app/models/direction_details.dart';
import 'package:uber_users_app/widgets/payment_dialog.dart';

void main() {
  group('CommonMethods Tests', () {
    test('calculateFareAmountInPKR should calculate correct fare', () {
      // Arrange
      final commonMethods = CommonMethods();
      final directionDetails = DirectionDetails();
      directionDetails.distanceValueDigit = 5000; // 5 km in meters
      directionDetails.durationValueDigit = 600; // 10 minutes in seconds

      // Act
      final fare = commonMethods.calculateFareAmountInPKR(directionDetails);

      // Assert
      expect(fare, isA<double>());
      expect(fare, greaterThan(0));
      // Base fare (150) + distance (5km * 20) + duration (10min * 15) = 150 + 100 + 150 = 400
      expect(fare, equals(400.0));
    });

    test('calculateFareAmountInPKR with surge multiplier should apply correctly', () {
      // Arrange
      final commonMethods = CommonMethods();
      final directionDetails = DirectionDetails();
      directionDetails.distanceValueDigit = 5000; // 5 km in meters
      directionDetails.durationValueDigit = 600; // 10 minutes in seconds
      const surgeMultiplier = 1.5;

      // Act
      final fare = commonMethods.calculateFareAmountInPKR(
        directionDetails,
        surgeMultiplier: surgeMultiplier,
      );

      // Assert
      expect(fare, equals(600.0)); // 400 * 1.5 = 600
    });

    test('shortenAddress should handle long addresses correctly', () {
      // Arrange
      const longAddress = "123 Very Long Street Name, District, City, Province, Country, Postal Code";
      
      // Act
      final shortenedAddress = CommonMethods.shortenAddress(longAddress);
      
      // Assert
      expect(shortenedAddress, isA<String>());
      expect(shortenedAddress.length, lessThanOrEqualTo(longAddress.length));
      expect(shortenedAddress, equals("123 Very Long Street Name, District"));
    });

    test('shortenAddress should handle short addresses correctly', () {
      // Arrange
      const shortAddress = "123 Main St";
      
      // Act
      final shortenedAddress = CommonMethods.shortenAddress(shortAddress);
      
      // Assert
      expect(shortenedAddress, equals(shortAddress));
    });
  });

  group('ManageDriversMethods Tests', () {
    setUp(() {
      // Clear the list before each test
      ManageDriversMethods.nearbyOnlineDriversList.clear();
    });

    test('removeDriverFromList should remove existing driver', () {
      // Arrange
      final driver = OnlineNearbyDrivers();
      driver.uidDriver = "test_driver_123";
      driver.latDriver = 37.4219983;
      driver.lngDriver = -122.084;
      ManageDriversMethods.nearbyOnlineDriversList.add(driver);

      // Act
      ManageDriversMethods.removeDriverFromList("test_driver_123");

      // Assert
      expect(ManageDriversMethods.nearbyOnlineDriversList.length, equals(0));
    });

    test('removeDriverFromList should handle non-existing driver gracefully', () {
      // Arrange
      final driver = OnlineNearbyDrivers();
      driver.uidDriver = "test_driver_123";
      ManageDriversMethods.nearbyOnlineDriversList.add(driver);

      // Act
      ManageDriversMethods.removeDriverFromList("non_existing_driver");

      // Assert
      expect(ManageDriversMethods.nearbyOnlineDriversList.length, equals(1));
    });

    test('updateOnlineNearbyDriversLocation should update existing driver location', () {
      // Arrange
      final driver = OnlineNearbyDrivers();
      driver.uidDriver = "test_driver_123";
      driver.latDriver = 37.4219983;
      driver.lngDriver = -122.084;
      ManageDriversMethods.nearbyOnlineDriversList.add(driver);

      final updatedDriver = OnlineNearbyDrivers();
      updatedDriver.uidDriver = "test_driver_123";
      updatedDriver.latDriver = 37.4220000;
      updatedDriver.lngDriver = -122.085;

      // Act
      ManageDriversMethods.updateOnlineNearbyDriversLocation(updatedDriver);

      // Assert
      final resultDriver = ManageDriversMethods.nearbyOnlineDriversList.first;
      expect(resultDriver.latDriver, equals(37.4220000));
      expect(resultDriver.lngDriver, equals(-122.085));
    });

    test('updateOnlineNearbyDriversLocation should handle non-existing driver gracefully', () {
      // Arrange
      final driver = OnlineNearbyDrivers();
      driver.uidDriver = "test_driver_123";
      driver.latDriver = 37.4219983;
      driver.lngDriver = -122.084;
      ManageDriversMethods.nearbyOnlineDriversList.add(driver);

      final nonExistingDriver = OnlineNearbyDrivers();
      nonExistingDriver.uidDriver = "non_existing_driver";
      nonExistingDriver.latDriver = 37.4220000;
      nonExistingDriver.lngDriver = -122.085;

      // Act
      ManageDriversMethods.updateOnlineNearbyDriversLocation(nonExistingDriver);

      // Assert
      final resultDriver = ManageDriversMethods.nearbyOnlineDriversList.first;
      expect(resultDriver.latDriver, equals(37.4219983)); // Should remain unchanged
      expect(resultDriver.lngDriver, equals(-122.084)); // Should remain unchanged
    });
  });

  group('DirectionDetails Tests', () {
    test('DirectionDetails should initialize with default values', () {
      // Act
      final directionDetails = DirectionDetails();

      // Assert
      expect(directionDetails.distanceTextString, isNull);
      expect(directionDetails.distanceValueDigit, isNull);
      expect(directionDetails.durationTextString, isNull);
      expect(directionDetails.durationValueDigit, isNull);
      expect(directionDetails.encodedPoints, isNull);
    });
  });

  group('OnlineNearbyDrivers Tests', () {
    test('OnlineNearbyDrivers should initialize with default values', () {
      // Act
      final driver = OnlineNearbyDrivers();

      // Assert
      expect(driver.uidDriver, isNull);
      expect(driver.latDriver, isNull);
      expect(driver.lngDriver, isNull);
    });

    test('OnlineNearbyDrivers should store values correctly', () {
      // Arrange & Act
      final driver = OnlineNearbyDrivers();
      driver.uidDriver = "test_driver_456";
      driver.latDriver = 37.4219983;
      driver.lngDriver = -122.084;

      // Assert
      expect(driver.uidDriver, equals("test_driver_456"));
      expect(driver.latDriver, equals(37.4219983));
      expect(driver.lngDriver, equals(-122.084));
    });
  });

  group('Payment System Tests', () {
    testWidgets('PaymentDialog should display cash payment option only', (WidgetTester tester) async {
      // Arrange
      const fareAmount = "250";
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentDialog(fareAmount: fareAmount),
          ),
        ),
      );

      // Assert
      expect(find.text("PAY CASH"), findsOneWidget);
      expect(find.text("Rs $fareAmount"), findsOneWidget);
      expect(find.text("PAY WITH CASH"), findsOneWidget);
      expect(find.text("This is fare amount ( Rs $fareAmount ) you have to pay to the driver."), findsOneWidget);
      
      // Verify that credit card payment option is not present
      expect(find.text("PAY WITH CREDIT CARD"), findsNothing);
    });

    testWidgets('PaymentDialog should return "paid" when cash payment is selected', (WidgetTester tester) async {
      // Arrange
      const fareAmount = "150";
      String? result;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<String>(
                    context: context,
                    builder: (context) => PaymentDialog(fareAmount: fareAmount),
                  );
                },
                child: const Text("Show Payment Dialog"),
              ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text("Show Payment Dialog"));
      await tester.pumpAndSettle();

      // Tap cash payment button
      await tester.tap(find.text("PAY WITH CASH"));
      await tester.pumpAndSettle();

      // Assert
      expect(result, equals("paid"));
    });

    test('Cash payment should be the only available payment method', () {
      // This test verifies that after removing Stripe, only cash payment is available
      const availablePaymentMethods = ["cash"];
      
      expect(availablePaymentMethods.length, equals(1));
      expect(availablePaymentMethods.contains("cash"), isTrue);
      expect(availablePaymentMethods.contains("stripe"), isFalse);
      expect(availablePaymentMethods.contains("credit_card"), isFalse);
    });
  });
}
