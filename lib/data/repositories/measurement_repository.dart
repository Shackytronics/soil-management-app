import 'dart:convert';
import 'dart:math';

import '../local/hive_service.dart';
import '../models/measurement_model.dart';
import '../models/sync_queue_model.dart';

class MeasurementRepository {
  static String _newId() =>
      '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

  List<MeasurementModel> getAllMeasurements(String userId) {
    return HiveService.measurements.values
        .where((m) => m.userId == userId)
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  List<MeasurementModel> getForPlot(String plotId) {
    return HiveService.measurements.values
        .where((m) => m.plotId == plotId)
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  MeasurementModel? getById(String id) => HiveService.measurements.get(id);

  Future<MeasurementModel> saveMeasurement({
    required String userId,
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
    final m = MeasurementModel(
      id: _newId(),
      plotId: plotId,
      plotName: plotName,
      userId: userId,
      nitrogen: nitrogen,
      phosphorus: phosphorus,
      potassium: potassium,
      ph: ph,
      moisture: moisture,
      temperature: temperature,
      ec: ec,
      recordedAt: DateTime.now(),
      notes: notes,
    );

    await HiveService.measurements.put(m.id, m);
    await _enqueue(
      m.id,
      'measurements',
      'create',
      jsonEncode(m.toFirestoreMap()),
    );
    return m;
  }

  Future<MeasurementModel> updateMeasurement(MeasurementModel updated) async {
    await HiveService.measurements.put(updated.id, updated);
    await _enqueue(
      updated.id,
      'measurements',
      'update',
      jsonEncode(updated.toFirestoreMap()),
    );
    return updated;
  }

  Future<void> deleteMeasurement(String id) async {
    await HiveService.measurements.delete(id);
    await _enqueue(id, 'measurements', 'delete', null);
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
