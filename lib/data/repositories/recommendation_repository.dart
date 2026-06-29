import 'dart:convert';
import 'dart:math';

import '../../services/api/django_api_service.dart';
import '../local/hive_service.dart';
import '../models/measurement_model.dart';
import '../models/recommendation_model.dart';
import '../models/sync_queue_model.dart';

/// Persists soil-management advisories (offline-first) and orchestrates
/// generation through the Django Rule-Based Soil Management Engine.
///
/// Flow: Measurement -> DjangoApiService -> RecommendationModel -> Hive
///       -> Sync Queue -> Firestore (users/{uid}/recommendations).
class RecommendationRepository {
  RecommendationRepository({DjangoApiService? api})
      : _api = api ?? DjangoApiService();

  final DjangoApiService _api;

  static String _newId() =>
      '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

  List<RecommendationModel> getAll(String userId) {
    return HiveService.recommendations.values
        .where((r) => r.userId == userId)
        .toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
  }

  List<RecommendationModel> getForPlot(String plotId) {
    return HiveService.recommendations.values
        .where((r) => r.plotId == plotId)
        .toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
  }

  /// The most recent advisory for a given measurement, if any.
  RecommendationModel? getForMeasurement(String measurementId) {
    final matches = HiveService.recommendations.values
        .where((r) => r.measurementId == measurementId)
        .toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    return matches.isEmpty ? null : matches.first;
  }

  RecommendationModel? getById(String id) =>
      HiveService.recommendations.get(id);

  /// Requests a fresh advisory from Django for [m], stores it in Hive and
  /// queues a Firestore sync. Replaces any previous advisory for the same
  /// measurement so there is exactly one current advisory per reading.
  ///
  /// Throws [ApiException] if Django is unreachable or returns an error.
  Future<RecommendationModel> generateAndSave(MeasurementModel m) async {
    final result = await _api.fetchSoilManagement(m);

    await _deleteForMeasurement(m.id);

    final rec = RecommendationModel(
      id: _newId(),
      plotId: m.plotId,
      plotName: m.plotName,
      measurementId: m.id,
      userId: m.userId,
      soilHealthScore: result.soilHealthScore,
      soilHealth: result.soilHealth,
      overallStatus: result.overallStatus,
      recommendations: result.recommendations,
      generatedAt: result.generatedAt,
      source: 'django',
      isSynced: false,
    );

    await HiveService.recommendations.put(rec.id, rec);
    await _enqueue(rec.id, 'create', jsonEncode(rec.toFirestoreMap()));
    return rec;
  }

  /// Cascade delete — removes advisories tied to a measurement (used when the
  /// parent measurement is deleted) and queues Firestore deletes.
  Future<void> deleteForMeasurement(String measurementId) async {
    await _deleteForMeasurement(measurementId);
  }

  Future<void> _deleteForMeasurement(String measurementId) async {
    final matches = HiveService.recommendations.values
        .where((r) => r.measurementId == measurementId)
        .toList();
    for (final r in matches) {
      await HiveService.recommendations.delete(r.id);
      await _enqueue(r.id, 'delete', null);
    }
  }

  Future<void> _enqueue(
    String id,
    String operation,
    String? dataJson,
  ) async {
    const collection = 'recommendations';
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
