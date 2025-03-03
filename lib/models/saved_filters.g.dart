// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_filters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedFiltersAdapter extends TypeAdapter<SavedFilters> {
  @override
  final int typeId = 2;

  @override
  SavedFilters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedFilters(
      specializations: (fields[0] as List).cast<String>().toSet(),
      sectors: (fields[1] as List).cast<String>().toSet(),
      durations: (fields[2] as List).cast<int>().toSet(),
      countries: (fields[3] as List).cast<String>().toSet(),
      geographicZones: (fields[4] as List).cast<String>().toSet(),
      studyLevels: (fields[5] as List).cast<int>().toSet(),
      missionTypes: (fields[6] as List).cast<int>().toSet(),
      entrepriseTypes: (fields[7] as List).cast<int>().toSet(),
    );
  }

  @override
  void write(BinaryWriter writer, SavedFilters obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.specializations.toList())
      ..writeByte(1)
      ..write(obj.sectors.toList())
      ..writeByte(2)
      ..write(obj.durations.toList())
      ..writeByte(3)
      ..write(obj.countries.toList())
      ..writeByte(4)
      ..write(obj.geographicZones.toList())
      ..writeByte(5)
      ..write(obj.studyLevels.toList())
      ..writeByte(6)
      ..write(obj.missionTypes.toList())
      ..writeByte(7)
      ..write(obj.entrepriseTypes.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedFiltersAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
