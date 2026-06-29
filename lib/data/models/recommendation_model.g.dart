// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationItemAdapter extends TypeAdapter<RecommendationItem> {
  @override
  final int typeId = 5;

  @override
  RecommendationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationItem(
      category: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      priority: fields[3] as String,
      icon: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecommendationModelAdapter extends TypeAdapter<RecommendationModel> {
  @override
  final int typeId = 4;

  @override
  RecommendationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationModel(
      id: fields[0] as String,
      plotId: fields[1] as String,
      plotName: fields[2] as String,
      measurementId: fields[3] as String,
      userId: fields[4] as String,
      soilHealth: fields[5] as String,
      overallStatus: fields[6] as String,
      recommendations: (fields[7] as List).cast<RecommendationItem>(),
      generatedAt: fields[8] as DateTime,
      source: fields[9] as String,
      isSynced: fields[10] as bool,
      soilHealthScore: fields[11] == null ? 0 : (fields[11] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plotId)
      ..writeByte(2)
      ..write(obj.plotName)
      ..writeByte(3)
      ..write(obj.measurementId)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.soilHealth)
      ..writeByte(6)
      ..write(obj.overallStatus)
      ..writeByte(7)
      ..write(obj.recommendations)
      ..writeByte(8)
      ..write(obj.generatedAt)
      ..writeByte(9)
      ..write(obj.source)
      ..writeByte(10)
      ..write(obj.isSynced)
      ..writeByte(11)
      ..write(obj.soilHealthScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
