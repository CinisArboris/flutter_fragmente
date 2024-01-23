import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Solicita permisos para iOS
    NotificationSettings settings = await _messaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    // Suscribirse a un tópico
    await _messaging.subscribeToTopic('bec_alerta_general');

    // Manejo de mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message: ${message.messageId}');
      // Aquí puedes manejar el mensaje como desees.
    });
  }
}
