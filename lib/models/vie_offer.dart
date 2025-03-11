import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'specialization.dart';

part 'vie_offer.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class VieOffer extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String missionTitle;

  @HiveField(2)
  final String organizationName;

  @HiveField(3)
  final String? organizationUrlImage;

  @HiveField(4)
  final String cityName;

  String get cleanCityName => cityName.trim();

  String? get cleanOrganizationUrlImage {
    if (organizationUrlImage == null) {
      return null;
    }
    if (organizationUrlImage == 'null.jpeg' ||
        organizationUrlImage == 'null.jpg' ||
        organizationUrlImage == "http://null.jpeg") {
      return null;
    }
    return organizationUrlImage;
  }

  @HiveField(5)
  final String countryName;

  @HiveField(6)
  final int missionDuration;

  @HiveField(7)
  final int? viewCounter;

  @HiveField(8)
  final int? candidateCounter;

  @HiveField(9)
  final String? missionDescription;

  @HiveField(10)
  final String? missionProfile;

  @HiveField(11)
  final String? organizationPresentation;

  @HiveField(12)
  final double? indemnite;

  @HiveField(13)
  final String? ca;

  @HiveField(14)
  final int? effectif;

  @HiveField(15)
  final String? reference;

  @HiveField(16)
  final String? contactName;

  String? get cleanContactName => contactName?.trim().replaceAll(RegExp(r'\s+'), ' ');

  DateTime? get startDate => missionStartDate != null ? DateTime.parse(missionStartDate!) : null;

  DateTime? get endDate => missionEndDate != null ? DateTime.parse(missionEndDate!) : null;

  @HiveField(17)
  final String? contactEmail;

  @HiveField(18)
  final List<VieSpecialization>? specializations;

  @HiveField(19)
  final String? missionStartDate;

  @HiveField(20)
  final String? missionEndDate;

  VieOffer({
    required this.id,
    required this.missionTitle,
    required this.organizationName,
    this.organizationUrlImage,
    required this.cityName,
    required this.countryName,
    required this.missionDuration,
    this.viewCounter,
    this.candidateCounter,
    this.missionDescription,
    this.missionProfile,
    this.organizationPresentation,
    this.indemnite,
    this.ca,
    this.effectif,
    this.reference,
    this.contactName,
    this.contactEmail,
    this.specializations,
    this.missionStartDate,
    this.missionEndDate,
  });

  factory VieOffer.fromJson(Map<String, dynamic> json) {
    var offer = _$VieOfferFromJson(json);
    if (json['specializations'] != null) {
      offer = offer.copyWith(
        specializations: (json['specializations'] as List)
            .map((spec) => VieSpecialization(
                  id: spec['specializationId'].toString(),
                  specializationLabel: spec['specializationLabel'],
                ))
            .toList(),
      );
    }
    return offer;
  }

  Map<String, dynamic> toJson() => _$VieOfferToJson(this);

  VieOffer copyWith(
      {int? id,
      String? missionTitle,
      String? organizationName,
      String? organizationUrlImage,
      String? cityName,
      String? countryName,
      int? missionDuration,
      int? viewCounter,
      int? candidateCounter,
      String? missionDescription,
      String? missionProfile,
      String? organizationPresentation,
      double? indemnite,
      String? ca,
      int? effectif,
      String? reference,
      String? contactName,
      String? contactEmail,
      List<VieSpecialization>? specializations,
      String? missionStartDate,
      String? missionEndDate}) {
    return VieOffer(
        id: id ?? this.id,
        missionTitle: missionTitle ?? this.missionTitle,
        organizationName: organizationName ?? this.organizationName,
        organizationUrlImage: organizationUrlImage ?? this.organizationUrlImage,
        cityName: cityName ?? this.cityName,
        countryName: countryName ?? this.countryName,
        missionDuration: missionDuration ?? this.missionDuration,
        viewCounter: viewCounter ?? this.viewCounter,
        candidateCounter: candidateCounter ?? this.candidateCounter,
        missionDescription: missionDescription ?? this.missionDescription,
        missionProfile: missionProfile ?? this.missionProfile,
        organizationPresentation: organizationPresentation ?? this.organizationPresentation,
        indemnite: indemnite ?? this.indemnite,
        ca: ca ?? this.ca,
        effectif: effectif ?? this.effectif,
        reference: reference ?? this.reference,
        contactName: contactName ?? this.contactName,
        contactEmail: contactEmail ?? this.contactEmail,
        specializations: specializations ?? this.specializations,
        missionStartDate: missionStartDate ?? this.missionStartDate,
        missionEndDate: missionEndDate ?? this.missionEndDate);
  }
}

@JsonSerializable()
class Specialization {
  final int specializationId;
  final int specializationParentId;
  final String specializationLabel;
  final String specializationLabelEn;

  Specialization({
    required this.specializationId,
    required this.specializationParentId,
    required this.specializationLabel,
    required this.specializationLabelEn,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) => _$SpecializationFromJson(json);
  Map<String, dynamic> toJson() => _$SpecializationToJson(this);
}
