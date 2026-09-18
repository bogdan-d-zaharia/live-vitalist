import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ntf;
import 'package:live_vitalist/features/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_state.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

typedef NotifPlugin = ntf.FlutterLocalNotificationsPlugin;
typedef AndroidSettings = ntf.AndroidInitializationSettings;
typedef InitSettings = ntf.InitializationSettings;
typedef NotifDetails = ntf.NotificationDetails;
typedef AndroidDetails = ntf.AndroidNotificationDetails;

class NotificationHandler {
  static final _notificationsPlugin = NotifPlugin();
  static Future<void>? _initialization;

  static Future<void> initialize() => _initialization ??= _initialize();

  static Future<void> _initialize() async {
    const androidInitSettings = AndroidSettings('ic_notification');
    const iosInitSettings = ntf.DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    await _notificationsPlugin.initialize(settings: initSettings);
  }

  static Future<bool> _requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final plugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          ntf.IOSFlutterLocalNotificationsPlugin>();
      return await plugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      final plugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          ntf.AndroidFlutterLocalNotificationsPlugin>();
      return await plugin?.requestNotificationsPermission() ?? false;
    }
    return false;
  }

  static String _alimentToLine(
      Aliment e, AlimentBankState bank, String languageCode) {
    final String name = e.readDataRef(bank).readName(languageCode);
    final String servingSize = e.servingSize % 1 == 0
        ? e.servingSize.toInt().toString()
        : e.servingSize.toStringAsFixed(1);

    final String s = '($servingSize${e.unit}) $name';
    return s.length < 54 ? s : s.substring(0, 54);
  }

  static Future<void> showListNotification(
    List<Aliment> list,
    AlimentBankState bank,
    String mealName,
    AppLocalizations localization,
    String languageCode,
  ) async {
    await initialize();
    if (!await _requestPermission()) return;

    String alimentToLine(Aliment e) => _alimentToLine(e, bank, languageCode);
    List<String> lines = list.map<String>(alimentToLine).toList();
    final title =
        localization.mealsJournalNotificationTitle(mealName, list.length);

    final androidDetails = AndroidDetails(
      'meal_summary',
      localization.mealsJournalNotificationChannel,
      channelDescription:
          localization.mealsJournalNotificationChannelDescription,
      importance: ntf.Importance.max,
      priority: ntf.Priority.high,
      ticker: 'ticker',
      color: Colors.lightGreen,
      colorized: true,
      styleInformation: ntf.BigTextStyleInformation(
        lines.join('\n'),
        contentTitle: title,
        summaryText: localization.mealsJournalNotificationSummary,
      ),
    );

    final iosDetails = ntf.DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
      subtitle: localization.mealsJournalNotificationSummary,
      threadIdentifier: 'meal_summary',
    );
    final notificationDetails = NotifDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: 0,
      title: title,
      body: defaultTargetPlatform == TargetPlatform.iOS && lines.isNotEmpty
          ? lines.join('\n')
          : localization.mealsJournalNotificationBody,
      notificationDetails: notificationDetails,
    );
  }
}
