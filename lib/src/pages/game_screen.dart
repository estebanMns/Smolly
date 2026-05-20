import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:juego_movil/components/yolo/game_scan_controller.dart';
import 'package:juego_movil/components/yolo/smart_yolo_camera.dart';
import 'package:juego_movil/config/app_colors.dart';
import 'level_detail.dart';

// ============================================================
// LÓGICA DE NIVELES (DIFERENCIACIÓN Y FONDO)
// ============================================================
class TargetItem {
  final String targetObject;
  final String displayName;

  TargetItem({required this.targetObject, required this.displayName});
}

class LevelGameData {
  final String levelName;
  final List<TargetItem> targets;
  final double timeLimit;
  final bool isHard;

  LevelGameData({
    required this.levelName,
    required this.targets,
    required this.timeLimit,
    this.isHard = false,
  });
}

final Map<int, LevelGameData> gameLevelConfigs = {
  0: LevelGameData(
    levelName: 'molly_tutorial'.tr,
    targets: [TargetItem(targetObject: "dog", displayName: 'molly_tutorial'.tr)],
    timeLimit: 120, 
  ),
  1: LevelGameData(
    levelName: 'game_ball'.tr,
    targets: [
      TargetItem(targetObject: "sports ball", displayName: 'game_ball'.tr),
      TargetItem(targetObject: "bottle", displayName: 'water_bottle'.tr),
      TargetItem(targetObject: "cup", displayName: 'coffee_cup'.tr),
    ],
    timeLimit: 60, 
  ),
  2: LevelGameData(
    levelName: 'food_bowl'.tr,
    targets: [
      TargetItem(targetObject: "bowl", displayName: 'food_bowl'.tr),
      TargetItem(targetObject: "book", displayName: 'book'.tr),
      TargetItem(targetObject: "keyboard", displayName: 'keyboard'.tr),
    ],
    timeLimit: 55, 
  ),
  3: LevelGameData(
    levelName: 'water_bottle'.tr,
    targets: [
      TargetItem(targetObject: "bottle", displayName: 'water_bottle'.tr),
      TargetItem(targetObject: "cell phone", displayName: 'cell_phone'.tr),
      TargetItem(targetObject: "mouse", displayName: 'mouse'.tr),
    ],
    timeLimit: 50,
  ), 
  4: LevelGameData(
    levelName: 'coffee_cup'.tr,
    targets: [
      TargetItem(targetObject: "cup", displayName: 'coffee_cup'.tr),
      TargetItem(targetObject: "laptop", displayName: 'laptop'.tr),
      TargetItem(targetObject: "chair", displayName: 'chair'.tr),
    ],
    timeLimit: 45, 
  ),
};

LevelGameData getLevelConfig(int id) {
  return gameLevelConfigs[id] ?? LevelGameData(
    levelName: 'human'.tr,
    targets: [
      TargetItem(targetObject: "person", displayName: 'human'.tr),
      TargetItem(targetObject: "tv", displayName: 'tv'.tr),
      TargetItem(targetObject: "backpack", displayName: 'backpack'.tr),
    ],
    timeLimit: (60 - id).clamp(20, 60).toDouble(),
    isHard: id % 5 == 0,
  );
}

