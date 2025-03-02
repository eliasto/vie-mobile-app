import 'package:flutter/material.dart';
import '../models/vie_offer.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vie_cubit.dart';
import '../blocs/vie_state.dart';

class OfferDetailsView extends StatelessWidget {
  final VieOffer offer;

  const OfferDetailsView({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(offer.missionTitle, style: ShadTheme.of(context).textTheme.h4),
        actions: [
          BlocBuilder<VieCubit, VieState>(
            builder: (context, state) {
              final isFavorite = context.read<VieCubit>().isFavorite(offer);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<VieCubit>().toggleFavorite(offer);
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80), // Espace pour le bouton
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (offer.organizationUrlImage != null && offer.organizationUrlImage!.isNotEmpty)
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Image.network(
                        offer.organizationUrlImage!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.business,
                              size: 48,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    offer.organizationName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('${offer.missionDuration} mois'),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('${offer.cleanCityName}, ${offer.countryName}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (offer.indemnite != null)
                    Text(
                      'Indemnité : ${offer.indemnite} €/mois',
                      style: const TextStyle(fontSize: 18),
                    ),
                  const SizedBox(height: 16),
                  if (offer.organizationPresentation != null && offer.organizationPresentation!.isNotEmpty) ...[
                    const Text(
                      'Présentation de l\'entreprise',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(offer.organizationPresentation!),
                    const SizedBox(height: 16),
                  ],
                  if (offer.missionDescription != null && offer.missionDescription!.isNotEmpty) ...[
                    const Text(
                      'Description de la mission',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(offer.missionDescription!),
                    const SizedBox(height: 16),
                  ],
                  if (offer.missionProfile != null && offer.missionProfile!.isNotEmpty) ...[
                    const Text(
                      'Profil recherché',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(offer.missionProfile!),
                    const SizedBox(height: 16),
                  ],
                  if (offer.specializations != null) ...[
                    const Text(
                      'Spécialisations',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
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
                  ],
                  const Text(
                    'Informations complémentaires',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (offer.ca != null) Text('Chiffre d\'affaires : ${offer.ca} €'),
                  if (offer.effectif != null) Text('Effectif : ${offer.effectif} employés'),
                  Text('Référence : ${offer.reference ?? "Non spécifiée"}'),
                  Text('Contact : ${offer.cleanContactName ?? "Non spécifié"}'),
                  if (offer.contactEmail != null) Text('Email : ${offer.contactEmail}'),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ShadButton(
                shadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .4),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                onPressed: () async {
                  final offerLink = "https://mon-vie-via.businessfrance.fr/offres/${offer.id}";
                  if (await canLaunchUrl(Uri.parse(offerLink))) {
                    await launchUrl(Uri.parse(offerLink));
                  }
                },
                child: const Text('Postuler'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
