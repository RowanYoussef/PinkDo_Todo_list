import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static Database? _db;

//make sure that the batabase is initialized only once
  Future<Database?> get db async {
    _db ??= await init();
    return _db;
  }

//initialize database
  init() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'pinkdo.db');
    Database pinkdo_db = await openDatabase(path, onCreate: create);
    return pinkdo_db;
  }

//create database
  create(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "tasks"(
    id INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY 
    tasks TEXT NOT NULL
   )
   ''');
    print("create database");
  }
}
