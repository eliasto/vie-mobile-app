import 'package:equatable/equatable.dart';
import '../models/filters.dart';
import '../models/vie_offer.dart';

class VieState extends Equatable {
  final List<VieOffer> offers;
  final List<VieOffer> favorites;
  final VieFilters? filters;
  final bool isLoading;
  final String? error;
  final List<String> selectedSpecializations;
  final List<String> selectedSectors;
  final List<int> selectedDurations;
  final List<String> selectedCountries;
  final List<String> selectedGeographicZones;
  final List<int> selectedStudyLevels;
  final List<int> selectedMissionTypes;
  final List<int> selectedEntrepriseTypes;

  const VieState({
    this.offers = const [],
    this.favorites = const [],
    this.filters,
    this.isLoading = false,
    this.error,
    this.selectedSpecializations = const [],
    this.selectedSectors = const [],
    this.selectedDurations = const [],
    this.selectedCountries = const [],
    this.selectedGeographicZones = const [],
    this.selectedStudyLevels = const [],
    this.selectedMissionTypes = const [],
    this.selectedEntrepriseTypes = const [],
  });

  VieState copyWith({
    List<VieOffer>? offers,
    List<VieOffer>? favorites,
    VieFilters? filters,
    bool? isLoading,
    String? error,
    List<String>? selectedSpecializations,
    List<String>? selectedSectors,
    List<int>? selectedDurations,
    List<String>? selectedCountries,
    List<String>? selectedGeographicZones,
    List<int>? selectedStudyLevels,
    List<int>? selectedMissionTypes,
    List<int>? selectedEntrepriseTypes,
  }) {
    return VieState(
      offers: offers ?? this.offers,
      favorites: favorites ?? this.favorites,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedSpecializations: selectedSpecializations ?? this.selectedSpecializations,
      selectedSectors: selectedSectors ?? this.selectedSectors,
      selectedDurations: selectedDurations ?? this.selectedDurations,
      selectedCountries: selectedCountries ?? this.selectedCountries,
      selectedGeographicZones: selectedGeographicZones ?? this.selectedGeographicZones,
      selectedStudyLevels: selectedStudyLevels ?? this.selectedStudyLevels,
      selectedMissionTypes: selectedMissionTypes ?? this.selectedMissionTypes,
      selectedEntrepriseTypes: selectedEntrepriseTypes ?? this.selectedEntrepriseTypes,
    );
  }

  @override
  List<Object?> get props => [
        offers,
        favorites,
        filters,
        isLoading,
        error,
        selectedSpecializations,
        selectedSectors,
        selectedDurations,
        selectedCountries,
        selectedGeographicZones,
        selectedStudyLevels,
        selectedMissionTypes,
        selectedEntrepriseTypes,
      ];
}

class VieInitial extends VieState {}

class VieLoading extends VieState {}

class VieLoaded extends VieState {
  final List<VieOffer> offers;
  final bool hasReachedMax;
  final VieFilters? filters;
  final List<String> selectedCountries;
  final List<String> selectedSectors;
  final List<String> selectedSpecializations;
  final List<int> selectedDurations;

  const VieLoaded({
    required this.offers,
    this.hasReachedMax = false,
    this.filters,
    this.selectedCountries = const [],
    this.selectedSectors = const [],
    this.selectedSpecializations = const [],
    this.selectedDurations = const [],
  });

  @override
  List<Object?> get props => [
        offers,
        hasReachedMax,
        filters,
        selectedCountries,
        selectedSectors,
        selectedSpecializations,
        selectedDurations,
      ];
}

class VieError extends VieState {
  final String message;

  const VieError(this.message);

  @override
  List<Object?> get props => [message];
}
