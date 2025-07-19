import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings android =
      AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
      InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  Future<void> scheduleDailyReminder({
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    await _notifications.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.daily,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminders',
          channelDescription: 'Daily wellness check reminders',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showMeditationReminder() async {
    await _notifications.show(
      1,
      'Time for Meditation',
      'Take a 5-minute break to calm your mind',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meditation_reminder',
          'Meditation Reminders',
          channelDescription: 'Reminders for meditation sessions',
        ),
      ),
    );
  }
}