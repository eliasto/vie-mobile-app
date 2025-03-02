import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../blocs/vie_cubit.dart';
import '../blocs/vie_state.dart';
import '../models/vie_offer.dart';
import 'offer_details_view.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoris',
          style: ShadTheme.of(context).textTheme.h4,
        ),
      ),
      body: BlocBuilder<VieCubit, VieState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text('Aucune offre en favoris'),
            );
          }

          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final offer = state.favorites[index];
              return _buildOfferCard(context, offer);
            },
          );
        },
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, VieOffer offer) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: offer.organizationUrlImage != null
            ? SizedBox(
                width: 40,
                height: 40,
                child: Image.network(
                  offer.organizationUrlImage!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.business,
                      size: 24,
                      color: Colors.grey,
                    );
                  },
                ),
              )
            : const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.business,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.organizationName,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              offer.missionTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text('${offer.cleanCityName}, ${offer.countryName}'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            context.read<VieCubit>().toggleFavorite(offer);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OfferDetailsView(offer: offer),
            ),
          );
        },
      ),
    );
  }
}
