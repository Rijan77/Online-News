import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../features/data/api/model_api.dart';


class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async{
    _database??=await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path =
    join(databasePath, 'online_news.db');

    return await openDatabase(
      path,
      version: 2, // Incremented version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Added onUpgrade callback
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_favorite(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        article_id TEXT UNIQUE,
        title TEXT,
        image_url TEXT,
        pub_date TEXT,
        email TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // If you need to migrate data from old schema to new schema
      await db.execute('DROP TABLE IF EXISTS user_favorite');
      await _onCreate(db, newVersion);
    }
  }

  Future<int> insertFavorite(NewsData news, String email) async {
    if (news.articleId == null) throw Exception('Article ID cannot be null');

    Database db = await instance.db;
    return await db.insert(
      'user_favorite',
      {
        'article_id': news.articleId,
        'title': news.title,
        'image_url': news.imageUrl,
        'pub_date': news.pubDate,
        'email': email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewsData>> getFavorites() async {
    Database db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_favorite',
      where: 'email = ?',
      whereArgs: [FirebaseAuth.instance.currentUser?.email],
    );

    return List.generate(maps.length, (i) {
      return NewsData(
        articleId: maps[i]['article_id'],
        title: maps[i]['title'],
        imageUrl: maps[i]['image_url'],
        pubDate: maps[i]['pub_date'],
      );
    });
  }

  Future<int> deleteFavorite(String articleId, String email) async {
    Database db = await instance.db;
    return await db.delete(
      'user_favorite',
      where: 'article_id = ? AND email = ?',
      whereArgs: [articleId, email],
    );
  }

  Future<bool> isFavorite(String articleId, String email) async {
    if (articleId.isEmpty) return false;

    Database db = await instance.db;
    final List<Map<String, dynamic>> result = await db.query(
      'user_favorite',
      where: 'article_id = ? AND  email = ?',
      whereArgs: [articleId, email],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}