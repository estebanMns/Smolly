import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../components/player_profile_controller.dart';
import '../../utils/navigation_service.dart';
import '../../components/lobby/lobby_menu.dart';
import '../../components/lobby/lobby_widgets.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});
  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;
  late final NavigationService _navigationService;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _navigationService = NavigationService(context: context);
    Get.put(PlayerProfileController());

    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 6, end: 22).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));

    _audioPlayer = AudioPlayer();
    _playLobbySong();
  }

  Future<void> _playLobbySong() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/LobbySong.mp3'));
  }

  Future<void> _navigateWithAudio(Future<void> Function() navigateAction) async {
    await _audioPlayer.pause();
    await navigateAction();
    // Resume when coming back to lobby
    await _audioPlayer.resume();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(child: Image.asset('assets/images/FondoLobby.jpg', fit: BoxFit.cover)),
          
          // Estrellas/Gradiente (Simplified StarField)
          Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x55000033), Color(0x22000000), Color(0x88000033)])))),

          // HUD Superior
          Positioned(top: MediaQuery.of(context).padding.top + 12, left: 16, right: 16, 
            child: TopHud(floatAnimation: _floatAnimation, onAvatarTap: () => _navigateWithAudio(_navigationService.navigateToPlayerProfile))),

          // Hero Section
          _buildHero(screenSize),

          // Menu Central
          Positioned(top: screenSize.height * 0.45, left: 0, right: 0,
            child: CenterMenuIcons(
              onCharacterTap: () => _navigateWithAudio(_navigationService.navigateToCharacters),
              onShopTap: () => _navigateWithAudio(_navigationService.navigateToShop),
              onRewardsTap: () => _navigateWithAudio(_navigationService.navigateToRewards),
              onAchievementsTap: () => _navigateWithAudio(_navigationService.navigateToAchievements),
              onStoryTap: () => _navigateWithAudio(_navigationService.navigateToStory),
            )),

          // Botón Play
          Positioned(bottom: screenSize.height * 0.18, left: 0, right: 0,
            child: Center(child: AnimatedBuilder(animation: _glowAnimation, 
              builder: (_, _) => PlayButton(glowRadius: _glowAnimation.value, onTap: () => _navigateWithAudio(_navigationService.navigateToLevelMap))))),

          // Bottom Nav
          Positioned(bottom: 0, left: 0, right: 0, 
            child: BottomNavigationCustom(onSettingsTap: () => _navigateWithAudio(_navigationService.navigateToSettings))),
        ],
      ),
    );
  }

  Widget _buildHero(Size size) {
    final controller = Get.find<PlayerProfileController>();

    return Positioned(top: size.height * 0.12, left: 0, right: 0,
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (_, _) => Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Column(children: [
            Obx(() {
              final avatarUrl = controller.player.value?.avatarUrl ?? '';
                return ClipOval(
                  child: Image.network(
                    avatarUrl.startsWith('http') ? avatarUrl : 'https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/kobu.jpeg', 
                    width: 130, height: 130, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network('https://tvjdkuitdsmqiyymzjto.supabase.co/storage/v1/object/public/avatares/kobu.jpeg', width: 130, height: 130, fit: BoxFit.cover),
                  ),
                );
            }),
            const SizedBox(height: 10),
            Text('title_login'.tr, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 5)),
          ]),
        ),
      ),
    );
  }
}