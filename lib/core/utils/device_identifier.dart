import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import '../storage/preference_keys.dart';
import '../storage/secure_storage.dart';
import 'logger.dart';

class DeviceIdentifier {
  SecurePreference  pref = SecurePreference();

  static Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> getDeviceInfo() async {
    String ? deviceId = await pref.getString(Keys.deviceId);
    if (deviceId == null) {
      deviceId = await DeviceIdentifier.getDeviceId();
      if (deviceId != null) {
        await pref.setString(Keys.deviceId, deviceId);
      }
    }
    debugLog(deviceId.toString(), name: "Device Id");
  }

}
