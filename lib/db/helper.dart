import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'names.dart';
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

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableLevels (
      $columnId INTEGER PRIMARY KEY,
      $columnLevelId TEXT NOT NULL,
      $columnName TEXT NOT NULL,
      $columnGameDur INTEGER NOT NULL,
      $columnNumPat INTEGER NOT NULL,
      $columnInfecRate INTEGER NOT NULL,
      $columnHouses INTEGER NOT NULL,
      $columnHealTime INTEGER NOT NULL,
      $columnOrder INTEGER NOT NULL,
      $columnLeaderboardId TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableScores (
      $columnId INTEGER PRIMARY KEY,
      $columnScore INTEGER NOT NULL,
      $columnLevelId TEXT NOT NULL,
      FOREIGN KEY($columnLevelId) REFERENCES $tableLevels($columnLevelId)
      )
      ''');
    await db.execute('''
    CREATE TABLE $tableSettings (
      $columnDisplayName TEXT NOT NULL,
      $columnUseFullScreen INTEGER NOT NULL DEFAULT 1 CHECK($columnUseFullScreen IN (0,1))
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('old: $oldVersion, new: $newVersion');
    for (int i = oldVersion; i < newVersion; i++) {
      String migration = migrations[i - 1];
      if (migration != '!') {
        await db.execute(migrations[i - 1]);
      }
    }
  }
}
