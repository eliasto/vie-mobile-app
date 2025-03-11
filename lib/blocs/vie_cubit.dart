import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../models/vie_offer.dart';
import '../models/saved_filters.dart';
import '../services/vie_service.dart';
import 'vie_state.dart';

class VieCubit extends Cubit<VieState> {
  final VieService _vieService;
  final Box<VieOffer> _favoritesBox = Hive.box<VieOffer>('favorites');
  final Box<SavedFilters> _filtersBox = Hive.box<SavedFilters>('filters');
  static const String _savedFiltersKey = 'current_filters';

  VieCubit(this._vieService) : super(const VieState()) {
    _loadSavedFilters();
    loadFilters();
  }

  Future<void> _loadSavedFilters() async {
    final savedFilters = _filtersBox.get(_savedFiltersKey);
    if (savedFilters != null) {
      emit(state.copyWith(
        selectedSpecializations: savedFilters.specializations.toList(),
        selectedSectors: savedFilters.sectors.toList(),
        selectedDurations: savedFilters.durations.toList(),
        selectedCountries: savedFilters.countries.toList(),
        selectedGeographicZones: savedFilters.geographicZones.toList(),
        selectedStudyLevels: savedFilters.studyLevels.toList(),
        selectedMissionTypes: savedFilters.missionTypes.toList(),
        selectedEntrepriseTypes: savedFilters.entrepriseTypes.toList(),
      ));
    }
  }

  Future<void> _saveFilters() async {
    final filters = SavedFilters(
      specializations: state.selectedSpecializations.toSet(),
      sectors: state.selectedSectors.toSet(),
      durations: state.selectedDurations.toSet(),
      countries: state.selectedCountries.toSet(),
      geographicZones: state.selectedGeographicZones.toSet(),
      studyLevels: state.selectedStudyLevels.toSet(),
      missionTypes: state.selectedMissionTypes.toSet(),
      entrepriseTypes: state.selectedEntrepriseTypes.toSet(),
    );
    await _filtersBox.put(_savedFiltersKey, filters);
  }

  void clearFilters() {
    emit(state.copyWith(
      selectedSpecializations: [],
      selectedSectors: [],
      selectedDurations: [],
      selectedCountries: [],
      selectedGeographicZones: [],
      selectedStudyLevels: [],
      selectedMissionTypes: [],
      selectedEntrepriseTypes: [],
    ));
    _saveFilters();
    searchOffers();
  }

  void removeFilter({required String type, required dynamic value}) {
    switch (type) {
      case 'specialization':
        emit(state.copyWith(
          selectedSpecializations: state.selectedSpecializations.where((id) => id != value).toList(),
        ));
        break;
      case 'sector':
        emit(state.copyWith(
          selectedSectors: state.selectedSectors.where((id) => id != value).toList(),
        ));
        break;
      case 'duration':
        emit(state.copyWith(
          selectedDurations: state.selectedDurations.where((id) => id != value).toList(),
        ));
        break;
      case 'country':
        emit(state.copyWith(
          selectedCountries: state.selectedCountries.where((id) => id != value).toList(),
        ));
        break;
      case 'zone':
        emit(state.copyWith(
          selectedGeographicZones: state.selectedGeographicZones.where((id) => id != value).toList(),
        ));
        break;
      case 'study':
        emit(state.copyWith(
          selectedStudyLevels: state.selectedStudyLevels.where((id) => id != value).toList(),
        ));
        break;
      case 'mission':
        emit(state.copyWith(
          selectedMissionTypes: state.selectedMissionTypes.where((id) => id != value).toList(),
        ));
        break;
      case 'entreprise':
        emit(state.copyWith(
          selectedEntrepriseTypes: state.selectedEntrepriseTypes.where((id) => id != value).toList(),
        ));
        break;
    }
    _saveFilters();
    searchOffers();
  }

  void updateFilters({
    List<String>? specializationsIds,
    List<String>? sectorsIds,
    List<int>? durations,
    List<String>? countriesIds,
    List<String>? geographicZoneIds,
    List<int>? studyLevelIds,
    List<int>? missionTypeIds,
    List<int>? entrepriseTypeIds,
  }) {
    emit(state.copyWith(
      selectedSpecializations: specializationsIds,
      selectedSectors: sectorsIds,
      selectedDurations: durations,
      selectedCountries: countriesIds,
      selectedGeographicZones: geographicZoneIds,
      selectedStudyLevels: studyLevelIds,
      selectedMissionTypes: missionTypeIds,
      selectedEntrepriseTypes: entrepriseTypeIds,
    ));
    _saveFilters();
    searchOffers();
  }

  Future<void> searchOffers() async {
    try {
      emit(state.copyWith(isLoading: true));
      final offers = await _vieService.searchOffers(
        specializationsIds: state.selectedSpecializations,
        sectorsIds: state.selectedSectors,
        durations: state.selectedDurations,
        countriesIds: state.selectedCountries,
        geographicZoneIds: state.selectedGeographicZones,
        studyLevelIds: state.selectedStudyLevels,
        missionTypeIds: state.selectedMissionTypes,
        entrepriseTypeIds: state.selectedEntrepriseTypes,
      );
      emit(state.copyWith(
        offers: offers,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> loadMoreOffers() async {
    if (state.isLoading || state.hasReachedMax) return;

    emit(state.copyWith(isLoading: true));

    try {
      final newOffers = await _vieService.searchOffers(
        skip: state.offers.length,
        limit: 10,
        specializationsIds: state.selectedSpecializations,
        sectorsIds: state.selectedSectors,
        durations: state.selectedDurations,
        countriesIds: state.selectedCountries,
        geographicZoneIds: state.selectedGeographicZones,
        studyLevelIds: state.selectedStudyLevels,
        missionTypeIds: state.selectedMissionTypes,
        entrepriseTypeIds: state.selectedEntrepriseTypes,
      );

      emit(state.copyWith(
        offers: [...state.offers, ...newOffers],
        isLoading: false,
        hasReachedMax: newOffers.isEmpty,
        currentPage: state.currentPage + 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> loadFilters() async {
    try {
      final filters = await _vieService.getFilters();
      emit(state.copyWith(filters: filters));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  bool isFavorite(VieOffer offer) {
    return _favoritesBox.containsKey(offer.id);
  }

  Future<void> toggleFavorite(VieOffer offer) async {
    if (isFavorite(offer)) {
      await _favoritesBox.delete(offer.id);
    } else {
      await _favoritesBox.put(offer.id, offer);
    }
    emit(state.copyWith()); // Force refresh
  }

  List<VieOffer> getFavorites() {
    return _favoritesBox.values.toList();
  }

  @override
  Future<void> close() async {
    await _favoritesBox.close();
    await _filtersBox.close();
    return super.close();
  }
}
