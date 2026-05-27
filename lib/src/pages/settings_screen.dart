import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import '../../components/settings_controller.dart';
import '../../utils/audio_service.dart';

class SettingsScreen extends StatefulWidget {
  // Se agregó el parámetro key para corregir 'use_key_in_widget_constructors'
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _settingsController = Get.find<SettingsController>();
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
      body: Stack(
        children: [
          // Fondo principal
          Positioned.fill(
            child: Image.asset(
              'assets/images/Fondogeneral.jpg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay morado suave
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A0B2E).withValues(alpha: 0.7),
                    const Color(0xFF2D1B4E).withValues(alpha: 0.6),
                    const Color(0xFF4A1D6D).withValues(alpha: 0.5),
                  ],
                ),
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
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Obx(() => _buildSettingItem(
                        icon: Icons.volume_up_rounded,
                        title: 'sound'.tr,
                        color: const Color(0xFF69F0AE),
                        trailing: Switch(
                          value: _settingsController.isSoundOn.value,
                          activeThumbColor: const Color(0xFF69F0AE),
                          activeTrackColor: const Color(0xFF69F0AE).withValues(alpha: 0.5),
                          onChanged: (val) async {
                            _settingsController.toggleSound();
                            if (!val) {
                              await AudioService().stop();
                            }
                          },
                        ),
                      )),
                      _buildSettingItem(
                        icon: Icons.language_rounded,
                        title: 'language'.tr,
                        color: const Color(0xFF7C4DFF),
                        trailing: DropdownButton<String>(
                          dropdownColor: const Color(0xFF2D1B4E),
                          value: _selectedLanguage,
                          underline: const SizedBox(),
                          style: const TextStyle(color: Color(0xFFB39DFF), fontWeight: FontWeight.bold),
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
                              child: Text(
                                value == 'Inglés' ? 'english'.tr : 'spanish'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      _buildSettingItem(
                        icon: Icons.camera_alt_rounded,
                        title: 'camera'.tr,
                        color: const Color(0xFFFF8E53),
                        trailing: IconButton(
                          icon: Icon(
                            _cameraAccess ? Icons.check_circle : Icons.error_outline,
                            color: _cameraAccess ? const Color(0xFF69F0AE) : const Color(0xFFFF6B6B),
                            size: 32,
                          ),
                          onPressed: _checkCameraPermission,
                        ),
                      ),

                      _buildSettingItem(
                        icon: Icons.person_pin_rounded,
                        title: 'account'.tr,
                        color: const Color(0xFFE040FB),
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
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'settings_title'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color(0xFF7C4DFF),
                      offset: Offset(0, 0),
                    ),
                  ],
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
    required Color color,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
      ),
    );
  }
}