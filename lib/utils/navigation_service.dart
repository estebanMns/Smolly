import 'package:flutter/material.dart';
import '../src/pages/player_profile_screen.dart';
import '../src/pages/level_map.dart';
import '../src/pages/characters_screen.dart';
import '../src/pages/settings_screen.dart'; 
import '../src/pages/shop_screen.dart';
import '../src/pages/rewards_screen.dart';
import '../src/pages/achievements.dart';
import '../src/pages/story_screen.dart';

class NavigationService {
  final BuildContext context;
  NavigationService({required this.context});

  Future<void> navigateToPlayerProfile() => _push(const PlayerProfileScreen());
  Future<void> navigateToLevelMap() => _push(const Levelmap());
  Future<void> navigateToCharacters() => _push(const CharactersScreen());
  Future<void> navigateToSettings() => _push(const SettingsScreen());
  Future<void> navigateToShop() => _push(const ShopScreen());
  Future<void> navigateToRewards() => _push(const RewardsScreen());
  Future<void> navigateToAchievements() => _push(const AchievementsScreen());
  Future<void> navigateToStory() => _push(const StoryScreen());

  Future<void> _push(Widget page) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}