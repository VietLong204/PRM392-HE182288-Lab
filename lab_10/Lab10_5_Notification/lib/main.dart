import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    try {
      const init = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));
      await _notifications.initialize(settings: init);
      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (_) {}
  }

  Future<void> _sendNotification() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'Notification Channel', importance: Importance.high, priority: Priority.high),
    );
    await _notifications.show(
      id: 0,
      title: 'Thông báo Lab 10.5',
      body: 'Gửi thông báo thành công (LO7)!',
      notificationDetails: details,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.5: Local Notification')),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendNotification,
          child: const Text('Bấm để gửi thông báo'),
        ),
      ),
    );
  }
}
