

import 'package:coffeshop_flutter/welcomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyA4BShJXnJGi674MmFUmfj8aRNziFZIOf0",
        projectId: "etisal-7fc84",
        messagingSenderId: "538392901308",
        appId: "1:538392901308:android:f55693ee54a7812d4842b9",
      ));

  await  FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.getToken().then((value) => print("FCM Token is $value"));

  // final _firebaseMessaging = FirebaseMessaging.instance;
  // await _firebaseMessaging.requestPermission();
  //
  // String? fcmToken = await _firebaseMessaging.getToken();
  //
  // print(fcmToken.toString());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Welcomepage(),
      )
  );}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message title: ${message.notification?.title}");
  print("Handling a background message body: ${message.notification?.body}");
}