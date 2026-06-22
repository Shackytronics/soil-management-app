import 'package:hive/hive.dart';

part 'measurement_model.g.dart';

@HiveType(typeId: 2)
class MeasurementModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String plotId;

  @HiveField(2)
  late String plotName;

  @HiveField(3)
  late String userId;

  /// Nitrogen (mg/kg)
  @HiveField(4)
  late double nitrogen;

  /// Phosphorus (mg/kg)
  @HiveField(5)
  late double phosphorus;

  /// Potassium (mg/kg)
  @HiveField(6)
  late double potassium;

  /// pH level
  @HiveField(7)
  late double ph;

  /// Soil moisture (%)
  @HiveField(8)
  late double moisture;

  /// Soil temperature (°C)
  @HiveField(9)
  late double temperature;

  /// Electrical conductivity (mS/cm)
  @HiveField(10)
  late double ec;

  @HiveField(11)
  late DateTime recordedAt;

  @HiveField(12)
  String? notes;

  @HiveField(13)
  late bool isSynced;

  MeasurementModel({
    required this.id,
    required this.plotId,
    required this.plotName,
    required this.userId,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.moisture,
    required this.temperature,
    required this.ec,
    required this.recordedAt,
    this.notes,
    this.isSynced = false,
  });

  Map<String, dynamic> toFirestoreMap() => {
        'id': id,
        'plotId': plotId,
        'plotName': plotName,
        'userId': userId,
        'nitrogen': nitrogen,
        'phosphorus': phosphorus,
        'potassium': potassium,
        'ph': ph,
        'moisture': moisture,
        'temperature': temperature,
        'ec': ec,
        'recordedAt': recordedAt.toIso8601String(),
        'notes': notes,
      };

  MeasurementModel copyWith({
    double? nitrogen,
    double? phosphorus,
    double? potassium,
    double? ph,
    double? moisture,
    double? temperature,
    double? ec,
    String? notes,
    bool? isSynced,
  }) {
    return MeasurementModel(
      id: id,
      plotId: plotId,
      plotName: plotName,
      userId: userId,
      nitrogen: nitrogen ?? this.nitrogen,
      phosphorus: phosphorus ?? this.phosphorus,
      potassium: potassium ?? this.potassium,
      ph: ph ?? this.ph,
      moisture: moisture ?? this.moisture,
      temperature: temperature ?? this.temperature,
      ec: ec ?? this.ec,
      recordedAt: recordedAt,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
