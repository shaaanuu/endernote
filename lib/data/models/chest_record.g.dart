// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chest_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChestRecordAdapter extends TypeAdapter<ChestRecord> {
  @override
  final int typeId = 0;

  @override
  ChestRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChestRecord(
      path: fields[0] as String,
      ts: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChestRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.ts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChestRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
