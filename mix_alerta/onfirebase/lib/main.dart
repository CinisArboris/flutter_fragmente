import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onfirebase/my_home_page.dart';
import 'fcm_service.dart';
import 'firebase_options.dart';

// Función de manejo de mensajes en segundo plano
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('devLog: Handling a background message: ${message.messageId}');
    print('devLog: Message data: ${message.data}');
    if (message.notification != null) {
      print('devLog: Message title: ${message.notification!.title}');
      print('devLog: Message body: ${message.notification!.body}');
    }
  }
}

void main() async {
  /* ======================================================================== */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FCMService fcmService = FCMService();
  await fcmService.initFCM();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  /* ======================================================================== */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
