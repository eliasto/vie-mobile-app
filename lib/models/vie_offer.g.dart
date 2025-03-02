// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vie_offer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VieOfferAdapter extends TypeAdapter<VieOffer> {
  @override
  final int typeId = 0;

  @override
  VieOffer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VieOffer(
      id: fields[0] as int,
      missionTitle: fields[1] as String,
      organizationName: fields[2] as String,
      organizationUrlImage: fields[3] as String?,
      cityName: fields[4] as String,
      countryName: fields[5] as String,
      missionDuration: fields[6] as int,
      viewCounter: fields[7] as int?,
      candidateCounter: fields[8] as int?,
      missionDescription: fields[9] as String?,
      missionProfile: fields[10] as String?,
      organizationPresentation: fields[11] as String?,
      indemnite: fields[12] as double?,
      ca: fields[13] as String?,
      effectif: fields[14] as int?,
      reference: fields[15] as String?,
      contactName: fields[16] as String?,
      contactEmail: fields[17] as String?,
      specializations: (fields[18] as List?)?.cast<VieSpecialization>(),
    );
  }

  @override
  void write(BinaryWriter writer, VieOffer obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.missionTitle)
      ..writeByte(2)
      ..write(obj.organizationName)
      ..writeByte(3)
      ..write(obj.organizationUrlImage)
      ..writeByte(4)
      ..write(obj.cityName)
      ..writeByte(5)
      ..write(obj.countryName)
      ..writeByte(6)
      ..write(obj.missionDuration)
      ..writeByte(7)
      ..write(obj.viewCounter)
      ..writeByte(8)
      ..write(obj.candidateCounter)
      ..writeByte(9)
      ..write(obj.missionDescription)
      ..writeByte(10)
      ..write(obj.missionProfile)
      ..writeByte(11)
      ..write(obj.organizationPresentation)
      ..writeByte(12)
      ..write(obj.indemnite)
      ..writeByte(13)
      ..write(obj.ca)
      ..writeByte(14)
      ..write(obj.effectif)
      ..writeByte(15)
      ..write(obj.reference)
      ..writeByte(16)
      ..write(obj.contactName)
      ..writeByte(17)
      ..write(obj.contactEmail)
      ..writeByte(18)
      ..write(obj.specializations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VieOfferAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VieOffer _$VieOfferFromJson(Map<String, dynamic> json) => VieOffer(
      id: (json['id'] as num).toInt(),
      missionTitle: json['missionTitle'] as String,
      organizationName: json['organizationName'] as String,
      organizationUrlImage: json['organizationUrlImage'] as String?,
      cityName: json['cityName'] as String,
      countryName: json['countryName'] as String,
      missionDuration: (json['missionDuration'] as num).toInt(),
      viewCounter: (json['viewCounter'] as num?)?.toInt(),
      candidateCounter: (json['candidateCounter'] as num?)?.toInt(),
      missionDescription: json['missionDescription'] as String?,
      missionProfile: json['missionProfile'] as String?,
      organizationPresentation: json['organizationPresentation'] as String?,
      indemnite: (json['indemnite'] as num?)?.toDouble(),
      ca: json['ca'] as String?,
      effectif: (json['effectif'] as num?)?.toInt(),
      reference: json['reference'] as String?,
      contactName: json['contactName'] as String?,
      contactEmail: json['contactEmail'] as String?,
      specializations: (json['specializations'] as List<dynamic>?)
          ?.map((e) => VieSpecialization.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VieOfferToJson(VieOffer instance) => <String, dynamic>{
      'id': instance.id,
      'missionTitle': instance.missionTitle,
      'organizationName': instance.organizationName,
      'organizationUrlImage': instance.organizationUrlImage,
      'cityName': instance.cityName,
      'countryName': instance.countryName,
      'missionDuration': instance.missionDuration,
      'viewCounter': instance.viewCounter,
      'candidateCounter': instance.candidateCounter,
      'missionDescription': instance.missionDescription,
      'missionProfile': instance.missionProfile,
      'organizationPresentation': instance.organizationPresentation,
      'indemnite': instance.indemnite,
      'ca': instance.ca,
      'effectif': instance.effectif,
      'reference': instance.reference,
      'contactName': instance.contactName,
      'contactEmail': instance.contactEmail,
      'specializations': instance.specializations,
    };

Specialization _$SpecializationFromJson(Map<String, dynamic> json) =>
    Specialization(
      specializationId: (json['specializationId'] as num).toInt(),
      specializationParentId: (json['specializationParentId'] as num).toInt(),
      specializationLabel: json['specializationLabel'] as String,
      specializationLabelEn: json['specializationLabelEn'] as String,
    );

Map<String, dynamic> _$SpecializationToJson(Specialization instance) =>
    <String, dynamic>{
      'specializationId': instance.specializationId,
      'specializationParentId': instance.specializationParentId,
      'specializationLabel': instance.specializationLabel,
      'specializationLabelEn': instance.specializationLabelEn,
    };
