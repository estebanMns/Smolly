import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  // Se agregó el parámetro key para corregir 'use_key_in_widget_constructors'
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  String _selectedLanguage = Get.locale?.languageCode == 'en' ? 'Inglés' : 'Español';
  bool _cameraAccess = false;

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    setState(() {
      _cameraAccess = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/stardust.png',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      _buildSettingItem(
                        icon: Icons.volume_up_rounded,
                        title: 'sound'.tr,
                        trailing: Switch(
                          value: _soundEnabled,
                          // Corregido: activeThumbColor en lugar de activeColor
                          activeThumbColor: Colors.cyanAccent,
                          activeTrackColor: Colors.cyanAccent.withValues(alpha: 0.5),
                          onChanged: (val) => setState(() => _soundEnabled = val),
                        ),
                      ),
                      _buildSettingItem(
                        icon: Icons.language_rounded,
                        title: 'language'.tr,
                        trailing: DropdownButton<String>(
                          dropdownColor: const Color(0xFF1A1F2B),
                          value: _selectedLanguage,
                          underline: const SizedBox(),
                          style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                          onChanged: (val) {
                            if (val == null) return;
                            setState(() {
                              _selectedLanguage = val;
                              if (val == 'Inglés') {
                                Get.updateLocale(const Locale('en', 'US'));
                              } else {
                                Get.updateLocale(const Locale('es', 'ES'));
                              }
                            });
                          },
                          items: ['Inglés', 'Español'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              // El texto del item también se podría traducir si se desea, por ahora mantenemos las opciones fijas para no romper el match de value
                              child: Text(value == 'Inglés' ? 'english'.tr : 'spanish'.tr),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildSettingItem(
                        icon: Icons.camera_alt_rounded,
                        title: 'camera'.tr,
                        trailing: IconButton(
                          icon: Icon(
                            _cameraAccess ? Icons.check_circle : Icons.error_outline,
                            color: _cameraAccess ? Colors.greenAccent : Colors.redAccent,
                            size: 35,
                          ),
                          onPressed: _checkCameraPermission,
                        ),
                      ),
                      _buildSettingItem(
                        icon: Icons.help_outline_rounded,
                        title: 'helps'.tr,
                        onTap: () {
                          // Acción para ayudas
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.person_pin_rounded,
                        title: 'account'.tr,
                        onTap: () {
                          // Navegación corregida para evitar bucles infinitos si es necesario
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // Corregido: withValues(alpha: 0.2) en lugar de withOpacity
                color: Colors.cyanAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyanAccent, width: 2),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'settings_title'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  // Corregido: FontWeight.w900 en lugar de .black para evitar errores de constante
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 10)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Icon(icon, color: Colors.cyanAccent, size: 35),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.white24),
      ),
    );
  }
}