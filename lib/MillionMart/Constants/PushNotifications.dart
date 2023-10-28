import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartChatScreen.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      // _fcm.requestNotificationPermissions(IosNotificationSettings());
      _fcm.requestPermission();
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    Constants.token = await _fcm.getToken();
    print("FirebaseMessaging token: ${Constants.token}");

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('getInitialMessage data: ${message.data}');
      }
    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Get.to(ChatScreen());
      Get.snackbar(
          "${message.notification!.title}", "${message.notification!.body}",backgroundColor: notificationBackground,colorText: notificationTextColor,);
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("${message.data["screen"]}");
      Get.toNamed("/${message.data["screen"]}");
    });
  }
}
