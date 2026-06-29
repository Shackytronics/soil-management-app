import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/measurement_model.dart';
import '../data/models/recommendation_model.dart';
import '../data/repositories/recommendation_repository.dart';
import '../services/api/django_api_service.dart';
import 'sync_status_provider.dart';

/// UI-facing advisory error categories. The UI maps these to localized text so
/// messages can be shown in the user's selected language.
enum AdvisoryError { offline, unauthorized, server, badResponse, unknown }

/// Exposes rule-based soil-management advisories to the UI. Loads cached
/// advisories from Hive on auth, and generates fresh ones via Django on demand.
class RecommendationProvider extends ChangeNotifier {
  RecommendationProvider(this._syncStatus) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _userId = user.uid;
        _load(user.uid);
      } else {
        _userId = null;
        _items = [];
        notifyListeners();
      }
    });
  }

  final _repo = RecommendationRepository();
  final SyncStatusProvider _syncStatus;

  List<RecommendationModel> _items = [];
  bool _isGenerating = false;
  bool _isBackfilling = false;
  String? _generatingMeasurementId;
  AdvisoryError? _error;
  String? _userId;

  List<RecommendationModel> get all => _items;
  bool get isGenerating => _isGenerating;
  AdvisoryError? get error => _error;

  /// True while an advisory is being generated for a specific measurement.
  bool isGeneratingFor(String measurementId) =>
      _isGenerating && _generatingMeasurementId == measurementId;

  RecommendationModel? get latest => _items.isEmpty ? null : _items.first;

  RecommendationModel? forMeasurement(String measurementId) =>
      _repo.getForMeasurement(measurementId);

  List<RecommendationModel> forPlot(String plotId) =>
      _items.where((r) => r.plotId == plotId).toList();

  bool hasFor(String measurementId) => forMeasurement(measurementId) != null;

  void _load(String userId) {
    _items = _repo.getAll(userId);
    notifyListeners();
  }

  void refresh() {
    final uid = _userId;
    if (uid != null) _load(uid);
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  /// Requests (or re-requests) an advisory from Django for [m].
  ///
  /// Offline-first: when there is no connectivity we do NOT call Django. The
  /// cached Hive advisory (if any) remains available, and the missing advisory
  /// is generated automatically once connectivity returns (see
  /// [generateMissingFor]). On success the advisory is cached in Hive and
  /// queued for Firestore sync exactly as before.
  Future<RecommendationModel?> generateForMeasurement(MeasurementModel m) async {
    if (!_syncStatus.isOnline) {
      _error = AdvisoryError.offline;
      notifyListeners();
      return null;
    }

    _isGenerating = true;
    _generatingMeasurementId = m.id;
    _error = null;
    notifyListeners();

    RecommendationModel? rec;
    try {
      rec = await _repo.generateAndSave(m);
      refresh();
      _syncStatus.onDataWritten();
    } on ApiException catch (e) {
      _error = _mapError(e);
    } catch (_) {
      _error = AdvisoryError.unknown;
    } finally {
      _isGenerating = false;
      _generatingMeasurementId = null;
      notifyListeners();
    }
    return rec;
  }

  /// Generates advisories for any measurements that don't yet have one.
  /// Called on reconnect and after the initial load so that readings saved
  /// while offline receive their advisory automatically. No-ops when offline.
  /// Never creates duplicates (skips measurements that already have a cached
  /// advisory; [generateAndSave] also replaces any existing one).
  Future<void> generateMissingFor(List<MeasurementModel> measurements) async {
    if (!_syncStatus.isOnline || _isBackfilling) return;
    _isBackfilling = true;
    try {
      for (final m in measurements) {
        if (!_syncStatus.isOnline) break;
        if (_repo.getForMeasurement(m.id) == null) {
          await generateForMeasurement(m);
        }
      }
    } finally {
      _isBackfilling = false;
    }
  }

  /// Removes advisories for a deleted measurement and refreshes state.
  Future<void> deleteForMeasurement(String measurementId) async {
    await _repo.deleteForMeasurement(measurementId);
    refresh();
    _syncStatus.onDataWritten();
  }

  AdvisoryError _mapError(ApiException e) {
    switch (e.type) {
      case ApiErrorType.offline:
      case ApiErrorType.timeout:
        return AdvisoryError.offline;
      case ApiErrorType.unauthorized:
        return AdvisoryError.unauthorized;
      case ApiErrorType.server:
        return AdvisoryError.server;
      case ApiErrorType.badResponse:
        return AdvisoryError.badResponse;
      case ApiErrorType.unknown:
        return AdvisoryError.unknown;
    }
  }
}
