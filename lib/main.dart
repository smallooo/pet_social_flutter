import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_social_flutter/petsocial_theme.dart';
import 'package:provider/provider.dart';

import 'models/AppStateManager.dart';
import 'models/grocery_manager.dart';
import 'models/profile_manager.dart';
import 'navigation/app_route_parser.dart';
import 'navigation/app_router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _PetSocialState createState() => _PetSocialState();
}

class _PetSocialState extends State<MyApp> {
  late AppRouter _appRouter;
  final _appStateManager = AppStateManager();
  final routeParser = AppRouteParser();
  final _profileManager = ProfileManager();
  final _groceryManager = GroceryManager();

  @override
  void initState() {
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      groceryManager: _groceryManager,
      profileManager: _profileManager,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        )
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          theme = PetSocialTheme.light();
          return MaterialApp.router(
            theme: theme,
            title: 'PetSocial',
            backButtonDispatcher: RootBackButtonDispatcher(),
            routeInformationParser: routeParser,
            routerDelegate: _appRouter,
          );
        },
      ),
    );
  }

}


