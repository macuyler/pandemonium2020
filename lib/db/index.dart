import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../schemas/levels.dart';
import '../schemas/leaderboards.dart';

// Reference: https://pusher.com/tutorials/local-data-flutter

part 'names.dart';
part 'migrations.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "Pandemonium.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 5;

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
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion; i <= newVersion; i++) {
      if (i >= 5) {
        await db.execute(migrations[i - 5]);
      }
    }
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
          id: m[columnLevelId],
          name: m[columnName],
          gameDuration: m[columnGameDur],
          numPatients: m[columnNumPat],
          infectionRate: m[columnInfecRate],
          houses: m[columnHouses],
          healTime: m[columnHealTime],
          order: m[columnOrder],
          leaderboard: new Leaderboard());
      l.leaderboard.loadLeaders(m[columnLeaderboardId]);
      levels.add(l);
    });
    return levels;
  }

  Future<int> clearLevels() async {
    Database db = await database;
    return await db
        .delete(tableLevels, where: '$columnId != ?', whereArgs: [-1]);
  }

  // Scores API
  Future<int> insertScore(int score, String levelId) async {
    Database db = await database;
    Map<String, dynamic> scoreMap = {
      columnScore: score,
      columnLevelId: levelId,
    };
    int id = await db.insert(tableScores, scoreMap);
    return id;
  }

  Future<List> getLevelScores(String levelId) async {
    Database db = await database;
    List<Map> scoreMaps = await db.query(tableScores,
        columns: [columnScore],
        where: '$columnLevelId = ?',
        whereArgs: [levelId]);
    List<int> scores = [];
    scoreMaps.forEach((m) {
      scores.add(m[columnScore]);
    });
    return scores;
  }

  Future<int> clearLevelScores(String levelId) async {
    Database db = await database;
    return await db
        .delete(tableScores, where: '$columnLevelId = ?', whereArgs: [levelId]);
  }
}
