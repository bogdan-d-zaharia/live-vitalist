import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ntf;
import 'package:permission_handler/permission_handler.dart';

import 'aliment/aliment.dart';
import 'aliment/aliment_bank_provider.dart';

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

  static Future<void> showListNotification(
      List<Aliment> list, AlimentBankState bank, String mealName) async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.notification.request();
    }

    List<String> lines = list.map(
      (e) {
        final String name = e.readDataRef(bank).name;
        final String servingSize = e.servingSize % 1 == 0
            ? e.servingSize.toInt().toString()
            : e.servingSize.toStringAsFixed(1);

        final String s = '($servingSize${e.unit}) $name';
        return s.length < 54 ? s : s.substring(0, 54);
      },
    ).toList();

    final ntf.AndroidNotificationDetails androidPlatformChannelSpecifics =
        ntf.AndroidNotificationDetails(
      'meal_summary',
      'Meal Summary',
      channelDescription: 'Text-based notification with a list of aliments',
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
