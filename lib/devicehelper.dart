import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  final String deviceId;
  final String deviceName;

  DeviceInfo({
    required this.deviceId,
    required this.deviceName,
  });
}

class DeviceHelper {
  // Generate SHA256 hash
  static String _generateHash(String input) {
    const String salt = "LICENSE_PROJECT_SECRET_2026";

    final bytes = utf8.encode(input + salt);

    return sha256.convert(bytes).toString();
  }

  static Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    String rawId = "unknown_id";
    String deviceName = "Unknown Device";

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;

        // Android unique identifier
        rawId = androidInfo.id;

        deviceName = "${androidInfo.brand} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;

        rawId = iosInfo.identifierForVendor ?? "unknown_ios_id";

        deviceName = "${iosInfo.name} ${iosInfo.model}";
      }
    } catch (e) {
      print("Error getting device info: $e");
    }

    final hashedId = _generateHash(rawId);

    return DeviceInfo(
      deviceId: hashedId,
      deviceName: deviceName,
    );
  }
}

// import 'dart:io';
// import 'dart:convert'; // ضروري لعملية التشفير
// import 'package:crypto/crypto.dart'; // مكتبة التشفير
// import 'package:device_info_plus/device_info_plus.dart';
// // import 'package:android_id/android_id.dart';

// class DeviceInfo {
//   final String deviceId;
//   final String deviceName;

//   DeviceInfo({required this.deviceId, required this.deviceName});
// }

// class DeviceHelper {
//   // 1️⃣ دالة التشفير (تستقبل النص وترجعه مشفراً)
//   static String _generateHash(String input) {
//     // نستخدم "Salt" وهو نص سري تضفيه أنت لزيادة الأمان
//     const String salt = "LICENSE_PROJECT_SECRET_2026";
//     var bytes = utf8.encode(input + salt); // تحويل النص لبايتات
//     return sha256.convert(bytes).toString(); // تشفير SHA-256
//   }

//   static Future<DeviceInfo> getDeviceInfo() async {
//     final deviceInfoPlugin = DeviceInfoPlugin();
//     String rawId = "unknown_id";
//     String deviceName = "Unknown Device";

//     try {
//       if (Platform.isAndroid) {
//         // الحصول على الـ ID الحقيقي الذي نجحت في جلبه سابقاً
//         const androidIdPlugin = AndroidId();
//         final String? androidId = await androidIdPlugin.getId();

//         final androidInfo = await deviceInfoPlugin.androidInfo;

//         rawId = androidId ?? androidInfo.fingerprint;
//         deviceName = "${androidInfo.name} (${androidInfo.model})";
//       }
//     } catch (e) {
//       print("Error getting device info: $e");
//     }

//     // 2️⃣ هنا نقوم بتشفير الـ ID قبل إرجاعه
//     String hashedId = _generateHash(rawId);

//     return DeviceInfo(deviceId: hashedId, deviceName: deviceName);
//   }
// }
