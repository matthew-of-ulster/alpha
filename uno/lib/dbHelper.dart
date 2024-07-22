import 'memo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  static final Dbhelper _databaseService = Dbhelper._internal();
  factory Dbhelper() => _databaseService;
  Dbhelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'procrastinate_db4.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE memos(id INTEGER AUTO_INCREMENT, title TEXT, description TEXT, createdDate DATETIME, putOffCount INTEGER, PRIMARY KEY(id))',
    );
  }

  Future<void> insertMemo(Memo memo) async {
    final db = await _databaseService.database;
    await db.insert(
      'memos',
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memo>> memos() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('memos');
    return List.generate(maps.length, (index) => Memo.fromMap(maps[index]));
  }

  Future<void> updateMemo(Memo memo) async {
    final db = await _databaseService.database;
    await db
        .update('memos', memo.toMap(), where: 'id = ?', whereArgs: [memo.id]);
  }

  Future<void> deleteMemo(int id) async {
    final db = await _databaseService.database;
    await db.delete('memos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllMemo() async {
    final db = await _databaseService.database;
    await db.delete('memos', where: 'id > -1');
  }
}
