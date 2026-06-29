import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/measurement_model.dart';
import '../data/repositories/measurement_repository.dart';
import 'recommendation_provider.dart';
import 'sync_status_provider.dart';

class MeasurementProvider extends ChangeNotifier {
  final _repo = MeasurementRepository();
  final SyncStatusProvider _syncStatus;
  final RecommendationProvider _recommendations;

  List<MeasurementModel> _measurements = [];
  bool _isLoading = false;
  String? _filterPlotId;
  DateTimeRange? _filterDateRange;
  String _searchQuery = '';

  bool _wasOnline = false;

  MeasurementProvider(this._syncStatus, this._recommendations) {
    _wasOnline = _syncStatus.isOnline;
    _syncStatus.addListener(_onSyncStatusChanged);
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _load(user.uid);
      } else {
        _measurements = [];
        notifyListeners();
      }
    });
  }

  /// On the offline -> online transition, backfill advisories for any
  /// measurements saved while offline.
  void _onSyncStatusChanged() {
    final online = _syncStatus.isOnline;
    if (online && !_wasOnline && _measurements.isNotEmpty) {
      unawaited(_recommendations.generateMissingFor(_measurements));
    }
    _wasOnline = online;
  }

  @override
  void dispose() {
    _syncStatus.removeListener(_onSyncStatusChanged);
    super.dispose();
  }

  List<MeasurementModel> get measurements => _measurements;
  bool get isLoading => _isLoading;
  int get count => _measurements.length;
  String? get filterPlotId => _filterPlotId;
  DateTimeRange? get filterDateRange => _filterDateRange;
  String get searchQuery => _searchQuery;

  MeasurementModel? get latest =>
      _measurements.isEmpty ? null : _measurements.first;

  List<MeasurementModel> get recentFive => _measurements.take(5).toList();

  List<MeasurementModel> forPlot(String plotId) =>
      _measurements.where((m) => m.plotId == plotId).toList();

  List<MeasurementModel> get filtered {
    var list = _measurements;

    if (_filterPlotId != null) {
      list = list.where((m) => m.plotId == _filterPlotId).toList();
    }

    if (_filterDateRange != null) {
      list = list.where((m) {
        return m.recordedAt.isAfter(_filterDateRange!.start) &&
            m.recordedAt.isBefore(
              _filterDateRange!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((m) =>
              m.plotName.toLowerCase().contains(q) ||
              (m.notes?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return list;
  }

  /// Average values across all measurements for the current user.
  Map<String, double> get averages {
    if (_measurements.isEmpty) return {};
    final n = _measurements.length;
    return {
      'nitrogen':
          _measurements.map((m) => m.nitrogen).reduce((a, b) => a + b) / n,
      'phosphorus':
          _measurements.map((m) => m.phosphorus).reduce((a, b) => a + b) / n,
      'potassium':
          _measurements.map((m) => m.potassium).reduce((a, b) => a + b) / n,
      'ph': _measurements.map((m) => m.ph).reduce((a, b) => a + b) / n,
      'moisture':
          _measurements.map((m) => m.moisture).reduce((a, b) => a + b) / n,
      'temperature':
          _measurements.map((m) => m.temperature).reduce((a, b) => a + b) / n,
      'ec': _measurements.map((m) => m.ec).reduce((a, b) => a + b) / n,
    };
  }

  /// 0-100 health score based on how many parameters are in optimal range.
  double get healthScore {
    if (_measurements.isEmpty) return 0;
    final avg = averages;
    int score = 0;
    int total = 0;

    void check(String key, double low, double high) {
      final v = avg[key];
      if (v == null) return;
      total += 100;
      if (v >= low && v <= high) {
        score += 100;
      } else if (v >= low * 0.8 && v <= high * 1.2) {
        score += 60;
      } else {
        score += 20;
      }
    }

    check('nitrogen', 10, 30);
    check('phosphorus', 5, 30);
    check('potassium', 100, 300);
    check('ph', 6.0, 7.5);
    check('moisture', 40, 70);
    check('temperature', 15, 35);
    check('ec', 0.2, 1.0);

    return total == 0 ? 0 : (score / total) * 100;
  }

  // ── Chart data ───────────────────────────────────────────────────────────────

  /// Per-measurement health score for the last 14 readings (oldest→newest).
  List<({double x, double y, DateTime date})> get healthTrendPoints {
    if (_measurements.length < 2) return [];
    final data = _measurements.take(14).toList().reversed.toList();
    return data.asMap().entries.map((e) {
      return (x: e.key.toDouble(), y: _scoreForOne(e.value), date: e.value.recordedAt);
    }).toList();
  }

  double _scoreForOne(MeasurementModel m) {
    int score = 0;
    void check(double v, double low, double high) {
      if (v >= low && v <= high) {
        score += 100;
      } else if (v >= low * 0.8 && v <= high * 1.2) {
        score += 60;
      } else {
        score += 20;
      }
    }

    check(m.nitrogen, 10, 30);
    check(m.phosphorus, 5, 30);
    check(m.potassium, 100, 300);
    check(m.ph, 6.0, 7.5);
    check(m.moisture, 40, 70);
    check(m.temperature, 15, 35);
    check(m.ec, 0.2, 1.0);
    return score / 7.0;
  }

  /// Nutrient health scores (0–100) keyed by display label.
  Map<String, double> get nutrientScores {
    if (_measurements.isEmpty) return {};
    final avg = averages;
    double score(String key, double low, double high) {
      final v = avg[key] ?? 0;
      if (v >= low && v <= high) return 100;
      if (v >= low * 0.8 && v <= high * 1.2) return 60;
      return 20;
    }

    return {
      'N': score('nitrogen', 10, 30),
      'P': score('phosphorus', 5, 30),
      'K': score('potassium', 100, 300),
      'pH': score('ph', 6.0, 7.5),
      'H₂O': score('moisture', 40, 70),
      'Temp': score('temperature', 15, 35),
      'EC': score('ec', 0.2, 1.0),
    };
  }

  /// Measurement counts for the last 6 calendar months.
  Map<String, int> get monthlyCountData {
    final result = <String, int>{};
    final now = DateTime.now();
    for (var i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      result[_monthKey(month)] = 0;
    }
    for (final m in _measurements) {
      final key = _monthKey(m.recordedAt);
      if (result.containsKey(key)) result[key] = result[key]! + 1;
    }
    return result;
  }

  String _monthKey(DateTime dt) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${names[dt.month - 1]} ${dt.year.toString().substring(2)}';
  }

  // ─────────────────────────────────────────────────────────────────────────────

  void setFilterPlot(String? plotId) {
    _filterPlotId = plotId;
    notifyListeners();
  }

  void setFilterDateRange(DateTimeRange? range) {
    _filterDateRange = range;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void clearFilters() {
    _filterPlotId = null;
    _filterDateRange = null;
    _searchQuery = '';
    notifyListeners();
  }

  void _load(String userId) {
    _isLoading = true;
    notifyListeners();
    _measurements = _repo.getAllMeasurements(userId);
    _isLoading = false;
    notifyListeners();
    // Backfill any advisories missing for already-saved measurements
    // (e.g. saved on a previous offline session). No-ops when offline.
    if (_measurements.isNotEmpty) {
      unawaited(_recommendations.generateMissingFor(_measurements));
    }
  }

  void refresh() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) _load(user.uid);
  }

  Future<MeasurementModel> addMeasurement({
    required String plotId,
    required String plotName,
    required double nitrogen,
    required double phosphorus,
    required double potassium,
    required double ph,
    required double moisture,
    required double temperature,
    required double ec,
    String? notes,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final m = await _repo.saveMeasurement(
      userId: userId,
      plotId: plotId,
      plotName: plotName,
      nitrogen: nitrogen,
      phosphorus: phosphorus,
      potassium: potassium,
      ph: ph,
      moisture: moisture,
      temperature: temperature,
      ec: ec,
      notes: notes,
    );
    _measurements = _repo.getAllMeasurements(userId);
    notifyListeners();
    _syncStatus.onDataWritten();

    // Request a rule-based soil-management advisory from Django. Fire-and-forget
    // so saving the measurement is never blocked by network latency; the
    // RecommendationProvider manages its own loading/error state.
    unawaited(_recommendations.generateForMeasurement(m));
    return m;
  }

  Future<void> updateMeasurement(MeasurementModel updated) async {
    await _repo.updateMeasurement(updated);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _measurements = _repo.getAllMeasurements(userId);
    notifyListeners();
    _syncStatus.onDataWritten();
  }

  Future<void> deleteMeasurement(String id) async {
    await _repo.deleteMeasurement(id);
    _measurements.removeWhere((m) => m.id == id);
    notifyListeners();
    // Cascade: remove any advisory generated for this measurement.
    await _recommendations.deleteForMeasurement(id);
    _syncStatus.onDataWritten();
  }
}
