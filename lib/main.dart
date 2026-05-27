import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import './src/app.dart';
import './components/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['supabase_Url']!,
    anonKey: dotenv.env['supabase_Key']!,
  );

  Get.put(SettingsController());

  runApp(const MyApp());
}

