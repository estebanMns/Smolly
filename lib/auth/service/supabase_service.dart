import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juego_movil/models/player_model.dart';
import 'package:juego_movil/config/app_constants.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  Future<List<String>> getAvailableAvatars() async {
    try {
      final List<FileObject> objects = await _supabase.storage
          .from(AppConstants.bucketAvatars)
          .list();

      List<String> urls = [];
      for (var obj in objects) {
        final url = _supabase.storage.from(AppConstants.bucketAvatars).getPublicUrl(obj.name);
        urls.add(url);
      }
      return urls;
    } catch (e) {
      print('Error al listar los avatares: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final profileData = await _supabase
          .from(AppConstants.tableProfiles)
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return profileData;
    } catch (e) {
      print('Error al obtener perfil: $e');
      return null;
    }
  }

  // --- STORAGE / AVATARES ---

  Future<String?> uploadAvatar() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) return null;

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await _supabase.storage.from(AppConstants.bucketAvatars).uploadBinary(fileName, bytes);

      final String publicUrl = _supabase.storage
          .from(AppConstants.bucketAvatars)
          .getPublicUrl(fileName);

      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase
            .from(AppConstants.tableProfiles)
            .update({'avatar_url': publicUrl})
            .eq('id', user.id);
      }

      return publicUrl;
    } catch (e) {
      print('Error subiendo avatar: $e');
      return null;
    }
  }

  Future<void> selectExistingAvatar(String url) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.from(AppConstants.tableProfiles).update({
        'avatar_url': url,
      }).eq('id', user.id);
    }
  }

  Future<void> updateUserAvatar(String url) async {
    await selectExistingAvatar(url);
  }

  // 2. Método para seleccionar un avatar que ya existe
  Future<void> updateSelectedAvatar(String url) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      await _supabase.from(AppConstants.tableProfiles).update({
        'avatar_url': url, // Guardamos la URL de la imagen elegida
      }).eq('id', userId);
    }
  }

  // Método para actualizar el nombre de usuario
  Future<void> updateUsername(String newName) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.from(AppConstants.tableProfiles).update({
        'username': newName,
      }).eq('id', user.id);
    }
  }

  // Método para actualizar estadísticas de juego (Progreso)
  Future<void> updateGameStats(PlayerModel player) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        await _supabase.from(AppConstants.tableProfiles).update({
          'coins': player.coins,
          'level': player.level,
          'xp': player.xp,
          'xp_to_next_level': player.xpToNextLevel,
          'rank': player.rank,
          'scan_accuracy': player.scanAccuracy,
          'total_scans': player.totalScans,
          'dogs_collected': player.dogsCollected,
          'boosters_30s': player.boosters30s,
          'boosters_1m': player.boosters1m,
          'boosters_2m': player.boosters2m,
          'max_unlocked_level': player.maxUnlockedLevel,
        }).eq('id', user.id);
      } catch (e) {
        print('Error updating game stats (retrying without max_unlocked_level): $e');
        try {
          await _supabase.from(AppConstants.tableProfiles).update({
            'coins': player.coins,
            'level': player.level,
            'xp': player.xp,
            'xp_to_next_level': player.xpToNextLevel,
            'rank': player.rank,
            'scan_accuracy': player.scanAccuracy,
            'total_scans': player.totalScans,
            'dogs_collected': player.dogsCollected,
            'boosters_30s': player.boosters30s,
            'boosters_1m': player.boosters1m,
            'boosters_2m': player.boosters2m,
          }).eq('id', user.id);
        } catch (e2) {
          print('Error updating game stats fallback: $e2');
        }
      }
    }
  }

  // === MÉTODOS DE HISTORIAS Y NIVELES EN SUPABASE ===

  Future<List<Map<String, dynamic>>> fetchLevels() async {
    try {
      final response = await _supabase
          .from(AppConstants.tableLevels)
          .select()
          .order('id', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Aviso: Error fetching levels from Supabase, returning local configurations. Error: $e');
      return _getLocalLevels();
    }
  }

  Future<Map<String, dynamic>?> fetchChapter(int id) async {
    try {
      final response = await _supabase
          .from(AppConstants.tableChapters)
          .select()
          .eq('id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      print('Aviso: Error fetching chapter $id from Supabase, returning local fallback. Error: $e');
      return _getLocalChapter(id);
    }
  }

  List<Map<String, dynamic>> _getLocalLevels() {
    List<Map<String, dynamic>> list = [];
    for (int i = 0; i <= 21; i++) {
      final bool hasStory = [1, 4, 8, 12, 17, 20, 21].contains(i);
      List<Map<String, String>> targets;
      double limit;
      String name;
      
      if (i == 0) {
        name = 'molly_tutorial';
        targets = [{'targetObject': 'dog', 'displayName': 'molly_tutorial'}];
        limit = 120.0;
      } else if (i == 1) {
        name = 'game_ball';
        targets = [
          {'targetObject': 'sports ball', 'displayName': 'game_ball'},
          {'targetObject': 'bottle', 'displayName': 'water_bottle'},
          {'targetObject': 'cup', 'displayName': 'coffee_cup'},
        ];
        limit = 60.0;
      } else if (i == 2) {
        name = 'food_bowl';
        targets = [
          {'targetObject': 'bowl', 'displayName': 'food_bowl'},
          {'targetObject': 'book', 'displayName': 'book'},
          {'targetObject': 'keyboard', 'displayName': 'keyboard'},
        ];
        limit = 75.0;
      } else if (i == 3) {
        name = 'water_bottle';
        targets = [
          {'targetObject': 'bottle', 'displayName': 'water_bottle'},
          {'targetObject': 'cell phone', 'displayName': 'cell_phone'},
          {'targetObject': 'mouse', 'displayName': 'mouse'},
        ];
        limit = 50.0;
      } else if (i == 4) {
        name = 'coffee_cup';
        targets = [
          {'targetObject': 'cup', 'displayName': 'coffee_cup'},
          {'targetObject': 'laptop', 'displayName': 'laptop'},
          {'targetObject': 'chair', 'displayName': 'chair'},
        ];
        limit = 45.0;
      } else {
        name = 'Nivel $i';
        targets = [
          {'targetObject': 'person', 'displayName': 'human'},
          {'targetObject': 'tv', 'displayName': 'tv'},
          {'targetObject': 'backpack', 'displayName': 'backpack'},
        ];
        limit = (60 - i).clamp(20, 60).toDouble();
      }

      list.add({
        'id': i,
        'level_name': name,
        'time_limit': limit,
        'is_hard': i % 5 == 0,
        'targets': targets,
        'items_to_collect': 4 + (i % 3),
        'coins_reward': 50 + (i * 10),
        'unlocks_story': hasStory,
        'camera_notice': '',
      });
    }
    return list;
  }

  Map<String, dynamic>? _getLocalChapter(int id) {
    if (id == 1) {
      return {
        'id': 1,
        'title_key': 'chapter_1',
        'background_image': 'assets/images/fondomolly.png',
        'level_id': 1,
        'messages': [
          {'type': 'narrative', 'text_key': 'cap1_narrative_1'},
          {'type': 'dialogue', 'text_key': 'cap1_iker_1', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap1_molly_1', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap1_narrative_2'},
          {'type': 'dialogue', 'text_key': 'cap1_iker_2', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap1_molly_2', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'dialogue', 'text_key': 'cap1_iker_3', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap1_narrative_3'},
          {'type': 'dialogue', 'text_key': 'cap1_iker_4', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap1_molly_3', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap1_narrative_4'},
          {'type': 'dialogue', 'text_key': 'cap1_iker_5', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap1_molly_4', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap1_narrative_5'},
        ]
      };
    } else if (id == 2) {
      return {
        'id': 2,
        'title_key': 'chapter_2',
        'background_image': 'assets/images/fondomolly.png',
        'level_id': 2,
        'messages': [
          {'type': 'narrative', 'text_key': 'cap2_narrative_1'},
          {'type': 'dialogue', 'text_key': 'cap2_molly_1', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap2_iker_1', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap2_narrative_2'},
          {'type': 'dialogue', 'text_key': 'cap2_molly_2', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap2_iker_2', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap2_narrative_3'},
        ]
      };
    } else if (id == 3) {
      return {
        'id': 3,
        'title_key': 'chapter_3',
        'background_image': 'assets/images/fondokovu.png',
        'level_id': 3,
        'messages': [
          {'type': 'narrative', 'text_key': 'cap3_narrative_1'},
          {'type': 'dialogue', 'text_key': 'cap3_kovu_1', 'avatar_path': 'assets/images/kovu.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap3_iker_1', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap3_narrative_2'},
          {'type': 'dialogue', 'text_key': 'cap3_molly_1', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap3_kovu_2', 'avatar_path': 'assets/images/kovu.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap3_narrative_3'},
          {'type': 'dialogue', 'text_key': 'cap3_iker_2', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
        ]
      };
    } else if (id == 4) {
      return {
        'id': 4,
        'title_key': 'chapter_4',
        'background_image': 'assets/images/fondokovu.png',
        'level_id': 4,
        'messages': [
          {'type': 'narrative', 'text_key': 'cap4_narrative_1'},
          {'type': 'dialogue', 'text_key': 'cap4_iker_1', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap4_molly_1', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap4_narrative_2'},
          {'type': 'dialogue', 'text_key': 'cap4_molly_2', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap4_iker_2', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap4_narrative_3'},
          {'type': 'dialogue', 'text_key': 'cap4_molly_3', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': true}
        ]
      };
    } else if (id == 5) {
      return {
        'id': 5,
        'title_key': 'chapter_5',
        'background_image': 'assets/images/fondohorus.jpg',
        'level_id': 5,
        'messages': [
          {'type': 'narrative', 'text_key': 'cap5_narrative_1'},
          {'type': 'dialogue', 'text_key': 'cap5_horus_1', 'avatar_path': 'assets/images/horus.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap5_iker_1', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap5_narrative_2'},
          {'type': 'dialogue', 'text_key': 'cap5_horus_2', 'avatar_path': 'assets/images/horus.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap5_molly_1', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap5_narrative_3'}
        ]
      };
    } else if (id == 6) {
      return {
        'id': 6,
        'title_key': 'chapter_6',
        'background_image': 'assets/images/fondohorus.jpg',
        'level_id': 6,
        'messages': [
          {'type': 'narrative', 'text_key': 'cap6_narrative_1'},
          {'type': 'dialogue', 'text_key': 'cap6_iker_1', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap6_horus_1', 'avatar_path': 'assets/images/horus.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap6_narrative_2'},
          {'type': 'dialogue', 'text_key': 'cap6_molly_1', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap6_horus_2', 'avatar_path': 'assets/images/horus.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap6_narrative_3'}
        ]
      };
    } else if (id == 7) {
      return {
        'id': 7,
        'title_key': 'chapter_7',
        'background_image': 'assets/images/fondo_resultados.png',
        'level_id': 7,
        'messages': [
          {'type': 'narrative', 'text_key': 'cap7_narrative_1'},
          {'type': 'dialogue', 'text_key': 'cap7_iker_1', 'avatar_path': 'assets/images/iker.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap7_molly_1', 'avatar_path': 'assets/images/perroblanco.png', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap7_narrative_2'},
          {'type': 'dialogue', 'text_key': 'cap7_kovu_1', 'avatar_path': 'assets/images/kovu.jpeg', 'is_left': true},
          {'type': 'dialogue', 'text_key': 'cap7_horus_1', 'avatar_path': 'assets/images/horus.jpeg', 'is_left': false},
          {'type': 'narrative', 'text_key': 'cap7_narrative_3'}
        ]
      };
    }
    return null;
  }
}
