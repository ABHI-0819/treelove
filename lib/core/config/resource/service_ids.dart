import '../../../common/repositories/service_repository.dart';
import '../../network/api_connection.dart';
import '../../storage/preference_keys.dart';
import '../../storage/secure_storage.dart';

class ServiceIds {
  ServiceIds._(); // Prevent instantiation


  // ✅ In-memory cache
  static String? _plantationId;
  static String? _maintenanceId;
  static String? _monitoringId;

  /// ✅ Load IDs from SecurePreference into memory
  static Future<void> load() async {
    final pref = SecurePreference();
    final repo = ServicesRepository(api: ApiConnection());
    await repo.cacheServiceIds();
    _plantationId = await pref.getString(Keys.plantationServiceId);
    _maintenanceId = await pref.getString(Keys.maintenanceServiceId);
    _monitoringId = await pref.getString(Keys.monitoringServiceId);
  }

  /// ✅ Public getters (only get, no set)
  static String? get plantationId => _plantationId;
  static String? get maintenanceId => _maintenanceId;
  static String? get monitoringId => _monitoringId;

  /// ✅ Check if already cached (so we don’t reload unnecessarily)
  static bool get isInitialized =>
      _plantationId != null &&
          _maintenanceId != null &&
          _monitoringId != null;

  /// ✅ Helper to get all in one map
  static Map<String, String?> get all => {
    "plantation": _plantationId,
    "maintenance": _maintenanceId,
    "monitoring": _monitoringId,
  };

  /// ✅ (Optional) Ensure loaded before use → lazy load
  static Future<void> ensureLoaded() async {
    if (!isInitialized) {
      await load();
    }
  }
}

