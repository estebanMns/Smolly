import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  Future<List<String>> getAvailableAvatars() async {
    try {
      final List<FileObject> objects = await _supabase.storage
          .from('avatares')
          .list();

      List<String> urls = [];
      for (var obj in objects) {
        final url = _supabase.storage.from('avatares').getPublicUrl(obj.name);
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
          .from('perfiles')
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

      await _supabase.storage.from('avatares').uploadBinary(fileName, bytes);

      final String publicUrl = _supabase.storage
          .from('avatares')
          .getPublicUrl(fileName);

      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase
            .from('perfiles')
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
      await _supabase.from('perfiles').update({
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
    await _supabase.from('perfiles').update({
      'avatar_url': url, // Guardamos la URL de la imagen elegida
    }).eq('id', userId);
  }
}
}
