import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pandemonium2020/schemas/leaderboards.dart';
import './schemas/leaderboards.dart';
import './schemas/levels.dart';
import './api/scores.dart';
import './api/settings.dart';

Future<List<Level>> getCloudLevels() async {
  dynamic fs = FirebaseFirestore.instance;
  QuerySnapshot snap = await fs.collection('levels').getDocuments();
  List<Level> levels = [];
  snap.docs.asMap().forEach((i, doc) {
    Map<String, dynamic> data = doc.data();
    Level l = new Level(
        id: doc.id,
        name: data['name'],
        gameDuration: data['gameDuration'],
        numPatients: data['numPatients'],
        infectionRate: data['infectionRate'],
        houses: data['houses'],
        healTime: data['healTime'],
        order: data['order'],
        leaderboard: new Leaderboard());
    l.leaderboard.loadLeaders(data['leaderboard']);
    levels.add(l);
  });
  return levels;
}

// TODO: Prevent saving lower scores.
void saveHighScores() async {
  dynamic fs = FirebaseFirestore.instance;
  ScoresApi scoresApi = new ScoresApi();
  SettingsApi settingsApi = new SettingsApi();
  List<Level> levels = await getCloudLevels();
  String displayName = await settingsApi.getDisplayName();
  levels.forEach((level) async {
    List<int> scores = await scoresApi.getLevelScores(level.id);
    int highScore = scores.isNotEmpty ? scores.reduce(max) : 0;
    if (highScore > 0) {
      fs
          .collection('leaderboards')
          .doc(level.leaderboard.id)
          .collection('scores')
          .doc(displayName)
          .set({'score': highScore});
    }
  });
}
