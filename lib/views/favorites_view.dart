import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../blocs/vie_cubit.dart';
import '../blocs/vie_state.dart';
import '../models/vie_offer.dart';
import 'offer_details_view.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Retirer des favoris'),
            content: const Text('Voulez-vous vraiment retirer cette offre des favoris ?'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Supprimer'),
              ),
            ],
          );
        },
      );
    } else {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: const Text('Voulez-vous vraiment retirer cette offre des favoris ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }
  }

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
    return Dismissible(
      key: Key(offer.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(height: 4),
            Text(
              'Supprimer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) => _showDeleteConfirmationDialog(context),
      onDismissed: (direction) {
        context.read<VieCubit>().toggleFavorite(offer);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offre retirée des favoris'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Card(
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OfferDetailsView(offer: offer),
              ),
            );
          },
        ),
      ),
    );
  }
}
