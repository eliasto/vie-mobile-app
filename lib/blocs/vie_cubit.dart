import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/vie_offer.dart';
import '../services/vie_service.dart';
import 'vie_state.dart';

class VieCubit extends Cubit<VieState> {
  final VieService _vieService;
  late Box<VieOffer> _favoritesBox;

  VieCubit(this._vieService) : super(const VieState()) {
    _initHive();
    loadFilters();
  }

  Future<void> _initHive() async {
    _favoritesBox = await Hive.openBox<VieOffer>('favorites');
    final favorites = _favoritesBox.values.toList();
    emit(state.copyWith(favorites: favorites));
  }

  Future<void> loadFilters() async {
    try {
      emit(state.copyWith(isLoading: true));
      final filters = await _vieService.getFilters();
      emit(state.copyWith(
        filters: filters,
        isLoading: false,
      ));
      searchOffers();
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
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
    searchOffers();
  }

  Future<void> toggleFavorite(VieOffer offer) async {
    final currentFavorites = List<VieOffer>.from(state.favorites);
    if (currentFavorites.any((fav) => fav.id == offer.id)) {
      currentFavorites.removeWhere((fav) => fav.id == offer.id);
      await _favoritesBox.delete(offer.id);
    } else {
      currentFavorites.add(offer);
      await _favoritesBox.put(offer.id, offer);
    }
    emit(state.copyWith(favorites: currentFavorites));
  }

  bool isFavorite(VieOffer offer) {
    return state.favorites.any((fav) => fav.id == offer.id);
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

  @override
  Future<void> close() async {
    await _favoritesBox.close();
    return super.close();
  }
}
