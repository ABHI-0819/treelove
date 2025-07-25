import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/utils/logger.dart';

import 'core/config/resource/service_ids.dart';
import 'core/config/route/app_route.dart';
import 'core/storage/secure_storage.dart';
import 'core/utils/device_identifier.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SecurePreference();
  // getDeviceInfo();
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
        builder: EasyLoading.init(),
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
