import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ntf;

import 'aliment.dart';

class NotificationHandler {
  static final ntf.FlutterLocalNotificationsPlugin _notificationsPlugin =
      ntf.FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const ntf.AndroidInitializationSettings androidInitSettings =
        ntf.AndroidInitializationSettings('@mipmap/ic_launcher');

    const ntf.InitializationSettings initSettings =
        ntf.InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showListNotification(List<Aliment> list) async {
    List<String> lines = list
        .map((e) => '(${e.servingSize}) ${e.getAliment.name}')
        .map((e) => e.length < 54 ? e : e.substring(0, 54))
        .toList();

    final ntf.AndroidNotificationDetails androidPlatformChannelSpecifics =
        ntf.AndroidNotificationDetails(
      'list_notification',
      'List Notification',
      channelDescription: 'A simple text-based notification with a list',
      importance: ntf.Importance.max,
      priority: ntf.Priority.high,
      ticker: 'ticker',
      styleInformation: ntf.BigTextStyleInformation(
        lines.join('\n'),
        contentTitle: 'Your List Title',
        summaryText: 'Tap to view more',
      ),
    );

    final ntf.NotificationDetails notificationDetails =
        ntf.NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Your List Notification',
      'Here are some items:',
      notificationDetails,
    );
  }
}
