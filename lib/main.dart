import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/utils/logger.dart';

import 'core/config/resource/service_ids.dart';
import 'core/config/route/app_route.dart';
import 'core/services/firebase_background_handler.dart';
import 'core/services/notification_service.dart';
import 'core/storage/secure_storage.dart';
import 'core/utils/device_identifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // Initialize push notification service
  await FirebasePushService.initialize();
  debugLog(FirebasePushService.fcmToken.toString(),name: "fcm token");
  //
  SecurePreference();
  ServiceIds.load();
  runApp(const MyApp());
}
// void getDeviceInfo() async {
//   final deviceId = await DeviceIdentifier.getDeviceId();
//
//   debugLog(deviceId.toString(),name: "Device Id");
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title:'TREE-LOVE',
        builder: EasyLoading.init(

        ),
        debugShowCheckedModeBanner:false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        initialRoute: '/',
        onGenerateRoute: AppRoute().onGenerateRoute,
      ),
    );
  }
}
