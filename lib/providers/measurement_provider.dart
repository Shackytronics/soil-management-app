import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/measurement_model.dart';
import '../data/repositories/measurement_repository.dart';

class MeasurementProvider extends ChangeNotifier {
  final _repo = MeasurementRepository();

  List<MeasurementModel> _measurements = [];
  bool _isLoading = false;
  String? _filterPlotId;
  DateTimeRange? _filterDateRange;
  String _searchQuery = '';

  MeasurementProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _load(user.uid);
      } else {
        _measurements = [];
        notifyListeners();
      }
    });
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
    return m;
  }

  Future<void> updateMeasurement(MeasurementModel updated) async {
    await _repo.updateMeasurement(updated);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _measurements = _repo.getAllMeasurements(userId);
    notifyListeners();
  }

  Future<void> deleteMeasurement(String id) async {
    await _repo.deleteMeasurement(id);
    _measurements.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