// ============================================================
// PANTALLA DE JUEGO PRINCIPAL CON YOLO INTELIGENTE
// ============================================================
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late final AudioPlayer _audioPlayer;
  late final GameScanController _scanController;
  late final LevelDetailInfo _detail;
  late final LevelGameData _config;
  late final int _currentLevelId;

  // Variables para el temporizador dinámico
  Timer? _timer;
  late double _timeLeft;
  late double _maxTime;
  int _objectsScanned = 0;
  int _score = 0;
  int _currentTargetIndex = 0;
  bool _isPaused = false;
  
  List<String> _allLabels = [];
  bool _isLoadingLabels = true;
  List<TargetItem> _randomTargets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      _audioPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (!_isPaused) {
        _audioPlayer.resume();
      }
    }
  }

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _currentLevelId = args['levelId'];

      _detail = levelDetailsList.firstWhere((l) => l.id == _currentLevelId);
      _config = getLevelConfig(_currentLevelId);

      _maxTime = _config.timeLimit;
      _timeLeft = _maxTime;
      
      _scanController = Get.put(
        GameScanController(targetObject: "item"),
        tag: 'level_$_currentLevelId',
      );

      _playLevelMusic();
      _loadLabels();
    }
  }

  Future<void> _loadLabels() async {
    try {
      final String fileContent = await rootBundle.loadString('assets/labels.txt');
      _allLabels = fileContent.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    } catch (e) {
      print("Error loading labels: $e");
      // Fallback a los quemados
      _allLabels = _config.targets.map((t) => t.targetObject).toList();
    }
    _generateRandomTargets();
  }

  void _generateRandomTargets() {
    if (_allLabels.isNotEmpty) {
      final random = Random();
      final List<String> shuffled = List.from(_allLabels)..shuffle(random);
      
      final int count = _detail.itemsToCollect > 0 ? _detail.itemsToCollect : 3;
      _randomTargets = shuffled.take(count).map((label) => TargetItem(
        targetObject: label,
        displayName: label.toUpperCase(),
      )).toList();
    } else {
      _randomTargets = _config.targets;
    }
    
    _scanController.updateTargetObject(_randomTargets.first.targetObject);

    if (mounted) {
      setState(() {
        _isLoadingLabels = false;
        _objectsScanned = 0;
        _score = 0;
        _currentTargetIndex = 0;
        _timeLeft = _maxTime;
        _isPaused = false;
      });
      _startTimer();
      _checkWinCondition();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || _isPaused) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft -= 0.1;
        } else {
          _timer?.cancel();
          _handleTimeOut();
        }
      });
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.resume();
      }
    });
  }

  void _checkWinCondition() {
    // Si alcanza la cantidad máxima de objetos del nivel, puede ganar de una vez.
    if (_objectsScanned >= _detail.itemsToCollect) {
      _timer?.cancel();
      Get.offNamed('/result_screen', arguments: {
        'levelId': _currentLevelId,
        'score': _score,
        'coins': _score ~/ 2, // 1 moneda por cada 2 puntos
        'objectsScanned': _objectsScanned,
        'isVictory': true,
      });
    }
  }

  void _handleTimeOut() {
    // Cuando el tiempo llega a 00:00 verificamos si alcanzó el mínimo de 3 objetos
    if (_objectsScanned >= 3) {
      Get.offNamed('/result_screen', arguments: {
        'levelId': _currentLevelId,
        'score': _score,
        'coins': _score ~/ 2,
        'objectsScanned': _objectsScanned,
        'isVictory': true,
      });
    } else {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1f4475),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            '¡Tiempo Agotado!', 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Perdiste. Necesitas haber escaneado al menos 3 objetos para pasar este nivel.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFBC741),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
                _timer?.cancel(); // Cancelar timer anterior explícitamente
                _generateRandomTargets(); // Regenerar objetivos aleatorios e iniciar timer desde cero
              },
              child: const Text(
                'Volver a intentar',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Regresa de forma segura a LevelDetailScreen
              },
              child: const Text(
                'Salir',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // Formateador para mostrar el tiempo tipo MM:SS
  String _formatTime(double timeInSeconds) {
    if (timeInSeconds < 0) timeInSeconds = 0;
    int minutes = timeInSeconds ~/ 60;
    int seconds = (timeInSeconds % 60).toInt();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _playLevelMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/Niveles.mp3'));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. FONDO ASSET DE LOS NIVELES FIJO (DISEÑO FIGMA)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoniveles.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. CONTENIDO DEL JUEGO
          SafeArea(
            child: _isLoadingLabels 
                ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
                : Column(
              children: [
                _buildTopBar(_detail, _config),

                // ÁREA DE CÁMARA (CUADRO GRIS CON BORDES REDONDEADOS DE 20)
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildDetectionCamera(_scanController),
                          _buildStatusOverlay(_scanController, _config),
                          if (_isPaused)
                            Container(
                              color: Colors.black.withValues(alpha: 0.6),
                              child: const Center(
                                child: Text(
                                  "JUEGO PAUSADO",
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // BOTONES INFERIORES ESTILO FIGMA
                Expanded(
                  flex: 2,
                  child: _buildBottomControls(_scanController, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionCamera(GameScanController controller) {
    if (_isPaused) return Container(color: Colors.black);
    return SmartYoloCamera(
      onResult: (results) {
        if (!_isPaused) {
          controller.onDetectionResults(results);
        }
      },
    );
  }

  Widget _buildStatusOverlay(GameScanController controller, LevelGameData config) {
    return Obx(() {
      final isFound = controller.isTargetFound.value;
      
      // Seguridad si _randomTargets no se ha cargado (no debería pasar por _isLoadingLabels)
      if (_randomTargets.isEmpty) return const SizedBox.shrink();
      
      final currentTarget = _randomTargets[_currentTargetIndex % _randomTargets.length];
      
      return Positioned(
        top: 20,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xff1f4475), // Color azul oscuro del contenedor de Figma
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isFound ? 'correct_object'.tr : currentTarget.displayName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.5,
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
    double progressFactor = (_timeLeft / _maxTime).clamp(0.0, 1.0);
    // Cambiar a color rojo si el tiempo es menor o igual a 10 segundos
    Color timerColor = (_timeLeft <= 10.0) ? Colors.redAccent : const Color(0xffFBC741);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Icono de Pausa Integrado al inicio
          GestureDetector(
            onTap: _togglePause,
            child: Icon(
              _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: const Color(0xffF8F9B0),
              size: 26,
            ),
          ),
          const SizedBox(width: 8),

          // Icono del Reloj (Contenedor de 30x30 con tamaño corregido de 24 para evitar desbordes)
          SizedBox(
            width: 30,
            height: 30,
            child: Icon(
              Icons.access_time_filled_rounded, 
              color: const Color(0xffF8F9B0), 
              size: 24,
            ),
          ),
          const SizedBox(width: 6),
          
          // Texto del temporizador (Cambia a rojo en los últimos 10 segundos)
          Text(
            _formatTime(_timeLeft),
            style: TextStyle(
              color: (_timeLeft <= 10.0) ? Colors.redAccent : Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),

          // Línea del temporizador que va disminuyendo
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: timerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          
          // Iconos informativos superiores (Color F8F9B0)
          _buildTopIcon(Icons.sports_basketball_rounded, "$_objectsScanned"),
          const SizedBox(width: 12),
          _buildTopIcon(Icons.pets_rounded, "$_score"),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xffF8F9B0), size: 22),
        const SizedBox(width: 4),
        Text(
          label, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildBottomControls(GameScanController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Configuración -> Redirige correctamente a settings_screen.dart sin colgar el árbol de estados
          IconButton(
            onPressed: () {
              if (!_isPaused) _togglePause(); // Pausa automáticamente al entrar a ajustes
              Get.toNamed('/settings_screen');
            },
            icon: const Icon(Icons.settings_rounded, color: Colors.white, size: 44),
          ),
          
          // Botón central de Captura (Amarillo según Figma)
          Obx(() {
            final isFound = controller.isTargetFound.value;
            return GestureDetector(
              onTap: () {
                if (_isPaused) return; // Desactiva captura en pausa
                if (isFound) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('capture_success'.tr)),
                  );
                  setState(() {
                    _objectsScanned++;
                    _score += 10;
                    _currentTargetIndex++;
                  });
                  _scanController.updateTargetObject(_randomTargets[_currentTargetIndex % _randomTargets.length].targetObject);
                  _checkWinCondition();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('not_detected_yet'.tr)),
                  );
                }
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFBC741),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined, 
                  color: Colors.white, 
                  size: 38
                ),
              ),
            );
          }),

          // Salida -> Redirige de vuelta de forma segura a la pantalla level_detail.dart
          IconButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.of(context).pop(); // Regresa de forma segura a LevelDetailScreen
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 44),
          ),
        ],
      ),
    );
  }
}