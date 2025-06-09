import 'package:news_app/database/user_favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final DatabaseHelper instance= DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async{
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'online_news.db');

    return await openDatabase(path, version: 1,  onCreate: _onCreate);
  }

  Future _onCreate (Database db, int version)async{
    await db.execute('''CREATE TABLE user_favorite(
    id INTEGER PRIMARY KEY,
    email TEXT,
    isFavorite NUMERIC
    )'''
    );

  }

  Future<int> insertFavorite(UserFavorite userFavorite) async {
    Database db = await instance.db;
    return await db.insert('user_favorite', userFavorite.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('user_favorite');
  }

  Future<int> deleteFavorite(int id) async {
    Database db = await instance.db;
    return await db.delete('user_favorite', where: 'id = ?', whereArgs: [id]);
  }

}