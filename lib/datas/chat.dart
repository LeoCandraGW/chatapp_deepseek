import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Chat {
  static final Chat instance = Chat._init();

  static Database? _database;

  Chat._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('chat.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getApplicationCacheDirectory();
    final path = join(dbPath.path, filename);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE chat(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          createdAt TEXT
        )
''');
  }

  Future<void> createChat() async {
    final db = await instance.database;

    await db.insert('chat', {
      'createdAt': DateTime.now().toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchChat() async {
    final db = await instance.database;

    return await db.query('chat', orderBy: 'id DESC');
  }

  Future<void> deleteChat(int id) async {
    final db = await instance.database;

    await db.delete('chat', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> newChat() async {
    final db = await instance.database;

    final result = await db.query('chat', orderBy: 'id DESC', limit: 1);
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      throw Exception('No chat found');
    }
  }

  Future<void> addTitle(String title, int id) async {
    final db = await instance.database;

    await db.update('chat', {'title': title}, where: 'id = ?', whereArgs: [id]);
  }
}
