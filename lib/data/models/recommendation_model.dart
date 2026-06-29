import 'package:hive/hive.dart';

part 'recommendation_model.g.dart';

/// A single rule-based advisory item returned by the Django Soil Management
/// Engine. Stored as a structured object (NOT a plain string).
@HiveType(typeId: 5)
class RecommendationItem {
  @HiveField(0)
  late String category;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  /// 'High' | 'Medium' | 'Low'
  @HiveField(3)
  late String priority;

  /// Logical icon name (e.g. 'compost', 'water', 'lime'). Mapped to an
  /// IconData in the UI layer.
  @HiveField(4)
  late String icon;

  RecommendationItem({
    required this.category,
    required this.title,
    required this.description,
    required this.priority,
    required this.icon,
  });

  Map<String, dynamic> toMap() => {
        'category': category,
        'title': title,
        'description': description,
        'priority': priority,
        'icon': icon,
      };

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      category: (json['category'] ?? 'General').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      priority: (json['priority'] ?? 'Medium').toString(),
      icon: (json['icon'] ?? 'eco').toString(),
    );
  }
}

/// A full soil-management advisory generated for one measurement.
/// Persisted in Hive (offline-first) and synced to Firestore.
@HiveType(typeId: 4)
class RecommendationModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String plotId;

  @HiveField(2)
  late String plotName;

  @HiveField(3)
  late String measurementId;

  @HiveField(4)
  late String userId;

  /// e.g. 'Good' | 'Moderate' | 'Poor'
  @HiveField(5)
  late String soilHealth;

  /// e.g. 'Healthy' | 'Needs Improvement'
  @HiveField(6)
  late String overallStatus;

  @HiveField(7)
  late List<RecommendationItem> recommendations;

  @HiveField(8)
  late DateTime generatedAt;

  /// Origin of the advisory: 'django' (live) or 'cache'.
  @HiveField(9)
  late String source;

  @HiveField(10)
  late bool isSynced;

  /// Overall soil-health score (0–100) from the Django rule engine.
  @HiveField(11)
  late int soilHealthScore;

  RecommendationModel({
    required this.id,
    required this.plotId,
    required this.plotName,
    required this.measurementId,
    required this.userId,
    required this.soilHealth,
    required this.overallStatus,
    required this.recommendations,
    required this.generatedAt,
    this.soilHealthScore = 0,
    this.source = 'django',
    this.isSynced = false,
  });

  Map<String, dynamic> toFirestoreMap() => {
        'id': id,
        'plotId': plotId,
        'plotName': plotName,
        'measurementId': measurementId,
        'userId': userId,
        'soilHealthScore': soilHealthScore,
        'soilHealth': soilHealth,
        'overallStatus': overallStatus,
        'recommendations': recommendations.map((r) => r.toMap()).toList(),
        'generatedAt': generatedAt.toIso8601String(),
        'source': source,
      };
}
