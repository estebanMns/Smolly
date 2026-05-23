import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:juego_movil/components/yolo/game_scan_controller.dart';
import 'package:juego_movil/components/yolo/smart_yolo_camera.dart';
import 'package:juego_movil/utils/item_translations.dart';
import 'package:juego_movil/models/level_model.dart';
import 'package:juego_movil/components/levels_controller.dart';
import 'package:juego_movil/components/player_profile_controller.dart';
import 'package:juego_movil/config/app_routes.dart';

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
  late final LevelModel _config;
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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
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

      // Cargar configuración dinámica de niveles usando LevelsController
      final levelsController = Get.find<LevelsController>();
      _config = levelsController.getLevel(_currentLevelId);

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
      final String fileContent = await rootBundle.loadString(
        'assets/labels.txt',
      );
      _allLabels = fileContent
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
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

      final int count = _config.itemsToCollect > 0 ? _config.itemsToCollect : 3;
      _randomTargets = shuffled.take(count).map((label) {
        final String displayName = itemTranslations[label] ?? label;
        return TargetItem(
          targetObject: label,
          displayName: displayName.toUpperCase(),
        );
      }).toList();
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
    if (_objectsScanned >= _config.itemsToCollect) {
      _timer?.cancel();
       Get.offNamed(
        AppRoutes.resultScreen,
        arguments: {
          'levelId': _currentLevelId,
          'score': _score,
          'coins': _config.coinsReward, // Usar la recompensa oficial del nivel cargada de Supabase
          'objectsScanned': _objectsScanned,
          'isVictory': true,
        },
      );
    }
  }

  void _handleTimeOut() {
    if (_objectsScanned >= 3) {
      Get.offNamed(
        AppRoutes.resultScreen,
        arguments: {
          'levelId': _currentLevelId,
          'score': _score,
          'coins': _config.coinsReward,
          'objectsScanned': _objectsScanned,
          'isVictory': true,
        },
      );
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
                _timer?.cancel(); // Cancelar timer anterior explícitamente
                _generateRandomTargets(); // Regenerar objetivos aleatorios e iniciar timer desde cero
              },
              child: const Text(
                'Volver a intentar',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
                Navigator.pushReplacementNamed(context, AppRoutes.levelMap);
              },
              child: const Text(
                'Salir',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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

  // --- LÓGICA DE USO DE POTENCIADORES ---

  void _useBooster(String type) {
    if (_isPaused) return;
    final controller = Get.find<PlayerProfileController>();
    final success = controller.consumeBooster(type);

    if (success) {
      double secondsToAdd = 0;
      if (type == '30s') secondsToAdd = 30;
      if (type == '1m') secondsToAdd = 60;
      if (type == '2m') secondsToAdd = 120;

      setState(() {
        _timeLeft += secondsToAdd;
        _maxTime += secondsToAdd;
      });

      Get.snackbar(
        '¡Potenciador Activado!',
        'Se han añadido $secondsToAdd segundos al temporizador.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.cyan.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Sin Potenciadores',
        'No tienes potenciadores de este tipo disponibles.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Widget _buildBoosterPanel() {
    final controller = Get.find<PlayerProfileController>();
    return Obx(() {
      final p = controller.player.value;
      if (p == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBoosterItem(
              icon: Icons.bolt,
              label: "+30s",
              count: p.boosters30s,
              color: Colors.orangeAccent,
              onTap: () => _useBooster('30s'),
            ),
            _buildBoosterItem(
              icon: Icons.speed,
              label: "+1m",
              count: p.boosters1m,
              color: Colors.cyanAccent,
              onTap: () => _useBooster('1m'),
            ),
            _buildBoosterItem(
              icon: Icons.hourglass_full,
              label: "+2m",
              count: p.boosters2m,
              color: Colors.greenAccent,
              onTap: () => _useBooster('2m'),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBoosterItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool hasBooster = count > 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: hasBooster ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: hasBooster ? color.withValues(alpha: 0.5) : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: hasBooster ? color : Colors.grey, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: hasBooster ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: hasBooster ? color.withValues(alpha: 0.3) : Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "x$count",
                style: TextStyle(
                  color: hasBooster ? Colors.white : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
    super.deactivate();
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
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.cyanAccent),
                  )
                : Column(
                    children: [
                      _buildTopBar(_config),

                      // ÁREA DE CÁMARA (CUADRO GRIS CON BORDES REDONDEADOS DE 20)
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // PANEL DE CONTROL DE POTENCIADORES DE TIEMPO
                      _buildBoosterPanel(),

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

  Widget _buildStatusOverlay(
    GameScanController controller,
    LevelModel config,
  ) {
    return Obx(() {
      final isFound = controller.isTargetFound.value;

      if (_randomTargets.isEmpty) return const SizedBox.shrink();

      final currentTarget =
          _randomTargets[_currentTargetIndex % _randomTargets.length];

      return Positioned(
        top: 20,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xff1f4475), // Color azul oscuro de Figma
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isFound
                    ? 'correct_object'.tr
                    : currentTarget.displayName.toUpperCase(),
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

  Widget _buildTopBar(LevelModel config) {
    double progressFactor = (_timeLeft / _maxTime).clamp(0.0, 1.0);
    Color timerColor = (_timeLeft <= 10.0)
        ? Colors.redAccent
        : const Color(0xffFBC741);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Icono de Pausa Integrado
          GestureDetector(
            onTap: _togglePause,
            child: Icon(
              _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: const Color(0xffF8F9B0),
              size: 26,
            ),
          ),
          const SizedBox(width: 8),

          // Icono del Reloj
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

          // Texto del temporizador
          Text(
            _formatTime(_timeLeft),
            style: TextStyle(
              color: (_timeLeft <= 10.0) ? Colors.redAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),

          // Línea del temporizador
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

          // Iconos informativos superiores
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(
    GameScanController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (!_isPaused) _togglePause();
              Get.toNamed('/settings_screen');
            },
            icon: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),

          // Botón central de Captura
          Obx(() {
            final isFound = controller.isTargetFound.value;
            return GestureDetector(
              onTap: () {
                if (_isPaused) return;
                if (isFound) {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(content: Text('capture_success'.tr)),
                  );
                  setState(() {
                    _objectsScanned++;
                    _score += 10;
                    _currentTargetIndex++;
                  });
                  _scanController.updateTargetObject(
                    _randomTargets[_currentTargetIndex % _randomTargets.length]
                        .targetObject,
                  );
                  _checkWinCondition();
                } else {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
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
                  size: 38,
                ),
              ),
            );
          }),

          IconButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.pushReplacementNamed(context, AppRoutes.levelMap);
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
        ],
      ),
    );
  }
}
