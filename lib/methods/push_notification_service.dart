import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:itspass_user/appInfo/app_info.dart';
import 'package:itspass_user/global/global_var.dart';

class PushNotificationService {
  // Generic push notification service that can work with any push notification provider
  // TODO: Configure with your preferred push notification service (OneSignal, Pusher, etc.)
  
  static Future<bool> sendNotificationToSelectedDriver(String deviceToken, BuildContext context, String tripID) async {
    try {
      // TODO: Replace with your push notification service API
      // Example implementation for a generic push notification service
      
      const String pushNotificationEndpoint = 'https://your-api-server.com/api/notifications/send';
      
      // Get destination address from app info
      String destinationAddress = "Unknown destination";
      try {
        destinationAddress = Provider.of<AppInfoClass>(context, listen: false)
            .dropOffLocation?.placeName ?? "Unknown destination";
      } catch (e) {
        // Fallback if context is not available
        destinationAddress = "Trip destination";
      }
      
      final Map<String, dynamic> notificationData = {
        'device_token': deviceToken,
        'title': "NEW TRIP REQUEST from $userName",
        'body': "Destination: $destinationAddress",
        'data': {
          'tripID': tripID,
          'type': 'trip_request',
        },
      };

      final http.Response response = await http.post(
        Uri.parse(pushNotificationEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_TOKEN', // TODO: Replace with actual API token
        },
        body: jsonEncode(notificationData),
      );

      if (response.statusCode == 200) {
        return true; // Notification sent successfully
      } else {
        // Failed to send notification: ${response.statusCode}
        return false;
      }
    } catch (e) {
      // Error sending notification: $e
      return false;
    }
  }

  // Alternative: Local notification fallback
  static Future<void> showLocalNotification(String title, String body) async {
    // TODO: Implement local notifications using flutter_local_notifications
    // This can serve as a fallback when push notifications are not available
  }
}
