import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../blocs/vie_cubit.dart';
import '../blocs/vie_state.dart';
import '../models/filters.dart';
import '../services/vie_service.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final Set<String> _selectedSpecializations = {};
  final Set<String> _selectedSectors = {};
  final Set<int> _selectedDurations = {};
  final Set<String> _selectedGeographicZones = {};
  final Set<String> _selectedCountries = {};
  final Set<int> _selectedStudyLevels = {};
  final Set<int> _selectedMissionTypes = {};
  final Set<int> _selectedEntrepriseTypes = {};
  final Map<String, List<FilterOption>> _countriesByZone = {};
  bool _isLoadingCountries = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VieCubit, VieState>(
      builder: (context, state) {
        if (state.filters == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final filters = state.filters!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Filtres', style: ShadTheme.of(context).textTheme.h4),
            actions: [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearFilters,
                tooltip: 'Réinitialiser les filtres',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  'Types de mission',
                  filters.missionTypes,
                  _selectedMissionTypes,
                  (id) => int.parse(id),
                ),
                _buildSection(
                  'Niveaux d\'études',
                  filters.studyLevels,
                  _selectedStudyLevels,
                  (id) => int.parse(id),
                ),
                _buildSection(
                  'Types d\'entreprise',
                  filters.entrepriseTypes,
                  _selectedEntrepriseTypes,
                  (id) => int.parse(id),
                ),
                _buildSection(
                  'Secteurs d\'activité',
                  filters.sectors,
                  _selectedSectors,
                ),
                _buildSection(
                  'Spécialisations',
                  filters.specializations,
                  _selectedSpecializations,
                ),
                _buildDurationsSection(filters.durations),
                _buildGeographicZonesSection(filters.geographicZones),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShadButton.outline(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 8),
                  ShadButton(
                    onPressed: _applyFilters,
                    child: const Text('Appliquer'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<FilterOption> options, Set<dynamic> selectedValues,
      [dynamic Function(String)? parseId]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final value = parseId != null ? parseId(option.id) : option.id;
            return FilterChip(
              label: Text(option.label),
              selected: selectedValues.contains(value),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedValues.add(value);
                  } else {
                    selectedValues.remove(value);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDurationsSection(List<int> durations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Durée de mission',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: durations.map((duration) {
            return FilterChip(
              label: Text('$duration mois'),
              selected: _selectedDurations.contains(duration),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDurations.add(duration);
                  } else {
                    _selectedDurations.remove(duration);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGeographicZonesSection(List<FilterOption> zones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Zones géographiques',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: zones.map((zone) {
            return FilterChip(
              label: Text(zone.label),
              selected: _selectedGeographicZones.contains(zone.id),
              onSelected: (selected) async {
                setState(() {
                  if (selected) {
                    _selectedGeographicZones.add(zone.id);
                    _loadCountriesForZone(zone.id);
                  } else {
                    _selectedGeographicZones.remove(zone.id);
                    _countriesByZone.remove(zone.id);
                    _selectedCountries.removeWhere((countryId) => _countriesByZone.values
                        .expand((countries) => countries)
                        .every((country) => country.id != countryId));
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_isLoadingCountries)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        ..._selectedGeographicZones.map((zoneId) {
          final countries = _countriesByZone[zoneId] ?? [];
          if (countries.isEmpty && !_isLoadingCountries) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Pays de ${zones.firstWhere((z) => z.id == zoneId).label}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: countries.map((country) {
                  return FilterChip(
                    label: Text(country.label),
                    selected: _selectedCountries.contains(country.id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCountries.add(country.id);
                        } else {
                          _selectedCountries.remove(country.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _loadCountriesForZone(String zoneId) async {
    if (_countriesByZone.containsKey(zoneId)) return;

    setState(() {
      _isLoadingCountries = true;
    });

    try {
      final countries = await context.read<VieService>().getCountriesByZone(zoneId);
      if (!mounted) return;
      setState(() {
        _countriesByZone[zoneId] = countries;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors du chargement des pays'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCountries = false;
        });
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedSpecializations.clear();
      _selectedSectors.clear();
      _selectedDurations.clear();
      _selectedGeographicZones.clear();
      _selectedCountries.clear();
      _selectedStudyLevels.clear();
      _selectedMissionTypes.clear();
      _selectedEntrepriseTypes.clear();
      _countriesByZone.clear();
    });
  }

  void _applyFilters() {
    final cubit = context.read<VieCubit>();
    cubit.updateFilters(
      specializationsIds: _selectedSpecializations.toList(),
      sectorsIds: _selectedSectors.toList(),
      durations: _selectedDurations.toList(),
      countriesIds: _selectedCountries.toList(),
      geographicZoneIds: _selectedGeographicZones.toList(),
      studyLevelIds: _selectedStudyLevels.toList(),
      missionTypeIds: _selectedMissionTypes.toList(),
      entrepriseTypeIds: _selectedEntrepriseTypes.toList(),
    );
    Navigator.pop(context);
  }
}
