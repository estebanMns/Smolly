class AppConstants {
  // Supabase - Tablas
  static const String tableProfiles = 'perfiles';
  static const String tableLevels = 'niveles';
  static const String tableChapters = 'capitulos';

  // Supabase - Almacenamiento (Storage)
  static const String bucketAvatars = 'avatares';

  // Almacenamiento Local (Local Storage)
  static const String fileGameProgress = 'game_progress.json';
  static const String filePlayerProfile = 'player_profile.json';

  // Valores por Defecto - Jugador
  static const String defaultPlayerUid = 'u001';
  static const String defaultPlayerUsername = 'Perro Blanco';
  static const String defaultPlayerRank = 'COMANDANTE GALÁCTICO';
  static const int defaultXpToNextLevel = 1000;
  static const int xpIncreasePerLevel = 500;
}
