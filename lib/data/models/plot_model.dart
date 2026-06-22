import 'package:hive/hive.dart';

part 'plot_model.g.dart';

@HiveType(typeId: 1)
class PlotModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String location;

  @HiveField(3)
  late double sizeAcres;

  @HiveField(4)
  late String description;

  @HiveField(5)
  late String cropType;

  @HiveField(6)
  late String userId;

  @HiveField(7)
  late DateTime createdAt;

  @HiveField(8)
  late DateTime updatedAt;

  @HiveField(9)
  late bool isSynced;

  PlotModel({
    required this.id,
    required this.name,
    required this.location,
    required this.sizeAcres,
    required this.description,
    required this.cropType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toFirestoreMap() => {
        'id': id,
        'name': name,
        'location': location,
        'sizeAcres': sizeAcres,
        'description': description,
        'cropType': cropType,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  PlotModel copyWith({
    String? name,
    String? location,
    double? sizeAcres,
    String? description,
    String? cropType,
    bool? isSynced,
  }) {
    return PlotModel(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      sizeAcres: sizeAcres ?? this.sizeAcres,
      description: description ?? this.description,
      cropType: cropType ?? this.cropType,
      userId: userId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
