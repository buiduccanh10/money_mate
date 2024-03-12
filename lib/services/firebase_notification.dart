// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseNotification {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     print(message.notification?.title);
//   }

//   Future<void> requestNotificationPermission() async {
//     await messaging.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: true,
//         provisional: false,
//         criticalAlert: true,
//         sound: true);

//     final token = await messaging.getToken();
//     print('Token: ${token}');

//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     //   print('User granted permission');
//     // } else if (settings.authorizationStatus ==
//     //     AuthorizationStatus.provisional) {
//     //   print('User granted provisional permission');
//     // } else {
//     //   print('User declined or has not accepted permission');
//     // }
//   }
// }
