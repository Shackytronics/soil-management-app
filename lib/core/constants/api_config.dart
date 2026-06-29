/// Configuration for the Django REST API backend.
///
/// Django is the backend REST API (NOT a database). It hosts the Rule-Based
/// Soil Management Engine.
///
/// Base URL resolution (highest priority first):
///   1. `--dart-define=SOIL_API_BASE_URL=https://...` (explicit override)
///   2. Release build  -> [prodBaseUrl]
///   3. Debug build     -> [devBaseUrl] (`10.0.2.2:8000` = Android emulator's
///      alias for the host machine's localhost, where the dev server runs)
class ApiConfig {
  ApiConfig._();

  /// Explicit override supplied at build/run time.
  static const String _override = String.fromEnvironment(
    'SOIL_API_BASE_URL',
    defaultValue: '',
  );

  /// True for `flutter run --release` / production builds.
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  /// Local development backend.
  ///
  /// This is the dev machine's LAN IP so a *physical* device on the same Wi-Fi
  /// can reach the Django server (the Android emulator alias `10.0.2.2` only
  /// works inside the emulator). If your PC's IP changes, update this or pass
  /// `--dart-define=SOIL_API_BASE_URL=http://<new-ip>:8000` at run time.
  static const String devBaseUrl = 'http://192.168.72.70:8000';

  /// Production backend. Override with --dart-define for the real host.
  static const String prodBaseUrl = 'https://api.soilmanagement.app';

  /// Resolved base URL of the Django backend, without a trailing slash.
  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    return isProduction ? prodBaseUrl : devBaseUrl;
  }

  /// Human-readable environment label (for diagnostics / settings).
  static String get environment {
    if (_override.isNotEmpty) return 'Custom';
    return isProduction ? 'Production' : 'Development';
  }

  // ── Endpoints (all versioned under /api/v1/) ───────────────────────────────
  static const String soilManagementPath = '/api/v1/soil-management/';
  static const String statusPath = '/api/v1/status/';

  /// Timeout for advisory generation (rule engine round-trip).
  static const Duration requestTimeout = Duration(seconds: 20);

  /// Shorter timeout for the lightweight connectivity probe.
  static const Duration statusTimeout = Duration(seconds: 8);

  static Uri soilManagementUri() => Uri.parse('$baseUrl$soilManagementPath');
  static Uri statusUri() => Uri.parse('$baseUrl$statusPath');
}
