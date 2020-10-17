import 'package:cloud_firestore/cloud_firestore.dart';
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
        order: data['order']);
    levels.add(l);
  });
  return levels;
}

Future<List<Map<String, String>>> getCloudTutorials() async {
  dynamic fs = FirebaseFirestore.instance;
  QuerySnapshot snap = await fs.collection('tutorials').getDocuments();
  List<Map<String, String>> tutorials = new List(5);
  snap.docs.asMap().forEach((i, doc) {
    Map<String, dynamic> data = doc.data();
    tutorials[data['id']] = {
      'description': data['description'],
      'title': data['title']
    };
  });
  return tutorials;
}
