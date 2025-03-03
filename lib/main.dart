import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'blocs/vie_cubit.dart';
import 'models/vie_offer.dart';
import 'models/specialization.dart';
import 'models/saved_filters.dart';
import 'services/vie_service.dart';
import 'views/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(VieOfferAdapter());
  Hive.registerAdapter(VieSpecializationAdapter());
  Hive.registerAdapter(SavedFiltersAdapter());

  await Hive.openBox<VieOffer>('favorites');
  await Hive.openBox<SavedFilters>('filters');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final vieService = VieService();

    return MultiProvider(
      providers: [
        Provider<VieService>(create: (_) => vieService),
        BlocProvider(create: (_) => VieCubit(vieService)),
      ],
      child: ShadApp(
        title: 'VIE App',
        themeMode: ThemeMode.system,
        home: const ScaffoldMessenger(child: MainView()),
      ),
    );
  }
}
