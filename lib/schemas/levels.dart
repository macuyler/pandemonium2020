import 'leaderboards.dart';
import '../db/names.dart';

class Level {
  String id;
  String name;
  int gameDuration; // seconds
  int numPatients; // number of
  int infectionRate; // 1 out of
  int houses; // number of
  int healTime; // seconds
  int order;
  Leaderboard leaderboard;
  Level(
      {this.id,
      this.name,
      this.gameDuration,
      this.numPatients,
      this.infectionRate,
      this.houses,
      this.healTime,
      this.order,
      this.leaderboard});

  Map<String, dynamic> toMap() {
    return {
      columnLevelId: this.id,
      columnName: this.name,
      columnGameDur: this.gameDuration,
      columnNumPat: this.numPatients,
      columnInfecRate: this.infectionRate,
      columnHouses: this.houses,
      columnHealTime: this.healTime,
      columnOrder: this.order,
      columnLeaderboardId: this.leaderboard.id,
    };
  }
}

bool equalLevels(List<Level> l1s, List<Level> l2s) {
  bool r = true;
  if (l1s.length != l2s.length) return false;
  for (int i = 0; i < l1s.length; i++) {
    Map<String, dynamic> l1 = l1s[i].toMap();
    Map<String, dynamic> l2 =
        l2s.where((e) => e.id == l1[columnLevelId]).single.toMap();
    l1.keys.forEach((key) {
      if (l1[key] != l2[key]) {
        r = false;
      }
    });
  }
  return r;
}
