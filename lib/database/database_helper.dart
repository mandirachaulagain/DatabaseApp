import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the user table
  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE users (
      id $idType,
      name $textType
    )
    ''');
  }

  // Save a user
  Future<void> saveUser(int userId, String userName) async {
    final db = await instance.database;
    await db.insert('users', {'id': userId, 'name': userName});
  }

  // Fetch all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  // Remove a user by ID
  Future<void> removeUser(int userId) async {
    final db = await instance.database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }
}
