import 'package:cloud_firestore/cloud_firestore.dart';
import './schemas/levels.dart';

Future<List<Level>> getCloudLevels() async {
  dynamic fs = Firestore();
  QuerySnapshot snap = await fs.collection('levels').getDocuments();
  List<Level> levels = [];
  snap.documents.asMap().forEach((i, doc) {
    Level l = new Level(
      id: doc.documentID,
      name: doc.data['name'],
      gameDuration: doc.data['gameDuration'],
      numPatients: doc.data['numPatients'],
      infectionRate: doc.data['infectionRate'],
      houses: doc.data['houses'],
      healTime: doc.data['healTime'],
      order: doc.data['order']
    );
    levels.add(l);
  });
  return levels;
}
