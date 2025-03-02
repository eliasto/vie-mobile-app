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
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Favoris'),
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
        ),
        child: _buildBody(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoris',
          style: ShadTheme.of(context).textTheme.h4,
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<VieCubit, VieState>(
      builder: (context, state) {
        if (state.favorites.isEmpty) {
          return Center(
            child: Text(
              'Aucune offre en favoris',
              style: Platform.isIOS
                  ? const TextStyle(
                      fontSize: 17,
                      color: CupertinoColors.secondaryLabel,
                    )
                  : null,
            ),
          );
        }

        return ListView.builder(
          itemCount: state.favorites.length,
          itemBuilder: (context, index) {
            final offer = state.favorites[index];
            return Column(
              children: [
                _buildOfferCard(context, offer),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOfferCard(BuildContext context, VieOffer offer) {
    Widget cardContent = Platform.isIOS
        ? CupertinoListTile(
            leading: _buildLeadingImage(offer),
            title: Text(
              offer.organizationName,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.missionTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    color: CupertinoColors.label,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${offer.cleanCityName}, ${offer.countryName}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ),
            onTap: () => _navigateToDetails(context, offer),
          )
        : ListTile(
            leading: _buildLeadingImage(offer),
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
            onTap: () => _navigateToDetails(context, offer),
          );

    if (Platform.isIOS) {
      return Dismissible(
        key: Key(offer.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: CupertinoColors.destructiveRed,
          child: const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.white,
                ),
                SizedBox(height: 4),
                Text(
                  'Supprimer',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        confirmDismiss: (direction) => _showDeleteConfirmationDialog(context),
        onDismissed: (direction) => _handleDismiss(context, offer),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator,
                width: 0.0,
              ),
            ),
          ),
          child: cardContent,
        ),
      );
    }

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
      onDismissed: (direction) => _handleDismiss(context, offer),
      child: Card(
        margin: const EdgeInsets.all(8),
        child: cardContent,
      ),
    );
  }

  Widget _buildLeadingImage(VieOffer offer) {
    return SizedBox(
      width: 40,
      height: 40,
      child: offer.cleanOrganizationUrlImage != null
          ? Image.network(
              offer.cleanOrganizationUrlImage!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Platform.isIOS ? CupertinoIcons.building_2_fill : Icons.business,
                  size: 24,
                  color: Platform.isIOS ? CupertinoColors.secondaryLabel : Colors.grey,
                );
              },
            )
          : Icon(
              Platform.isIOS ? CupertinoIcons.building_2_fill : Icons.business,
              size: 24,
              color: Platform.isIOS ? CupertinoColors.secondaryLabel : Colors.grey,
            ),
    );
  }

  void _navigateToDetails(BuildContext context, VieOffer offer) {
    Navigator.push(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(
              builder: (context) => OfferDetailsView(offer: offer),
            )
          : MaterialPageRoute(
              builder: (context) => OfferDetailsView(offer: offer),
            ),
    );
  }

  void _handleDismiss(BuildContext context, VieOffer offer) {
    context.read<VieCubit>().toggleFavorite(offer);
  }
}
