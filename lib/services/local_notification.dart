import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelGroupKey: 'input_channel_group',
        channelKey: 'input_channel',
        channelName: 'Input notifications',
        channelDescription: 'Notification channel',
        ledColor: Colors.white,
      )
    ]);

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}
