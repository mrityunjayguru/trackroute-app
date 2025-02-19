import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionRequester {
  static Future<void> requestNotificationPermission() async {
    // Check if we're on Android 13 or above
    if (await Permission.notification.isDenied) {
      // Request the notification permission
      PermissionStatus status = await Permission.notification.request();

      if (status.isGranted) {
        // debugPrint('Notification permission granted');
      } else {
        Permission.notification.request();
      }
    }
  }
}
