import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'tables.dart';
import 'migrations.dart';

// Reference: https://pusher.com/tutorials/local-data-flutter

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "Pandemonium.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 6;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // When a new Database is created.
  Future _onCreate(Database db, int version) async {
    tables.forEach((tableQry) async {
      await db.execute(tableQry);
    });
  }

  // When an existing Database is upgraded.
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion; i < newVersion; i++) {
      String migration = migrations[i - 1];
      if (migration != '!') {
        await db.execute(migrations[i - 1]);
      }
    }
  }
}
