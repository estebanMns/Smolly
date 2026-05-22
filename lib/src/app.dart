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

      // La pantalla con la que inicia la app
      initialRoute: '/home',

      routes: {
        '/home': (context) => const Home(),
        '/lobby': (context) => const Lobby(),
        '/level-map': (context) => const Levelmap(),
        '/level-detail': (context) => const LevelDetailScreen(),
        '/game-screen': (context) => const GameScreen(),
        '/result_screen': (context) => const ResultScreen(),
        '/settings_screen': (context) => const SettingsScreen(),
      },

      // Esto ayuda por si hay errores de navegación
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const Home());
      },
    );
  }
}
