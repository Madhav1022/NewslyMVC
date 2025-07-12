import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/article.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();
  static Database? _database;

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'newsly.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks(
            id TEXT PRIMARY KEY,
            title TEXT,
            author TEXT,
            source TEXT,
            publishedAt TEXT,
            imageUrl TEXT,
            content TEXT,
            url TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertBookmark(Article article) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      article.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookmark(String id) async {
    final db = await database;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Article>> getBookmarks() async {
    final db = await database;
    final res = await db.query('bookmarks');
    return res.map((m) => Article.fromDb(m)).toList();
  }
}
