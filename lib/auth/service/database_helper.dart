import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:juego_movil/models/player_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('game_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Creamos la tabla basada en tu PlayerModel con potenciadores
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE player (
        uid TEXT PRIMARY KEY,
        username TEXT,
        avatarUrl TEXT,
        coins INTEGER,
        level INTEGER,
        xp INTEGER,
        xpToNextLevel INTEGER,
        rank TEXT,
        scanAccuracy REAL,
        totalScans INTEGER,
        dogsCollected INTEGER,
        boosters30s INTEGER DEFAULT 0,
        boosters1m INTEGER DEFAULT 0,
        boosters2m INTEGER DEFAULT 0
      )
    ''');
  }

  // Manejo de actualización de base de datos para usuarios existentes
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE player ADD COLUMN boosters30s INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE player ADD COLUMN boosters1m INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE player ADD COLUMN boosters2m INTEGER DEFAULT 0');
      } catch (e) {
        print('Error running database upgrade: $e');
      }
    }
  }

  // === OPERACIONES CRUD ===

  // Guardar o actualizar jugador
  Future<void> savePlayer(PlayerModel player) async {
    final db = await instance.database;
    await db.insert(
      'player',
      player.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Si existe, lo actualiza
    );
  }

  // Obtener los datos del jugador
  Future<PlayerModel?> getPlayer() async {
    final db = await instance.database;
    final maps = await db.query('player', limit: 1);

    if (maps.isNotEmpty) {
      return PlayerModel.fromJson(maps.first);
    }
    return null;
  }

  // Actualizar solo las monedas (ejemplo rápido)
  Future<void> updateCoins(String uid, int newCoins) async {
    final db = await instance.database;
    await db.update(
      'player',
      {'coins': newCoins},
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }
}