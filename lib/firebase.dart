import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pandemonium2020/schemas/leaderboards.dart';
import './schemas/leaderboards.dart';
import './schemas/levels.dart';

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
