import 'package:sqflite/sqflite.dart';
import '../db/index.dart';
import '../db/names.dart';
import '../schemas/levels.dart';
import '../schemas/leaderboards.dart';

class LevelsApi {
  final DatabaseHelper _dh = DatabaseHelper.instance;

  Future<int> insertLevel(Level level) async {
    Database db = await _dh.database;
    int id = await db.insert(tableLevels, level.toMap());
    return id;
  }

  Future<List> getLevels() async {
    Database db = await _dh.database;
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
    Database db = await _dh.database;
    return await db
        .delete(tableLevels, where: '$columnId != ?', whereArgs: [-1]);
  }
}
