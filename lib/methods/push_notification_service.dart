import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/global/global_var.dart';

class PushNotificationService {
  static Future<String> getAccessToken() async {
    try {
      // TODO: Load service account credentials from environment variables or secure storage
      final serviceAccountJson = {
        "type": "service_account",
        "project_id": "YOUR_PROJECT_ID",
        "private_key_id": "YOUR_PRIVATE_KEY_ID",
        "private_key": "YOUR_PRIVATE_KEY",
        "client_email": "YOUR_CLIENT_EMAIL",
        "client_id": "YOUR_CLIENT_ID",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "YOUR_CLIENT_X509_CERT_URL",
        "universe_domain": "googleapis.com"
      };
      List<String> scopes = [
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/firebase.database",
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );
      client.close();
      return credentials.accessToken.data;
    } catch (e) {
      // Failed to obtain access token: $e
      rethrow; // Optionally rethrow the exception
    }
  }

  static sendNotificationToSelectedDriver(
      String deviceToken, BuildContext context, String tripID) async {
        // Device token: $deviceToken
    String dropOffDesitinationAddress =
        Provider.of<AppInfoClass>(context, listen: false)
            .dropOffLocation!
            .placeName
            .toString();
    String pickUpAddress = Provider.of<AppInfoClass>(context, listen: false)
        .pickUpLocation!
        .placeName
        .toString();
    // Pickup address: $pickUpAddress
    final String serverKeyTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send";
    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': "New Trip Request From $userName",
          'body':
              "PickUp Location: $pickUpAddress \nDropOff Location: $dropOffDesitinationAddress"
        },
        'data': {
          'tripID': tripID,
        }
      }
    };
    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKeyTokenKey'
      },
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      // Notification sent successfully: ${response.statusCode}
    } else {
      // Failed to send notification: ${response.statusCode}
    }
  }
}
