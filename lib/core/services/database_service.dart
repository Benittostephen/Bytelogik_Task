import 'dart:convert';
import 'package:byte_logik/feature/auth/models/user.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, password TEXT, created_at TEXT)',
        );
      },
    );
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> createUser(String email, String password) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);

      final user = User(
        email: email,
        password: hashedPassword,
        createdAt: DateTime.now(),
      );

      await db.insert('users', user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, hashedPassword],
      );

      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> userExists(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
