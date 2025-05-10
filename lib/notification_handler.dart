import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ntf;

import 'aliment/aliment.dart';

class NotificationHandler {
  static final ntf.FlutterLocalNotificationsPlugin _notificationsPlugin =
      ntf.FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const ntf.AndroidInitializationSettings androidInitSettings =
        ntf.AndroidInitializationSettings('ic_notification');

    const ntf.InitializationSettings initSettings =
        ntf.InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(initSettings);
  }

  static String alimentToLine(Aliment e) {
    final String servingSize = e.servingSize % 1 == 0
        ? e.servingSize.toInt().toString()
        : e.servingSize.toStringAsFixed(1);

    return '($servingSize${e.unit}) ${e.readData.name}';
  }

  static Future<void> showListNotification(
      List<Aliment> list, String mealName) async {
    List<String> lines = list
        .map(alimentToLine)
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
      color: Colors.lightGreen,
      colorized: true,
      styleInformation: ntf.BigTextStyleInformation(
        lines.join('\n'),
        contentTitle: '$mealName aliments',
        summaryText: 'Meal summary',
      ),
    );

    final ntf.NotificationDetails notificationDetails =
        ntf.NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      '$mealName aliments',
      'Expand to view aliments',
      notificationDetails,
    );
  }
}
