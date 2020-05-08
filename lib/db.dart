import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import './schemas/levels.dart';

// Reference: https://pusher.com/tutorials/local-data-flutter

// database table and column names
final String tableScores = 'scores';
final String tableLevels = 'levels';
final String columnId = '_id';
final String columnName = 'name';
final String columnGameDur = 'gameDuration';
final String columnNumPat = 'numPatients';
final String columnInfecRate = 'infectionRate';
final String columnHouses = 'houses';
final String columnHealTime = 'healTime';
final String columnScore = 'score';
final String columnLevelID = 'levelID';

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "Pandemonium.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 2;

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
      version: _databaseVersion,
      onCreate: _onCreate);
  }

  // SQL string to create the database 
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableLevels (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnGameDur INTEGER NOT NULL,
      $columnNumPat INTEGER NOT NULL,
      $columnInfecRate INTEGER NOT NULL,
      $columnHouses INTEGER NOT NULL,
      $columnHealTime INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableScores (
      $columnId INTEGER PRIMARY KEY,
      $columnScore INTEGER NOT NULL,
      $columnLevelID INTEGER NOT NULL,
      FOREIGN KEY($columnLevelID) REFERENCES $tableLevels($columnId)
      )
      ''');
  }


  // Levels API
  Future<int> insertLevel(Level level) async {
    Database db = await database;
    int id = await db.insert(tableLevels, level.toMap());
    return id;
  }

  Future<List> getLevels() async {
    Database db = await database;
    List<Map> levelMaps = await db.query(tableLevels);
    List<Level> levels = [];
    levelMaps.forEach((m) {
      Level l = new Level(
        id: m[columnId],
        name: m[columnName],
        gameDuration: m[columnGameDur],
        numPatients: m[columnNumPat],
        infectionRate: m[columnInfecRate],
        houses: m[columnHouses],
        healTime: m[columnHealTime]
      );
      levels.add(l);
    });
    return levels;
  }

  Future<int> clearLevels() async {
    Database db = await database;
    return await db.delete(tableLevels, where: '$columnId != ?', whereArgs: [-1]);
  }


  // Scores API
  Future<int> insertScore(int score, int levelId) async {
    Database db = await database;
    Map<String, dynamic> scoreMap = {
      columnScore: score,
      columnLevelID: levelId,
    };
    int id = await db.insert(tableScores, scoreMap);
    return id;
  }

  Future<List> getLevelScores(int levelId) async {
    Database db = await database;
    List<Map> scoreMaps = await db.query(tableScores,
      columns: [columnScore],
      where: '$columnLevelID = ?',
      whereArgs: [levelId]);
    List<int> scores = scoreMaps.map((m) => m[columnScore]);
    return scores;
  }
}