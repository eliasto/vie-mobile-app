// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VieFilters _$VieFiltersFromJson(Map<String, dynamic> json) => VieFilters(
      studyLevels: (json['studyLevels'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      missionTypes: (json['missionTypes'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      entrepriseTypes: (json['entrepriseTypes'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      sectors: (json['sectors'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      geographicZones: (json['geographicZones'] as List<dynamic>)
          .map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      durations: (json['durations'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$VieFiltersToJson(VieFilters instance) =>
    <String, dynamic>{
      'studyLevels': instance.studyLevels,
      'missionTypes': instance.missionTypes,
      'entrepriseTypes': instance.entrepriseTypes,
      'sectors': instance.sectors,
      'specializations': instance.specializations,
      'geographicZones': instance.geographicZones,
      'durations': instance.durations,
    };

FilterOption _$FilterOptionFromJson(Map<String, dynamic> json) => FilterOption(
      id: json['id'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$FilterOptionToJson(FilterOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
    };
