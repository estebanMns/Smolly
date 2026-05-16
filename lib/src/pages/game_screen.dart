import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juego_movil/components/yolo/game_scan_controller.dart';
import 'package:juego_movil/components/yolo/smart_yolo_camera.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'level_detail.dart';

// ============================================================
// LÓGICA DE NIVELES (DIFERENCIACIÓN Y FONDO)
// ============================================================
class LevelGameData {
  final String targetObject; // Debe coincidir con labels.txt (COCO)
  final String displayName;  // Nombre amigable para el usuario
  final double timeLimit;
  final bool isHard;
  final String backgroundImage;

  LevelGameData({
    required this.targetObject,
    required this.displayName,
    required this.timeLimit,
    this.isHard = false,
    required this.backgroundImage,
  });
}

// Mapa de configuración para los niveles (Mapeado a etiquetas COCO reales)
final Map<int, LevelGameData> gameLevelConfigs = {
  0: LevelGameData(
    targetObject: "dog", 
    displayName: 'molly_tutorial'.tr,
    timeLimit: 120, 
    backgroundImage: 'assets/images/fondomolly.png',
  ),
  1: LevelGameData(
    targetObject: "sports ball", 
    displayName: 'game_ball'.tr,
    timeLimit: 60, 
    backgroundImage: 'assets/images/fondogame_level1.png',
  ),
  2: LevelGameData(
    targetObject: "bowl", 
    displayName: 'food_bowl'.tr,
    timeLimit: 55, 
    backgroundImage: 'assets/images/fondogame_level2.png',
  ),
  3: LevelGameData(
    targetObject: "bottle", 
    displayName: 'water_bottle'.tr,
    timeLimit: 50, 
    backgroundImage: 'assets/images/fondogame_story.png',
  ), 
  4: LevelGameData(
    targetObject: "cup", 
    displayName: 'coffee_cup'.tr,
    timeLimit: 45, 
    backgroundImage: 'assets/images/fondogame_level1.png',
  ),
};

LevelGameData getLevelConfig(int id) {
  return gameLevelConfigs[id] ?? LevelGameData(
    targetObject: "person", 
    displayName: 'human'.tr,
    timeLimit: (60 - id).clamp(20, 60).toDouble(),
    isHard: id % 5 == 0,
    backgroundImage: 'assets/images/fondogame_generic.png', 
  );
}

// ============================================================
// PANTALLA DE JUEGO PRINCIPAL CON YOLO INTELIGENTE
// ============================================================
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int levelId = args['levelId'];
    
    final detail = levelDetailsList.firstWhere((l) => l.id == levelId);
    final config = getLevelConfig(levelId);

    // Inicializamos el controlador de escaneo para este nivel
    final scanController = Get.put(
      GameScanController(targetObject: config.targetObject),
      tag: 'level_$levelId',
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. FONDO ASSET
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(config.backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Container(color: Colors.black.withValues(alpha: 0.3)),

          // 2. CONTENIDO DEL JUEGO
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(detail, config),

                // ÁREA DE CÁMARA (SmartYoloCamera detecta soporte)
                Expanded(
                  flex: 7,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildDetectionCamera(scanController),
                      _buildStatusOverlay(scanController, config),
                    ],
                  ),
                ),

                // BOTONES INFERIORES
                Expanded(
                  flex: 2,
                  child: _buildBottomControls(scanController, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionCamera(GameScanController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: -5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      // USAMOS SmartYoloCamera en lugar de YOLOView directamente
      child: SmartYoloCamera(
        onResult: (results) {
          controller.onDetectionResults(results);
        },
      ),
    );
  }

  Widget _buildStatusOverlay(GameScanController controller, LevelGameData config) {
    return Obx(() {
      final isFound = controller.isTargetFound.value;
      final color = isFound ? Colors.greenAccent : (config.isHard ? Colors.redAccent : Colors.cyanAccent);
      
      return Positioned(
        top: 30,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.8), width: 2),
                boxShadow: [
                  if (isFound) BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.4), blurRadius: 20)
                ],
              ),
              child: Text(
                isFound ? 'correct_object'.tr : config.displayName.toUpperCase(),
                style: TextStyle(
                  color: isFound ? Colors.greenAccent : Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            if (isFound)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'tap_to_capture'.tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTopBar(LevelDetailInfo detail, LevelGameData config) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: config.isHard ? Colors.redAccent : Colors.cyanAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          _buildTopIcon(Icons.category_rounded, "${detail.itemsToCollect}", Colors.amber),
          const SizedBox(width: 10),
          _buildTopIcon(Icons.monetization_on_rounded, "${detail.coinsReward}", AppColors.gold),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomControls(GameScanController controller, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircleButton(Icons.help_outline_rounded, () {}),
          
          Obx(() {
            final isFound = controller.isTargetFound.value;
            return GestureDetector(
              onTap: () {
                if (isFound) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('capture_success'.tr)),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('not_detected_yet'.tr)),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFound ? Colors.greenAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: isFound ? Colors.greenAccent : Colors.cyanAccent, 
                    width: 3
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isFound ? Colors.greenAccent : Colors.cyanAccent).withValues(alpha: 0.3), 
                      blurRadius: 15
                    ),
                  ],
                ),
                child: Icon(
                  isFound ? Icons.check_circle_outline : Icons.camera_alt_rounded, 
                  color: Colors.white, 
                  size: 38
                ),
              ),
            );
          }),

          _buildCircleButton(Icons.location_on_rounded, () {}),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white70, size: 32),
    );
  }
}