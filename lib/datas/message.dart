import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Message {
  static final Message instance = Message._init();

  static Database? _database;
  Message._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('message.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getApplicationCacheDirectory();
    final path = join(dbPath.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE message(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chat_id INTEGER,
        role TEXT,
        message TEXT,
        createdAt TEXT
      )
''');
  }

  Future<void> insertMessage(String message, String role, int chat_id) async {
    final db = await instance.database;
    await db.insert('message', {
      'message': message,
      'chat_id': chat_id,
      'role': role,
      'createdAt': DateTime.now().toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> listMessages(int id) async {
    final db = await instance.database;
    return await db.query('message', where: 'chat_id = ?', whereArgs: [id]);
  }

  Future<String> newMessages() async {
    final db = await instance.database;

    final result = await db.query(
      'message',
      columns: ['message'],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['message'] as String;
    } else {
      throw Exception('No todo items found');
    }
  }

  Future<void> deleteMessages(int chat_id) async {
    final db = await instance.database;

    await db.delete('message', where: 'chat_id = ?', whereArgs: [chat_id]);
  }
}
