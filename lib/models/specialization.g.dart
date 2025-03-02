// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialization.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VieSpecializationAdapter extends TypeAdapter<VieSpecialization> {
  @override
  final int typeId = 1;

  @override
  VieSpecialization read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VieSpecialization(
      id: fields[0] as String?,
      specializationLabel: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VieSpecialization obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.specializationLabel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VieSpecializationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VieSpecialization _$VieSpecializationFromJson(Map<String, dynamic> json) =>
    VieSpecialization(
      id: json['id'] as String?,
      specializationLabel: json['specializationLabel'] as String?,
    );

Map<String, dynamic> _$VieSpecializationToJson(VieSpecialization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'specializationLabel': instance.specializationLabel,
    };
