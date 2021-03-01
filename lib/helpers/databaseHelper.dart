import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "myDatabase1.db";
  static final _databaseVersion = 1;

  static final table = 'assignment';

  static final columnId = '_id';
  static final name = 'name';
  static final mobile = 'mobile';
  static final amount = 'amount';
  static final productType = 'productType';
  static final amountType = 'amountType';
  static final date = 'date';
  static final image = "image";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $name TEXT NOT NULL,
            $mobile INTEGER NOT NULL,
            $amount TEXT NOT NULL,
            $amountType TEXT NOT NULL,
            $productType TEXT NOT NULL,
            $date DATE NOT NULL,
            $image TEXT NOT NULL

          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    print(db.path);
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<List<Map<String, dynamic>>> fetch() async {
    Database db = await instance.database;
    return db.rawQuery('SELECT * FROM $table WHERE $name="This"');
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
