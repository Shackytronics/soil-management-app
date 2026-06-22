import 'dart:convert';
import 'dart:math';

import '../local/hive_service.dart';
import '../models/plot_model.dart';
import '../models/sync_queue_model.dart';

class PlotRepository {
  static String _newId() =>
      '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

  List<PlotModel> getAllPlots(String userId) {
    final plots = HiveService.plots.values
        .where((p) => p.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return plots;
  }

  PlotModel? getById(String id) => HiveService.plots.get(id);

  Future<PlotModel> savePlot({
    required String userId,
    required String name,
    required String location,
    required double sizeAcres,
    required String description,
    required String cropType,
  }) async {
    final plot = PlotModel(
      id: _newId(),
      name: name,
      location: location,
      sizeAcres: sizeAcres,
      description: description,
      cropType: cropType,
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await HiveService.plots.put(plot.id, plot);
    await _enqueue(plot.id, 'plots', 'create', jsonEncode(plot.toFirestoreMap()));
    return plot;
  }

  Future<PlotModel> updatePlot(PlotModel updated) async {
    final plot = updated.copyWith();
    await HiveService.plots.put(plot.id, plot);
    await _enqueue(plot.id, 'plots', 'update', jsonEncode(plot.toFirestoreMap()));
    return plot;
  }

  Future<void> deletePlot(String id) async {
    await HiveService.plots.delete(id);
    await _enqueue(id, 'plots', 'delete', null);
  }

  Future<void> _enqueue(
    String id,
    String collection,
    String operation,
    String? dataJson,
  ) async {
    await HiveService.syncQueue.put(
      '${collection}_${operation}_$id',
      SyncQueueModel(
        id: '${collection}_${operation}_$id',
        collection: collection,
        documentId: id,
        operation: operation,
        dataJson: dataJson,
        queuedAt: DateTime.now(),
      ),
    );
  }
}
