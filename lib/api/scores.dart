import 'package:sqflite/sqflite.dart';
import '../db/index.dart';
import '../db/names.dart';

class ScoresApi {
  final DatabaseHelper _dh = DatabaseHelper.instance;

  Future<int> insertScore(int score, String levelId) async {
    Database db = await _dh.database;
    Map<String, dynamic> scoreMap = {
      columnScore: score,
      columnLevelId: levelId,
    };
    int id = await db.insert(tableScores, scoreMap);
    return id;
  }

  Future<List> getLevelScores(String levelId) async {
    Database db = await _dh.database;
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
    Database db = await _dh.database;
    return await db
        .delete(tableScores, where: '$columnLevelId = ?', whereArgs: [levelId]);
  }
}
