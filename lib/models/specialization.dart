import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'specialization.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class VieSpecialization extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? specializationLabel;

  VieSpecialization({
    required this.id,
    required this.specializationLabel,
  });

  factory VieSpecialization.fromJson(Map<String, dynamic> json) => _$VieSpecializationFromJson(json);
  Map<String, dynamic> toJson() => _$VieSpecializationToJson(this);
}
