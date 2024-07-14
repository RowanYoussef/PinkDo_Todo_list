import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static Database? _db;

//make sure that the batabase is initialized only once
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

//initialize database
  init() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'pinkdo.db');
    Database pinkdoDb = await openDatabase(path,
        onCreate: _create, version: 3, onUpgrade: _upgrade);
    return pinkdoDb;
  }

//create database
  _create(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "tasks" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
    "task" TEXT NOT NULL,
    "completed" INTEGER,
    "Description" Text,
    "DeadLine" Text
   )
   ''');
    await db.execute('''
    CREATE TABLE "wishes" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
    "wish" TEXT NOT NULL,
    "completed" INTEGER,
    "Description" Text
   )
   ''');
    print("create database");
  }

//upgrade database
  _upgrade(Database db, int oldVersion, int newVersion) {
    print("upgrade");
  }

  //select function
  readData(String value) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(value);
    return response;
  }

  //insert function
  insertData(String value) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(value);
    return response;
  }

  //update function
  updateData(String value) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(value);
    return response;
  }

  //delete function
  deleteData(String value) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(value);
    return response;
  }

  //delete database
  deleteDb() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'pinkdo.db');
    await deleteDatabase(path);
  }

  // Delete all tasks
  Future<void> deleteAllTasks() async {
     Database?mydb = await db;
     int response = await mydb!.rawDelete("DELETE FROM tasks");
     await mydb!.execute("UPDATE sqlite_sequence SET seq = 0 WHERE name = 'tasks'");
  }
  
  //Delete all wishes
    Future<void> deleteAllwishes(String s) async {
     Database?mydb = await db;
     int response = await mydb!.rawDelete("DELETE FROM wishes");
     await mydb!.execute("UPDATE sqlite_sequence SET seq = 0 WHERE name = 'wishes'");
  }

}
