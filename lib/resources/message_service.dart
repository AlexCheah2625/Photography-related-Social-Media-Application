import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:practice/main.dart';
import 'package:practice/resources/features.dart';
import 'package:practice/resources/local_notification.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token:${fCMToken}");
    Features().AddTokenUser(fCMToken.toString());
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotification();
  }

  void handlemessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed('/chat_page');
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then((handlemessage));
    FirebaseMessaging.onMessageOpenedApp.listen(handlemessage);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification1 = message.notification;
      AndroidNotification? androidNotification = message.notification!.android;
      if (notification1 != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification1.hashCode,
            notification1.title,
            notification1.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'high_importance_channel', 'High Importance Notifications',
                  importance: Importance.high,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });
  }

  void sendPushNotification(String senderName, String message,
      String ReceiverToken, String receiverID) async {
    String serverkey =
        "AAAAlKMeWXM:APA91bE5DF2l5fkTM7ZQKgU71WGx-ssVsvFxRAKHKdsIKzA_NInnwGuyK982GCEr-eYBILXlNXwsIZ5qb8bNKp6iVNWUjQ-WHCXnYlYR2z_OilE50Nrr1oeKodatz3WcAHvUFmBlAYCh";
    final Map<String, dynamic> data = {
      'notification': {
        'title': "$senderName has messaged you",
        'body': message,
      },
      'data': {'foreground': true},
      'to': ReceiverToken,
    };

    final String jsonData = json.encode(data);

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverkey',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Message sent successfully.');
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
