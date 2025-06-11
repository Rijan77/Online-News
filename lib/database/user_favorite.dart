//
//
// import 'package:news_app/database/database_helper.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class UserFavorite {
//
//   static final UserFavorite instance = UserFavorite._instance();
//   static Database? _database;
//
//   UserFavorite._instance();
//
//   Future<Database> get db async{
//     _database??= await initDb();
//
//     return _database!;
//   }
//
//   Future<Database> initDb()  async{
//     String databasePath = await getDatabasesPath();
//     String path = join(databasePath, "Online_news");
//
//     return await openDatabase(
//         path,
//         version: 2,
//         onCreate: _onCreate,
//         onUpgrade: _onUpgrade;
//     );
//   }
//   Future _onCreate(Database db, int version) async{
//     await db.execute('''CREATE ''');
//   }
//
//
//
// }