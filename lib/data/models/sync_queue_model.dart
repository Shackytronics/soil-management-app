import 'package:hive/hive.dart';

part 'sync_queue_model.g.dart';

@HiveType(typeId: 3)
class SyncQueueModel extends HiveObject {
  @HiveField(0)
  late String id;

  /// Firestore collection: 'plots' | 'measurements'
  @HiveField(1)
  late String collection;

  @HiveField(2)
  late String documentId;

  /// 'create' | 'update' | 'delete'
  @HiveField(3)
  late String operation;

  /// JSON-encoded document data (null for deletes)
  @HiveField(4)
  String? dataJson;

  @HiveField(5)
  late DateTime queuedAt;

  @HiveField(6)
  late int retryCount;

  SyncQueueModel({
    required this.id,
    required this.collection,
    required this.documentId,
    required this.operation,
    this.dataJson,
    required this.queuedAt,
    this.retryCount = 0,
  });
}
