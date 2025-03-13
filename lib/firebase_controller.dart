import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/login_screen/controller/login_controller.dart';
import 'package:track_route_pro/routes/app_pages.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/ic_notif');

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // debugPrint('Handling a background message: ${message.messageId}');
  // log("android key =====> ${message.notification?.android?.sound}");
  String alert = message.notification?.title != "Out of Area!" ? 'message_alert'  : 'danger_alert';

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'high_importance_channel',
    'track_route_pro_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    icon: "@drawable/ic_notif",
    playSound: true,
    // sound: RawResourceAndroidNotificationSound(alert),
  );

  // log("ANDROID ===> ${androidPlatformChannelSpecifics.sound?.sound}");
  var platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  // log("ANDROID PLATFORM ===> ${platformChannelSpecifics.android?.sound?.sound}");
  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch % 2147483647,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}
class FirebaseNotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    // _initializeFirebaseMessaging();
  }

  void init() {
    _initializeFirebaseMessaging();
  }

/*  Future<void> _initializeFirebaseMessaging() async {
    // Register the background handler inside the controller
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }*/

  /*static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle the background message
    debugPrint('Handling a background message: ${message.messageId}');
    // Perform your background message processing logic here, such as showing a notification
    // For example:
    showMessage(message.notification?.title ?? "No Title");
  }*/
/*  Future<FirebaseNotificationService> init() async {
    debugPrint("INIT");

    await _initializeFirebaseMessaging();
    debugPrint("DONE FIREBASE INIT");
    return this;
  }*/

  // get token
  Future<String?> getFcmToken() async {
    final token = await _firebaseMessaging.getToken();
    // debugPrint('_firebaseMessaging_Token: $token');
    if (token != null) {
      await AppPreference.addStringToSF(Constants.fcmToken, token);
      // Get.put(LoginController()).sendTokenData();
    }
    return token;
  }

  //refresh token

  Future<String?> refreshFcmToken() async {
    _firebaseMessaging.onTokenRefresh.listen((token) async {
      await AppPreference.addStringToSF(Constants.fcmToken, token);
      Get.put(LoginController()).sendTokenData();
    });
    return null;
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request permissions for iOS
    final settings = await _firebaseMessaging.requestPermission();
    // debugPrint('User granted permission: ${settings.authorizationStatus}');

    // debugPrint("INIT");
    // Get the token
    token = await _firebaseMessaging.getToken();

    if (token != null) {
      // debugPrint('FirebaseMessaging token: $token');
      await AppPreference.addStringToSF(Constants.fcmToken, token ?? "");
      Get.put(LoginController()).sendTokenData();
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     /* debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');*/

      if (message.notification != null) {
      /*  debugPrint(
          'Message also contained a notification: ${message.notification?.title}',
        );*/
        _showNotification(message.notification);

        /* // Add the notification to the NotificationController
        Get.put<NotificationController>(NotificationController())
            .addNotification(message.notification!);*/
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationClick(initialMessage);
    }

    await initMessaging();
  }


  void _handleNotificationClick(RemoteMessage message) {
      checkTokenAndNavigate();
  }

  void checkTokenAndNavigate() async {
    // Delay for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check if the API token exists in AppPreference
    String? apiToken = await AppPreference.getStringFromSF(AppPreference.accessTokenKey);
    // debugPrint("API TOKEN ========> $apiToken");
    if (apiToken != null && apiToken.isNotEmpty) {
      // If token exists, navigate to BottomBar

      Get.offNamed(Routes.BOTTOMBAR);
      final bottomController = Get.isRegistered<BottomBarController>()
          ? Get.find<BottomBarController>() // Find if already registered
          : Get.put(BottomBarController());
      bottomController.updateIndex(1);
    } else {
      // If token doesn't exist, navigate to LoginScreen
      Get.offNamed(Routes.LOGIN);
    }
    // Get.put(LoginController()).fetchSplashData();
  }

  Future<void> initMessaging() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission();
    }
    await Permission.notification.request();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notif');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //
  }

  Future<void> _showNotification(RemoteNotification? notification) async {
    if (notification != null) {
      // log("android key =====> ${notification.android?.sound}");
       String alert = notification.title != "Out of Area!"? 'message_alert'  : 'danger_alert';

        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'high_importance_channel',
          'track_route_pro_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: "@drawable/ic_notif",
          playSound: true,
          // sound: RawResourceAndroidNotificationSound(alert),
        );

      // log("ANDROID ===> ${androidPlatformChannelSpecifics.sound?.sound}");
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // log("ANDROID PLATFORM ===> ${platformChannelSpecifics.android?.sound?.sound}");
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch % 2147483647,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: 'item x',
      );
    }
  }



/*
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message,
      ) async {

    debugPrint('Handling a background message: ${message.messageId}');
      showMessage(  message.notification?.title ?? "");
  */ /*  await AppNotification.showBigTextNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      fln: FlutterLocalNotificationsPlugin(),
    );*/ /*
  }*/
}
