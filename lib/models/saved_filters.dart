import 'package:hive/hive.dart';
import '../blocs/vie_state.dart';

part 'saved_filters.g.dart';

@HiveType(typeId: 2)
class SavedFilters extends HiveObject {
  @HiveField(0)
  final Set<String> specializations;

  @HiveField(1)
  final Set<String> sectors;

  @HiveField(2)
  final Set<int> durations;

  @HiveField(3)
  final Set<String> countries;

  @HiveField(4)
  final Set<String> geographicZones;

  @HiveField(5)
  final Set<int> studyLevels;

  @HiveField(6)
  final Set<int> missionTypes;

  @HiveField(7)
  final Set<int> entrepriseTypes;

  SavedFilters({
    this.specializations = const {},
    this.sectors = const {},
    this.durations = const {},
    this.countries = const {},
    this.geographicZones = const {},
    this.studyLevels = const {},
    this.missionTypes = const {},
    this.entrepriseTypes = const {},
  });

  factory SavedFilters.fromState(VieState state) {
    return SavedFilters(
      specializations: state.selectedSpecializations.toSet(),
      sectors: state.selectedSectors.toSet(),
      durations: state.selectedDurations.toSet(),
      countries: state.selectedCountries.toSet(),
      geographicZones: state.selectedGeographicZones.toSet(),
      studyLevels: state.selectedStudyLevels.toSet(),
      missionTypes: state.selectedMissionTypes.toSet(),
      entrepriseTypes: state.selectedEntrepriseTypes.toSet(),
    );
  }
}
