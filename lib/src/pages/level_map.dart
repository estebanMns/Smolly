import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/player_profile_controller.dart';

// ============================================================
// MODELO DE DATOS
// ============================================================

enum LevelStatus { locked, available, completed, tutorial }

class LevelData {
  final int id;
  final String name;
  final LevelStatus status;
  final bool isBossLevel;
  final int row;
  final int col;

  LevelData({
    required this.id,
    required this.name,
    required this.status,
    this.isBossLevel = false,
    required this.row,
    required this.col,
  });
}

// ============================================================
// WIDGET PRINCIPAL
// ============================================================

class Levelmap extends StatefulWidget {
  const Levelmap({super.key});

  @override
  State<Levelmap> createState() => _LevelmapState();
}

class _LevelmapState extends State<Levelmap> with TickerProviderStateMixin {
  late List<LevelData> levels;
  final ScrollController _scrollController = ScrollController();

  late AnimationController _characterController;
  late Animation<double> _characterBounce;
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  int _currentLevelIndex = 0; 

  @override
  void initState() {
    super.initState();
    _initializeLevels();

    _characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _characterBounce = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  @override
  void dispose() {
    _characterController.dispose();
    _glowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentLevel() {
    if (_currentLevelIndex >= 0 && _currentLevelIndex < levels.length) {
      final screenHeight = MediaQuery.of(context).size.height;
      final scrollPosition = (_currentLevelIndex * 120.0) - (screenHeight / 4);
      
      _scrollController.animateTo(
        scrollPosition.clamp(0.0, double.infinity),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void _initializeLevels() {
    levels = List.generate(21, (index) {
      LevelStatus status;
      if (index == 0) {
        status = LevelStatus.tutorial;
      } else if (index == 1) {
        status = LevelStatus.completed;
      } else if (index == 2) {
        status = LevelStatus.available;
      } else {
        status = LevelStatus.locked;
      }
      
      final row = (index / 3).floor(); 
      final col = index % 3;
      
      return LevelData(
        id: index,
        name: index == 0 ? 'tutorial'.tr : '${'level'.tr} $index',
        status: status,
        isBossLevel: index > 0 && index % 5 == 0,
        row: row,
        col: col,
      );
    });
    _currentLevelIndex = 0; 
  }

  Offset _getLevelPosition(LevelData level, double screenWidth) {
    final double horizontalPadding = screenWidth * 0.12; 
    final double availableWidth = screenWidth - (horizontalPadding * 2);
    final double columnWidth = availableWidth / 3;
    
    double xPos;
    if (level.row.isEven) {
      xPos = horizontalPadding + (level.col * columnWidth) + (columnWidth / 2);
    } else {
      xPos = horizontalPadding + ((2 - level.col) * columnWidth) + (columnWidth / 2);
    }
    
    final double yPos = 200 + (level.row * 140.0);
    return Offset(xPos, yPos);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondolevels.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.25)),
          _buildScrollView(size),
          _buildHeader(),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildScrollView(Size screenSize) {
    final totalHeight = 200 + ((levels.length / 3).ceil() * 140.0) + 200;

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: screenSize.width,
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // SOLUCIÓN AL ERROR: Pasamos directamente el Painter, no un widget CustomPaint
            CustomPaint(
              size: Size(screenSize.width, totalHeight),
              painter: _PathCustomPainter(
                levels: levels,
                getLevelPosition: _getLevelPosition,
                screenWidth: screenSize.width,
              ),
            ),

            ...levels.map((level) {
              final position = _getLevelPosition(level, screenSize.width);
              return _buildLevelNode(level, position);
            }),

            if (_currentLevelIndex >= 0)
              _buildCharacter(
                _getLevelPosition(levels[_currentLevelIndex], screenSize.width),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelNode(LevelData level, Offset position) {
    final double nodeSize = level.isBossLevel ? 75.0 : 65.0;

    return Positioned(
      left: position.dx - nodeSize / 2,
      top: position.dy - nodeSize / 2,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 300 + (level.id * 50)),
        curve: Curves.elasticOut,
        builder: (_, value, child) => Transform.scale(scale: value, child: child),
        child: GestureDetector(
          onTap: () => _onLevelTap(level),
          child: _LevelNode(
            level: level,
            size: nodeSize,
            glowAnim: _glowAnim,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacter(Offset levelPos) {
    const double characterSize = 55.0;
    const double floatAbove = 70.0;
    final controller = Get.find<PlayerProfileController>();

    return AnimatedBuilder(
      animation: _characterBounce,
      builder: (_, child) {
        return Positioned(
          left: levelPos.dx - characterSize / 2,
          top: levelPos.dy - floatAbove + _characterBounce.value,
          child: child!,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: characterSize,
            height: characterSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.7),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipOval(
              child: Obx(() {
                final avatarUrl = controller.player.value?.avatarUrl ?? '';
                return Image.network(
                  avatarUrl.startsWith('http') ? avatarUrl : 'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/kobu.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 30),
                );
              }),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              'you'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.purpleAccent.withValues(alpha: 0.6),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              'level_map_title'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
                shadows: [
                  Shadow(color: Colors.purpleAccent, blurRadius: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _onLevelTap(LevelData level) {
    if (level.status == LevelStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.white),
              const SizedBox(width: 10),
              Text('level_locked_msg'.tr),
            ],
          ),
          backgroundColor: Colors.purple[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    Navigator.pushNamed(
      context,
      '/level-detail',
      arguments: {'levelId': level.id, 'levelName': level.name},
    );
  }
}

// ============================================================
// CLASE CORREGIDA: CUSTOM PAINTER
// ============================================================

class _PathCustomPainter extends CustomPainter {
  final List<LevelData> levels;
  final Offset Function(LevelData, double) getLevelPosition;
  final double screenWidth;

  _PathCustomPainter({
    required this.levels,
    required this.getLevelPosition,
    required this.screenWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < levels.length - 1; i++) {
      final p1 = getLevelPosition(levels[i], screenWidth);
      final p2 = getLevelPosition(levels[i + 1], screenWidth);
      
      final isLocked = levels[i+1].status == LevelStatus.locked;
      final activePaint = isLocked ? dashPaint : paint;

      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      
      final controlPoint1 = Offset(p1.dx, p1.dy + (p2.dy - p1.dy) / 2);
      final controlPoint2 = Offset(p2.dx, p2.dy - (p2.dy - p1.dy) / 2);
      
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        p2.dx, p2.dy,
      );

      canvas.drawPath(path, activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// WIDGET: NODO DE NIVEL
// ============================================================

class _LevelNode extends StatelessWidget {
  final LevelData level;
  final double size;
  final Animation<double> glowAnim;

  const _LevelNode({
    required this.level,
    required this.size,
    required this.glowAnim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, _) {
        final glow = (level.status == LevelStatus.available || 
                      level.status == LevelStatus.tutorial) 
            ? glowAnim.value 
            : 1.0;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _gradient(),
            boxShadow: _shadow(glow),
            border: Border.all(
              color: _borderColor(),
              width: (level.status == LevelStatus.available || 
                      level.status == LevelStatus.tutorial) ? 3.5 : 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _centerIcon(),
              if (level.isBossLevel) _bossBadge(),
            ],
          ),
        );
      },
    );
  }

  Widget _centerIcon() {
    switch (level.status) {
      case LevelStatus.locked:
        return Icon(
          Icons.lock_rounded,
          color: Colors.white.withValues(alpha: 0.6),
          size: size * 0.42,
        );
      case LevelStatus.completed:
        return Icon(
          Icons.star_rounded,
          color: Colors.amber[300],
          size: size * 0.52,
        );
      case LevelStatus.tutorial:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_rounded, color: Colors.white, size: 28),
            SizedBox(height: 2),
            Text('0', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        );
      case LevelStatus.available:
        return Text(
          '${level.id}',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.42,
            fontWeight: FontWeight.bold,
            shadows: const [Shadow(color: Colors.black45, blurRadius: 4)],
          ),
        );
    }
  }

  Widget _bossBadge() => Positioned(
        top: -2,
        right: -2,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Color(0xFFFF3B30),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.red, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 16),
        ),
      );

  Gradient _gradient() {
    switch (level.status) {
      case LevelStatus.locked:
        return const LinearGradient(colors: [Color(0xFF4a4a5a), Color(0xFF2a2a3a)]);
      case LevelStatus.tutorial:
        return const LinearGradient(colors: [Color(0xFFB794F6), Color(0xFF805AD5)]);
      case LevelStatus.available:
        return const LinearGradient(colors: [Color(0xFF00d2ff), Color(0xFF0070f3)]);
      case LevelStatus.completed:
        return const LinearGradient(colors: [Color(0xFFf093fb), Color(0xFFf5576c)]);
    }
  }

  Color _borderColor() {
    if (level.status == LevelStatus.available || level.status == LevelStatus.tutorial) {
      return Colors.white;
    }
    return Colors.white.withValues(alpha: 0.3);
  }

  List<BoxShadow> _shadow(double glow) {
    switch (level.status) {
      case LevelStatus.locked:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ];
      case LevelStatus.tutorial:
      case LevelStatus.available:
        return [
          BoxShadow(
            color: (level.status == LevelStatus.tutorial ? Colors.purpleAccent : Colors.cyanAccent)
                .withValues(alpha: 0.6 * glow),
            blurRadius: 15 * glow,
            spreadRadius: 2 * glow,
          ),
        ];
      case LevelStatus.completed:
        return [
          BoxShadow(
            color: Colors.pinkAccent.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ];
    }
  }
}