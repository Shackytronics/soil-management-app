import 'package:flutter/foundation.dart';

import '../core/constants/api_config.dart';
import '../services/api/django_api_service.dart';

enum BackendConnectivity { unknown, checking, online, offline }

/// Tracks reachability of the Django backend via `GET /api/v1/status/`.
/// Checked on app startup and surfaced in Settings.
class BackendStatusProvider extends ChangeNotifier {
  BackendStatusProvider({DjangoApiService? api})
      : _api = api ?? DjangoApiService();

  final DjangoApiService _api;

  BackendConnectivity _state = BackendConnectivity.unknown;
  String? _apiVersion;
  String? _rulesetVersion;
  bool _firebaseReady = false;
  DateTime? _lastChecked;

  BackendConnectivity get state => _state;
  bool get isOnline => _state == BackendConnectivity.online;
  bool get isChecking => _state == BackendConnectivity.checking;
  String? get apiVersion => _apiVersion;
  String? get rulesetVersion => _rulesetVersion;
  bool get firebaseReady => _firebaseReady;
  DateTime? get lastChecked => _lastChecked;

  /// The configured environment label (Development / Production / Custom).
  String get environment => ApiConfig.environment;

  /// The resolved backend base URL.
  String get baseUrl => ApiConfig.baseUrl;

  /// Probes the backend status endpoint. Safe to call repeatedly.
  Future<void> check() async {
    if (_state == BackendConnectivity.checking) return;
    _state = BackendConnectivity.checking;
    notifyListeners();

    try {
      final status = await _api.fetchStatus();
      _apiVersion = status.apiVersion;
      _rulesetVersion = status.rulesetVersion;
      _firebaseReady = status.firebaseReady;
      _state = BackendConnectivity.online;
    } catch (_) {
      _state = BackendConnectivity.offline;
    } finally {
      _lastChecked = DateTime.now();
      notifyListeners();
    }
  }
}
