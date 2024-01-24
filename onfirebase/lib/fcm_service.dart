import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Solicita permisos para iOS
    NotificationSettings settings = await _messaging.requestPermission();
    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    // Suscribirse a un tópico
    await _messaging.subscribeToTopic('bec_alerta_general');

    // // Manejo de mensajes en primer plano
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (kDebugMode) {
    //     print('Received a message: ${message.messageId}');
    //   }
    //   // Aquí puedes manejar el mensaje como desees.
    // });

    // En la clase FCMService

    // Manejo de mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received a message: ${message.messageId}');
        if (message.notification != null) {
          print('Message title: ${message.notification!.title}');
          print('Message body: ${message.notification!.body}');
        }
        if (message.data.isNotEmpty) {
          print('Message data: ${message.data}');
        }
      }
      // Aquí puedes manejar el mensaje como desees.
    });
  }
}
