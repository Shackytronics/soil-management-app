// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlotModelAdapter extends TypeAdapter<PlotModel> {
  @override
  final int typeId = 1;

  @override
  PlotModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlotModel(
      id: fields[0] as String,
      name: fields[1] as String,
      location: fields[2] as String,
      sizeAcres: fields[3] as double,
      description: fields[4] as String,
      cropType: fields[5] as String,
      userId: fields[6] as String,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      isSynced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlotModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.sizeAcres)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.cropType)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlotModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
