import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // إنشاء نسخة واحدة ثابتة مع إعدادات الأمان للأندرويد
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // تفعيل تشفير الملفات في أندرويد
    ),
  );

  // حفظ مفتاح المستخدم
  static Future<void> saveUserKey(String key) async {
    await _storage.write(key: 'license_key', value: key);
  }

  // جلب مفتاح المستخدم
  static Future<String?> getUserKey() async {
    return await _storage.read(key: 'license_key');
  }

  // حذف البيانات عند الحاجة (مثلاً عند عمل Reset للتطبيق)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
