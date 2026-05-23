import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/home_screen.dart';
import 'pages/lobby_screen.dart';
import 'pages/level_map.dart';
import 'pages/level_detail.dart';
import 'pages/game_screen.dart';
import 'pages/result_screen.dart';
import 'pages/settings_screen.dart';
import 'localization/app_translations.dart';
import '../config/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'El Robo de Molly',
      translations: AppTranslations(),
      locale: const Locale('es', 'ES'), // default locale
      fallbackLocale: const Locale('es', 'ES'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),

      initialRoute: AppRoutes.home,

      routes: {
        AppRoutes.home: (context) => const Home(),
        AppRoutes.lobby: (context) => const Lobby(),
        AppRoutes.levelMap: (context) => const Levelmap(),
        AppRoutes.levelDetail: (context) => const LevelDetailScreen(),
        AppRoutes.gameScreen: (context) => const GameScreen(),
        AppRoutes.resultScreen: (context) => const ResultScreen(),
        AppRoutes.settingsScreen: (context) => const SettingsScreen(),
      },

      // Esto ayuda por si hay errores de navegación
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const Home());
      },
    );
  }
}
