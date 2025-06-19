import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/news/data/models/news_model_api.dart';



class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    print('DB Path: $databasePath');
    String path = join(databasePath, 'online_news.db');

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
    Database db = await instance.db;
    return await db.insert(
      'user_favorite',
      {
        'article_id': news.articleId,
        'title': news.title,
        'image_url': news.imageUrl,
        'pub_date': news.pubDate.toIso8601String(),
        // 'pub_date': news.pubDate,
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
        pubDate: maps[i]['pub_date'] != null
            ? DateTime.parse(maps[i]['pub_date'])
            : DateTime.now(),
        description: maps[i]['description'],
        sourceName: maps[i]['sourceName'],
        sourceId: maps[i]['sourceId'],
        sourceUrl: maps[i]["sourceUrl"],
        sourceIcon: maps[i]["sourceIcon"]

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

  Future<int> countFavorites(String email) async {
    Database db = await instance.db;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM user_favorite WHERE email = ?',
        [email],
      ),
    );
    return count ?? 0;
  }

  Future<void> printDatabaseContents() async {
    final db = await instance.db;

    try {
      // Get all tables in the database
      List<Map> tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

      print('\n===== DATABASE CONTENTS =====');
      for (var table in tables) {
        String tableName = table['name'];
        print('\nTable: $tableName');

        // Skip system tables
        if (tableName == 'android_metadata' || tableName == 'sqlite_sequence') {
          continue;
        }

        // Print table structure
        List<Map> columns = await db.rawQuery("PRAGMA table_info($tableName)");
        print(
            'Columns: ${columns.map((c) => '${c['name']} (${c['type']})').toList()}');

        // Print table contents (with email filter for user_favorite)
        String whereClause = '';
        List<dynamic> whereArgs = [];

        if (tableName == 'user_favorite') {
          final userEmail = FirebaseAuth.instance.currentUser?.email;
          if (userEmail != null) {
            whereClause = 'email = ?';
            whereArgs = [userEmail];
          }
        }

        List<Map> contents = await db.query(
          tableName,
          where: whereClause.isNotEmpty ? whereClause : null,
          whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
          limit: 20,
        );

        print('Rows (${contents.length}):');
        for (var row in contents) {
          print(row);
        }
      }
      print('\n===== END OF DATABASE CONTENTS =====');
    } catch (e) {
      print('Error reading database: $e');
    }
  }

  Future<void> saveTheme(bool isDark) async {
    final db = await instance.db;
    await db.delete("ThemSettings");
    await db.insert("ThemSettings", {'isDark': isDark ? 1 : 0});
  }

  Future<bool> getSavedTheme() async {
    final db = await instance.db;
    final result = await db.query('ThemeSettings');
    if (result.isNotEmpty) {
      return result.first['isDark'] == 1;
    }
    return false; // default lightzz
  }
}
