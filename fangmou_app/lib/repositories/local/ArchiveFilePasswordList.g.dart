// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ArchiveFilePasswordList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArchiveFilePasswordListAdapter extends TypeAdapter<ArchiveFilePasswordList> {
  @override
  final int typeId = 0;

  @override
  ArchiveFilePasswordList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read()};
    return ArchiveFilePasswordList(passwordList: (fields[0] as List).cast<String>());
  }

  @override
  void write(BinaryWriter writer, ArchiveFilePasswordList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.passwordList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ArchiveFilePasswordListAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
