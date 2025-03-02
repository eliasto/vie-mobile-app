import 'package:json_annotation/json_annotation.dart';

part 'filters.g.dart';

@JsonSerializable()
class VieFilters {
  final List<FilterOption> studyLevels;
  final List<FilterOption> missionTypes;
  final List<FilterOption> entrepriseTypes;
  final List<FilterOption> sectors;
  final List<FilterOption> specializations;
  final List<FilterOption> geographicZones;
  final List<int> durations;

  VieFilters({
    required this.studyLevels,
    required this.missionTypes,
    required this.entrepriseTypes,
    required this.sectors,
    required this.specializations,
    required this.geographicZones,
    required this.durations,
  });

  factory VieFilters.fromJson(Map<String, dynamic> json) => _$VieFiltersFromJson(json);
  Map<String, dynamic> toJson() => _$VieFiltersToJson(this);
}

@JsonSerializable()
class FilterOption {
  final String id;
  final String label;

  FilterOption({
    required this.id,
    required this.label,
  });

  factory FilterOption.fromJson(Map<String, dynamic> json) => _$FilterOptionFromJson(json);
  Map<String, dynamic> toJson() => _$FilterOptionToJson(this);
}
