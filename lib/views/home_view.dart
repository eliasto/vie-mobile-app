import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../blocs/vie_cubit.dart';
import '../blocs/vie_state.dart';
import '../models/vie_offer.dart';
import '../models/filters.dart';
import '../services/vie_service.dart';
import '../services/logger_service.dart';
import 'offer_details_view.dart';
import 'filter_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<VieCubit>().loadMoreOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offres VIE',
          style: ShadTheme.of(context).textTheme.h4,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterView(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VieCubit, VieState>(
        builder: (context, state) {
          if (state.isLoading && state.offers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              if (_hasActiveFilters(state))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Filtres actifs',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              context.read<VieCubit>().clearFilters();
                            },
                            child: const Text('Effacer tout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ..._buildActiveFilters(state),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _buildContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _hasActiveFilters(VieState state) {
    return state.selectedSpecializations.isNotEmpty ||
        state.selectedSectors.isNotEmpty ||
        state.selectedDurations.isNotEmpty ||
        state.selectedCountries.isNotEmpty ||
        state.selectedGeographicZones.isNotEmpty ||
        state.selectedStudyLevels.isNotEmpty ||
        state.selectedMissionTypes.isNotEmpty ||
        state.selectedEntrepriseTypes.isNotEmpty;
  }

  List<Widget> _buildActiveFilters(VieState state) {
    final filters = <Widget>[];
    final filtersData = state.filters;
    if (filtersData == null) return filters;

    void addFilters(List<String> selected, List<FilterOption> options, String type) {
      for (final id in selected) {
        final option = options.firstWhere((o) => o.id == id, orElse: () => FilterOption(id: id, label: id));
        filters.add(
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text('${option.label} ($type)'),
              onDeleted: () {
                // Supprimer le filtre spécifique
                context.read<VieCubit>().removeFilter(type: type, value: id);
              },
            ),
          ),
        );
      }
    }

    void addIntFilters(List<int> selected, List<FilterOption> options, String type) {
      for (final id in selected) {
        final option = options.firstWhere((o) => int.parse(o.id) == id,
            orElse: () => FilterOption(id: id.toString(), label: id.toString()));
        filters.add(
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text('${option.label} ($type)'),
              onDeleted: () {
                context.read<VieCubit>().removeFilter(type: type, value: id);
              },
            ),
          ),
        );
      }
    }

    void addDurationFilters(List<int> selected) {
      for (final duration in selected) {
        filters.add(
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text('$duration mois'),
              onDeleted: () {
                context.read<VieCubit>().removeFilter(type: 'duration', value: duration);
              },
            ),
          ),
        );
      }
    }

    addIntFilters(state.selectedMissionTypes, filtersData.missionTypes, 'mission');
    addIntFilters(state.selectedStudyLevels, filtersData.studyLevels, 'study');
    addIntFilters(state.selectedEntrepriseTypes, filtersData.entrepriseTypes, 'entreprise');
    addFilters(state.selectedSectors, filtersData.sectors, 'sector');
    addFilters(state.selectedSpecializations, filtersData.specializations, 'specialization');
    addDurationFilters(state.selectedDurations);
    addFilters(state.selectedGeographicZones, filtersData.geographicZones, 'zone');

    return filters;
  }

  Widget _buildContent(VieState state) {
    if (state.error != null && state.offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Erreur',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ShadButton(
              onPressed: () {
                context.read<VieCubit>().searchOffers();
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (state.offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Aucune offre trouvée',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Essayez de modifier vos critères de recherche',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ShadButton(
              onPressed: () {
                context.read<VieCubit>().searchOffers();
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<VieCubit>().searchOffers();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.offers.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.offers.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: state.isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
              ),
            );
          }
          final offer = state.offers[index];
          return _buildOfferCard(context, offer);
        },
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, VieOffer offer) {
    final customStartDate = offer.startDate != null ? DateFormat('MMMM yyyy', 'fr_FR').format(offer.startDate!) : null;

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              if (offer.cleanOrganizationUrlImage?.isNotEmpty == true)
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Image.network(
                    offer.cleanOrganizationUrlImage!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.business,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (offer.cleanOrganizationUrlImage == null || offer.cleanOrganizationUrlImage!.isEmpty)
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.business,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: FavoriteButton(offer: offer),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        offer.organizationName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  offer.missionTitle,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (customStartDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('Début $customStartDate'),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('${offer.missionDuration} mois'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${offer.cleanCityName}, ${offer.countryName}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (offer.specializations != null)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: offer.specializations!
                        .map((spec) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(spec.specializationLabel ?? ''),
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye, size: 16),
                    const SizedBox(width: 4),
                    Text('${offer.viewCounter}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.people, size: 16),
                    const SizedBox(width: 4),
                    Text('${offer.candidateCounter}'),
                    const Spacer(),
                    Builder(
                      builder: (context) => ShadButton(
                        onPressed: () async {
                          try {
                            final detailedOffer = await context.read<VieService>().getOfferDetails(offer.id);
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OfferDetailsView(offer: detailedOffer),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erreur lors du chargement des détails: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              LoggerService.error('Erreur lors du chargement des détails de l\'offre', e);
                            }
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Voir l\'offre'),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final VieOffer offer;
  const FavoriteButton({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VieCubit, VieState>(
      builder: (context, state) {
        final isFavorite = context.read<VieCubit>().isFavorite(offer);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              context.read<VieCubit>().toggleFavorite(offer);
            },
          ),
        );
      },
    );
  }
}
