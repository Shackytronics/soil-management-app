import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/plot_model.dart';
import '../data/repositories/plot_repository.dart';

class PlotProvider extends ChangeNotifier {
  final _repo = PlotRepository();

  List<PlotModel> _plots = [];
  bool _isLoading = false;
  String _searchQuery = '';

  PlotProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _load(user.uid);
      } else {
        _plots = [];
        notifyListeners();
      }
    });
  }

  List<PlotModel> get plots => _plots;
  bool get isLoading => _isLoading;
  int get count => _plots.length;
  String get searchQuery => _searchQuery;

  List<PlotModel> get filtered {
    if (_searchQuery.isEmpty) return _plots;
    final q = _searchQuery.toLowerCase();
    return _plots
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q) ||
            p.cropType.toLowerCase().contains(q))
        .toList();
  }

  PlotModel? getById(String id) {
    try {
      return _plots.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void _load(String userId) {
    _isLoading = true;
    notifyListeners();
    _plots = _repo.getAllPlots(userId);
    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) _load(user.uid);
  }

  Future<PlotModel> addPlot({
    required String name,
    required String location,
    required double sizeAcres,
    required String description,
    required String cropType,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final plot = await _repo.savePlot(
      userId: userId,
      name: name,
      location: location,
      sizeAcres: sizeAcres,
      description: description,
      cropType: cropType,
    );
    _plots = _repo.getAllPlots(userId);
    notifyListeners();
    return plot;
  }

  Future<void> updatePlot(PlotModel plot) async {
    await _repo.updatePlot(plot);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _plots = _repo.getAllPlots(userId);
    notifyListeners();
  }

  Future<void> deletePlot(String plotId) async {
    await _repo.deletePlot(plotId);
    _plots.removeWhere((p) => p.id == plotId);
    notifyListeners();
  }
}
