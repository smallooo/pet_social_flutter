import 'package:flutter/material.dart';
import 'package:pet_social_flutter/models/AppStateManager.dart';
import 'package:pet_social_flutter/models/petsocial_pages.dart';
import 'package:provider/provider.dart';



class SplashScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: "abc",
        key: ValueKey(PetSocialPages.splashPath),
        child: const SplashScreen());
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppStateManager>(context, listen: false).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              height: 200,
              image: AssetImage('assets/petsocial_assets/rw_logo.png'),
            ),
            const Text('Initializing...')
          ],
        ),
      ),
    );
  }
}