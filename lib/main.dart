import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:perfume_store/theme/colors.dart';
import 'package:perfume_store/views/data/notifiers.dart';
import 'package:perfume_store/views/pages/on_boarding_pages/onboarding_screen_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:perfume_store/views/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(initialization);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 1));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<bool> checkOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('checkOnBoarding') ?? false;
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.lightBeige,
              brightness: value ? Brightness.light : Brightness.dark,
            ),
          ),
          home: FutureBuilder<bool>(
            future: checkOnBoarding(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return snapshot.data! ? WidgetTree() : OnBoardingScreen();
            },
          ),
        );
      },
    );
  }
}
