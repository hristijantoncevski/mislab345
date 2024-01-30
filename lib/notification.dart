import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  Notifications();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/notificationbell');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<NotificationDetails> notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channelId', 'channelName', channelDescription: 'description', importance: Importance.max, priority: Priority.max, playSound: false);

    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> show({required int id, required String title, required String body}) async {
    final details = await notificationDetails();

    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }

  Future<void> scheduleNotification({required int id,required String title, required String body, required String date, required String time}) async {
    final details = await notificationDetails();

    final parsedTime = parseDateTime('$date $time');
    final scheduleTime = parsedTime.subtract(const Duration(hours: 1));

    await flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      body,
      scheduleTime,
      //DateTime.now().add(const Duration(seconds: 30)), // 30 seconds after adding with API 25
      //tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)), // 1 minute from now (API 25+)
      //tz.TZDateTime.from(scheduleTime, tz.local), // 1 hour before the exam with zonedSchedule (API 25+),
      details,
      //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true
    );
  }

  DateTime parseDateTime(String dateTimeString) {
    final List<String> parts = dateTimeString.split(' ');
    final List<String> dateParts = parts[0].split('-');
    final List<String> timeParts = parts[1].split(':');

    final int year = int.parse(dateParts[2]);
    final int month = int.parse(dateParts[1]);
    final int day = int.parse(dateParts[0]);
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    return DateTime(year, month, day, hour, minute);
  }
}
