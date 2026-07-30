import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ntf;
import 'package:permission_handler/permission_handler.dart';

import '../aliment/domain/aliment.dart';
import '../aliment/data/aliment_bank.dart';

typedef NotifPlugin = ntf.FlutterLocalNotificationsPlugin;
typedef AndroidSettings = ntf.AndroidInitializationSettings;
typedef InitSettings = ntf.InitializationSettings;
typedef NotifDetails = ntf.NotificationDetails;
typedef AndroidDetails = ntf.AndroidNotificationDetails;

class NotificationHandler {
  static final _notificationsPlugin = NotifPlugin();

  static Future<void> initialize() async {
    const androidInitSettings = AndroidSettings('ic_notification');
    const initSettings = InitSettings(android: androidInitSettings);
    await _notificationsPlugin.initialize(settings: initSettings);
  }

  static String _alimentToLine(Aliment e, AlimentBankState bank) {
    final String name = e.readDataRef(bank).name;
    final String servingSize = e.servingSize % 1 == 0
        ? e.servingSize.toInt().toString()
        : e.servingSize.toStringAsFixed(1);

    final String s = '($servingSize${e.unit}) $name';
    return s.length < 54 ? s : s.substring(0, 54);
  }

  static Future<void> showListNotification(
      List<Aliment> list, AlimentBankState bank, String mealName) async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.notification.request();
    }

    String alimentToLine(Aliment e) => _alimentToLine(e, bank);
    List<String> lines = list.map<String>(alimentToLine).toList();

    final androidDetails = AndroidDetails(
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

    final notificationDetails = NotifDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: 0,
      title: '$mealName aliments',
      body: 'Expand to view aliments',
      notificationDetails: notificationDetails,
    );
  }
}
