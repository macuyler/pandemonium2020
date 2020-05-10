class Level {
  String id;
  String name;
  int gameDuration; // seconds
  int numPatients; // number of
  int infectionRate; // 1 out of
  int houses; // number of
  int healTime; // seconds
  int order;
  Level({ this.id, this.name, this.gameDuration, this.numPatients, this.infectionRate, this.houses, this.healTime, this.order });

  Map<String, dynamic> toMap() {
    return {
      'levelID': this.id,
      'name': this.name,
      'gameDuration': this.gameDuration,
      'numPatients': this.numPatients,
      'infectionRate': this.infectionRate,
      'houses': this.houses,
      'healTime': this.healTime,
      'levelOrder': this.order
    };
  }
}

bool equalLevels(List<Level> l1s, List<Level> l2s) {
  bool r = true;
  if (l1s.length != l2s.length) return false;
  for (int i = 0; i < l1s.length; i++) {
    Map<String, dynamic> l1 = l1s[i].toMap();
    Map<String, dynamic> l2 = l2s[i].toMap();
    l1.keys.forEach((key) {
      if (l1[key] != l2[key]) {
        r = false;
      }
    });
  }
  return r;
}